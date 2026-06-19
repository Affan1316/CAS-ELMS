# CAS-ELMS (Center for Advanced Solutions - E-Learning Management System)

[![Flutter Version](https://img.shields.io/badge/Flutter-3.7.2%2B-blue.svg?logo=flutter)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Backend-Firebase-orange.svg?logo=firebase)](https://firebase.google.com)
[![BLoC State Management](https://img.shields.io/badge/State--Management-BLoC-red.svg)](https://pub.dev/packages/flutter_bloc)
[![License](https://img.shields.io/badge/License-Proprietary-black.svg)](#)

CAS-ELMS is a state-of-the-art E-Learning Management System developed for the **Center for Advanced Solutions (CAS)**. Serving as an enterprise learning and operations management system, it combines institutional management with location-based workshop tracking and interactive Generative AI capabilities.

> [!NOTE]
> This repository showcases Affan's engineering contributions to **CAS-ELMS**, developed as part of a collaborative engineering team. It highlights backend integration, transactional security, enterprise billing systems, and architectural refactoring.

---

## 👥 Project Context & Attribution

- **Original Codebase Link**: [aqibtufail7546/CAS-ELMS](https://github.com/aqibtufail7546/CAS-ELMS) *(Note: Access is restricted as this is a private repository)*
- **Collaborative Engineering Team**:
  *   **Affan** (Fee & Payments System, Student Profile & Management, Core Architecture) - *[GitHub Profile](https://github.com/Affan1316)*
  *   **Muhammad Aqib** (Auth & Onboarding, Quizzes & Certifications, Landing & Dashboard UI, Platform Configuration) - *[GitHub Profile](https://github.com/aqibtufail7546)*
  *   **Fasih ur Rehman (kFasih132)** (Geofencing & Attendance, Chat System)
  *   **Mahameer Muhammad** (Leaves & Requests, Courses & Assignments, Student Inquiries)
  *   **Saim Riaz** (Group Management & Early Landing Layouts)
- **Fork Purpose**: This public repository serves as a showcase of individual engineering work completed by **Affan** on this 5-person team.

---

## 🛠️ My Engineering Contributions

I engineered the financial, security, and administrative backbone of CAS-ELMS. Here is an easy-to-read summary of what I built and why it matters:

| Subsystem | What I Built (User & Business Value) | How I Built It (Technical Summary) |
| :--- | :--- | :--- |
| 💳 **Financial Billing Engine** | **Flexible payment plans for students.** Admins can split fees into monthly milestones, support partial payments, rollover unpaid dues, or apply student tuition discounts with automatic math recalculation. | Firestore document designs, rollover logic (`addToPendingFee`), and dynamic discount re-amortization (`decreaseFeeInFavour`). |
| 🔒 **Anti-Fraud Payment Gateway** | **Double-phase payment approvals.** To prevent errors or employee fraud, payment records logged by staff admins remain *pending* until verified/approved by a Super-Admin. | Atomic Firestore transactions (`runTransaction`), state segregation, and duplicate-write ledger prevention. |
| ⚠️ **Overdue Defaulter Flags** | **Automated balance alerts.** Scans student installment timelines to flag overdue accounts and aggregate late fee analytics without causing database lag. | Date checking algorithms, BLoC state events, and pre-aggregated dashboards to avoid system slowdowns. |
| 📊 **Daily Financial Audits** | **Clear cash-flow sheets.** Isolates daily school earnings by transaction gateway (e.g., cash vs. bank transfer) to make ledger audits easy. | Index-optimized Firestore queries filtered by exact dates and payment channels. |
| ⚙️ **Performance Refactoring** | **Stable app state & navigation.** Upgraded screen switching transitions, resolved state-loss bugs, and added strict verification layers to enrollment fields. | Declarative `GoRouter` setup, state separation via `BLoC`, and `async/await` write validation checks. |

---

<details>
<summary>🔍 Click to expand/collapse technical implementation details</summary>

### 1. Dynamic Financial & Installment Billing Engine
To support non-standard student payment capacities, a flexible billing engine was designed within Firestore (`student_installment`):
*   **Dynamic Milestone Generation (`createStudentWithInstallments`):** Automatically creates 30-day spaced billing milestones, maintaining a frontloaded "Admission Fee" separate from standard course tuition installments.
*   **Grace Periods & Rollover Logic (`addToPendingFee2`):**
    *   *Skipped Months:* If an admin marks an installment payment as `$0` ("skipped"), the system flags it, marks it paid, and rolls the due balance onto the next installment.
    *   *Partial Payments:* If a student makes a partial payment, the engine processes the payment, marks the milestone as `pending`, and automatically redistributes the remaining unpaid balance to the next installment.
*   **Waiver/Discount (Favour) System (`decreaseFeeInFavour`):** A re-amortization algorithm that recalculates all remaining unpaid installments when an admin applies a tuition discount ("favour"), scaling monthly dues down dynamically.

### 2. Double-Phase Transactional Approval Pipeline
To prevent accounting fraud and concurrency errors, a strict Admin-to-Super-Admin payment authorization pipeline was implemented:
*   **Atomic State Progression:**
    1.  Admin logs a payment (`pay_fee_modal.dart`) → Status is marked `pending` and cached in `not_approved_fee_installments`.
    2.  Super Admin reviews approvals (`confirmPayment` or `confirmBulkPayments`).
    3.  The installment is atomically written to the main `student_installment` document as `Paid`.
*   **Concurrency Control:** Firestore Transactions (`runTransaction`) inside `SuperAdminFeeRepositoryImpl` lock documents during approvals, preventing double-submission bugs and race conditions.
*   **Deduplication Safety Net (`_writePaymentHistory`):** Queries the day-wise transaction index before updates to prevent duplicate cash ledger entries.

### 3. Defaulter Tracking & Suspension Logic
*   **Automated Flagging:** Automatically scans due dates and flags overdue student accounts (`fee_defaulters.dart`).
*   **Administrative Overrides:** Leverages BLoC events (`AddFeeDefaulterEvent` and `RemoveStudentFromDefaultersEvent`) to whitelist or manually flag accounts.
*   **Write-Heavy Dashboard Optimization:** Wrote database hooks (`removeFromDefaulter` and `UpdateCollectiveFeeDefaultersDataGroupwise`) that pre-aggregate group-wide outstanding balances in `fee_defaulters_collective_data` in real time, avoiding heavy $O(N)$ read storms.

### 4. Day-Wise Ledger Auditing & Reporting
*   **Cash Flow Isolation (`DayWiseFeePage.dart`):** Compiles daily collection sheets grouping receipts by payment channel (e.g., Cash vs. Bank Transfer) for easy daily till reconciliation.
*   **Date-Range Filtering:** Implemented index-optimized queries (`fetchFeesByDateRange`) using Firestore timestamps.

### 5. Architectural & Structural Refactoring
To improve application performance and stability, I executed several structural refactorings across the codebase:
*   **Navigation Architecture:** Refactored the app-wide routing from imperative `Navigator.push` to declarative `GoRouter` setups, resolving state-loss issues when navigating between background geofencing modules and admin portals.
*   **State Management:** Structured features using the BLoC pattern (`FeeAdminBloc`, `StudentFeatureBloc`), ensuring unidirectional data flow and clean separation of concerns.
*   **Form Validation & Write Safety:** Fixed critical bugs in the student enrollment pipeline, resolving a double-submission bug in `student_feature_bloc.dart` and adding `async/await` guards in `add_student_use_case.dart` to prevent incomplete or corrupted records.

</details>

---

## 🌟 Core Subsystems & Features

### 1. Student Portal
*   **Course Progress Mapping:** Rich, graphical maps charting learning pathways using [fl_chart](https://pub.dev/packages/fl_chart).
*   **Academics:** Attempt quizzes (`student_quiz_page`), view detailed course materials, and submit assignments.
*   **Administrative Actions:** Log leave requests, view attendance history, and make payments.
*   **AI Chat Assistant:** Dynamic learning companion powered by **Google Generative AI (Gemini)** to solve coding questions and clarify course contents.

### 2. Administrator Portal
*   **Course & Instructor Management:** Complete CRUD interface to register instructors and manage course catalogues.
*   **Student Enrollment:** Provision student accounts and map them into specific academic groups.
*   **Attendance & Auditing:** View consolidated student attendance records and track student transfer audits across cohorts.
*   **Administrative Reviews:** Approve/reject student leave requests and resolve student inquiries.

### 3. Background Geofenced Attendance System
To ensure classroom and workshop integrity, CAS-ELMS features automated attendance logging via physical location boundaries:
*   **Geofencing Monitoring:** Monitors whether a student is within a registered latitude/longitude radius using [geolocator](https://pub.dev/packages/geolocator) and [native_geofence](https://pub.dev/packages/native_geofence).
*   **Automated Time Tracker:** Integrates with [workmanager](https://pub.dev/packages/workmanager) and [flutter_foreground_task](https://pub.dev/packages/flutter_foreground_task) to log student workshop time (check-in/check-out) in the background even if the app is closed.
*   **Local Notifications:** Alerts students when they enter or leave a geofenced area using [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications).

---

## 🛠️ Technology Stack

*   **Core Framework:** Flutter (Dart SDK `^3.7.2`)
*   **State Management:** BLoC (`flutter_bloc ^9.1.1` & `bloc_concurrency`) for predictable, reactive UI updates.
*   **Dependency Injection:** `get_it ^8.2.0` for clean inversion of control.
*   **Database & Backend:** Firebase Core, Cloud Firestore, and Firebase AI integration.
*   **AI Capabilities:** `google_generative_ai ^0.4.7` and `firebase_ai ^3.6.0` (Gemini API integration).
*   **Design & Theme:** 
    *   Neumorphic aesthetics using `flutter_neumorphic_plus` and `clay_containers`.
    *   Dynamic micro-animations powered by `animate_do` and `flutter_animate`.
    *   Typography built on `google_fonts` (Inter/Outfit palettes).
*   **Local Databases:** `hive_flutter` (local storage caching) & `sqflite` (relational query needs).

---

## 📂 Project Architecture

The codebase follows a clean, feature-first modular structure, which keeps features decoupled and highly maintainable:

```text
lib/
├── firebase_options.dart      # Platform-specific Firebase credentials (generated)
├── main.dart                  # Application entry point, BLoC providers initialization
└── src/
    ├── auth/                  # Global authentication layer (services, repositories, states)
    ├── core/                  # Shared core services, utilities, themes, routing
    │   ├── dependencies/      # Inversion of Control / dependency injection (get_it setup)
    │   ├── routing/           # Navigation routes configuration (GoRouter setup)
    │   └── theme/             # Light, dark, and sky blue custom color palettes
    ├── features/              # Modular application features
    │   ├── Chat_Page/         # AI Chat page with Google Generative AI (Gemini)
    │   ├── elms_landing/      # Public/Unauthenticated informational screens
    │   ├── fee_feature/       # Admin-side fee workflows
    │   ├── leave_request/     # Leave approval pipelines
    │   ├── student_feature/   # Student dashboard & academic pages
    │   ├── super_admin_feature/# Super Admin controls & analytics dashboards
    │   ├── workshop_geofencing/# Location tracking & Geofence callbacks
```

---

## 🎨 Styling & Design Guidelines

CAS-ELMS implements a signature **Sky Blue & Neumorphic** design language defined in [app_colors.dart](file:///D:/planing/CAS-ELMS/lib/src/core/theme/app_colors.dart). 

*   **Primary Theme Accent:** Sky Blue (`#4FC3F7`) & Dark Sky Blue (`#0288D1`).
*   **Layout & Elements:** Neumorphic shadow offsets (soft white upper-left light-source shadows paired with dark grey/blue bottom-right drop-shadows) create a tactile, physical look.
*   **Typography:** Google Fonts (Inter, Outfit, and custom sans-serif scales) are used dynamically to adapt to different screen dimensions.
*   **Responsiveness:** Elements are wrapped inside a global `ResponsiveLayoutProvider` from the `responsive_ui_kit` package to guarantee interface scaling across Wear OS, smartphones, tablets, and web views.
