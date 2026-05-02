# CAS-ELMS Geofencing Attendance — Complete Fix Reference

> This is a memory document for continuing this work in a different project/conversation.
> Original conversation: `1f2c3184-7545-45c9-9c1d-f2f9d56b65f0`

---

## THE PROBLEMS

### Bug #1 — Attendance NOT marked (but time tracking works)
- User stays 2+ hours in geofence
- Sessions saved to Hive correctly, time tracked correctly  
- BUT Firestore attendance document never written

### Bug #2 — Impossible tracked time (26+ hours, 31+ hours)
- Attendance marked successfully
- BUT duration becomes overnight accumulation (e.g. 9 AM yesterday → 11 AM today = 26 hours)

### Bug #3 — Force-kill / swipe-away doesn't close session
- Controlled stop (notification button / internal stopService) works perfectly
- But swipe-away / force-stop / task-manager kill leaves session open
- EXIT attendance not marked, time tracking corrupted

---

## ROOT CAUSES IDENTIFIED

### Bug #1 Root Causes
1. **`rollNo` empty-string bug** — `setRollNo(null)` stored `""` instead of removing key. `getRollNo()` returned `""` which passed `!= null` but was an invalid Firestore doc ID → silent write failure
2. **`TimerForAttendance` state was in-memory only** — `isMarked` and `_minutesPassed` were `static` variables that reset on process death. If service killed before 5 mins, attendance never marked. If restarted, counter reset to 0.
3. **Uninitialized `FireStoreRepository` passed to timer** — `onReceiveData` created `FireStoreRepository()` at line 101 and initialized it at line 106, but `startTimer()` at line 116 created a NEW `FireStoreRepository()` that was never init'd
4. **`getCurrentDate()` throws if auto-time disabled** — caught silently in timer, preventing attendance write

### Bug #2 Root Causes  
1. **Stale `checkInTime` persists across days** — SharedPreferences survives process death but `checkInTime` was never cleared on force-kill. Next day, `onEnter()` saw `checkInTime != null` and skipped setting new time → exit calculated `now - yesterday = 26h`
2. **WorkManager exit task had `NetworkType.connected` constraint** — if no network when killed, exit deferred indefinitely
3. **`getTotalDurationOfToday()` summed ALL sessions** — didn't filter by date, so cross-day sessions accumulated
4. **`onDestroy` only scheduled WorkManager, didn't do exit directly** — WorkManager has 5s delay + constraints + can be cancelled by force-stop

---

## WHAT WE FIXED (5 FILES)

### File 1: `shared_preference_repository.dart`
**Path:** `lib/src/features/workshop_geofencing/Domain/repository/shared_preference_repository.dart`

Changes:
- `setRollNo(null)` → now calls `prefs.remove()` instead of storing `""`
- `getRollNo()` → returns `null` for empty strings (defensive)
- **NEW** `setAttendanceMarked(String dateKey)` — persists attendance-marked flag with date
- **NEW** `isAttendanceMarkedForDate(String dateKey)` — checks if already marked for a date
- **NEW** `setAttendanceMinutesPassed(int minutes)` — persists timer progress
- **NEW** `getAttendanceMinutesPassed()` — reads persisted timer progress
- **NEW** `resetAttendanceTimerState()` — clears both attendance keys
- **NEW** keys: `attendanceMarkedDate`, `attendanceMinutesPassed`

---

### File 2: `hive_repository.dart`
**Path:** `lib/src/features/workshop_geofencing/Domain/repository/hive_repository.dart`

Changes:
- `getTotalDurationOfToday()` — now filters sessions by today's date (year/month/day match) to prevent cross-day accumulation
- `createRecord()` — added `await firestore.init()` before Firestore writes (defensive init for background recovery paths)

---

### File 3: `geofence_sevice.dart`
**Path:** `lib/src/features/workshop_geofencing/Data/services/geofence_sevice.dart`

Changes:
- `onEnter()` — **stale session detection**: if `checkInTime` exists but is from a different day, force-closes the orphaned session before allowing new entry
- `onEnter()` — `setCheckInTime` is now `await`ed (was fire-and-forget)
- `onExit()` — **restructured**: early-returns when no active session (avoids unnecessary `getCurrentDate()` call)
- `onExit()` — `getCurrentDate()` wrapped in try-catch with `DateTime.now()` fallback
- `onExit()` — calls `resetAttendanceTimerState()` after clearing checkInTime
- `dispose()` — calls `resetAttendanceTimerState()`
- **NEW** `_closeOrphanedSession()` — closes orphaned session with end-of-day (23:59:59) as checkout time
- **NEW** `recoverOrphanedSession()` — public method callable from startup/onStart, detects stale sessions from previous day

---

### File 4: `work_manager_service.dart`
**Path:** `lib/src/features/workshop_geofencing/Data/services/work_manager_service.dart`

Changes:
- `registerOneOfTask()` constraint changed: `NetworkType.connected` → `NetworkType.notRequired` (exit cleanup must not be blocked by connectivity)
- `callbackDispatcher()` — added `orphanCleanupTask` handler
- **NEW** constant `orphanCleanupTask`
- **NEW** `orphanCleanupFunc()` — calls `recoverOrphanedSession`
- **NEW** `registerOrphanCleanupTask()` — periodic task every 6 hours, no network required

---

### File 5: `location_service.dart`
**Path:** `lib/src/features/workshop_geofencing/Data/services/location_service.dart`

Changes to `LocationTaskHandler`:
- `onStart()` — added `await s.init()` + calls `MyGeofenceService.recoverOrphanedSession()` for startup recovery
- `onDestroy()` — **KEY FIX**: now performs synchronous `onExit()` FIRST, THEN schedules WorkManager as fallback. Both wrapped in try-catch with logging.
- `onReceiveData()` — passes already-initialized `fireStoreRepository` to `startTimer()` instead of creating new uninitialized instance

Changes to `TimerForAttendance`:
- `startTimer()` — **guards duplicate timers** (returns if `_attendanceTimer != null`)
- `startTimer()` — **restores persisted state** from SharedPreferences (`_minutesPassed`, `isMarked`)
- `startTimer()` — **skips timer** if already marked for today
- Timer tick — **persists `_minutesPassed`** to SharedPreferences each minute
- Timer tick — **validates rollNo** with explicit null/empty check and error logging
- Timer tick — **calls `firestore.init()`** defensively inside callback
- Timer tick — **retries on failure** instead of stopping timer (rollNo null → retry next minute, exception → retry next minute)
- Timer tick — **persists `isMarked`** via `setAttendanceMarked(dateKey)` on success
- `stopTimer()` — only cancels timer, does NOT reset persisted state (reset happens in `resetAttendanceTimerState` when session fully closes)

---

## DEFENSE-IN-DEPTH STRATEGY (4 LAYERS)

```
Layer 1: Synchronous onExit in onDestroy     → catches swipe-away
Layer 2: WorkManager exitTask (no network)   → fallback, survives process death
Layer 3: Periodic orphan cleanup (every 6h)  → safety net via WorkManager
Layer 4: Startup recovery in onStart/onEnter → guaranteed catch-all for force-stop
```

---

## STILL TODO (not implemented yet)
- `registerOrphanCleanupTask()` needs to be called from app initialization code (wherever geofencing system is set up)
- Consider adding file-based logging for debugging in production (current `dv.log` / `debugPrint` logs are lost on process death)

---

## KEY ARCHITECTURAL NOTES
- All repos are singletons but background isolates get separate instances — `init()` must be called in each isolate
- Hive is NOT safe for concurrent multi-isolate access — could corrupt data if main app and WorkManager run simultaneously
- Firestore has `persistenceEnabled: true` so writes will sync when online
- `getCurrentDate()` throws if auto-time/timezone disabled on device — always needs try-catch with `DateTime.now()` fallback in critical paths
- `formatDate()` produces `dd-MM-yyyy` format — this is the Firestore document ID format for attendance and workshop time
