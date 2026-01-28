import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/entities/fee_defaulter_entity.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/entities/fee_defaulters_collective.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/entities/fee_entity_class.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/entities/fee_installment_entity_class.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/entities/student_fee_feature_entity_class.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/domain/abstract_repo/abstract_implemetation_installment_repo.dart';
import 'package:uuid/uuid.dart';

class ActualImplemetationInstallmentRepo implements AbstractInstallmentRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();
  @override
  /// Creates / replaces the document in student_installment/{studentId}
  Future<void> createStudentWithInstallments({
    required double paidAmount,
    required String studentId,
    required String name,
    required String groupId,
    required double totalFee,
    required int numberOfInstallments,
  }) async {
    try {
      final double amountPerMonth = totalFee / numberOfInstallments;

      final List<Map<String, dynamic>> installments = List.generate(
        numberOfInstallments,
        (i) {
          final dueDate = DateTime.now().add(Duration(days: 30 * (i + 1)));
          final FeeInstallmentEntityClass inst = FeeInstallmentEntityClass(
            id: _uuid.v4(),
            title: 'Installment ${i + 1}',
            totalAmount: amountPerMonth,
            dueDate: dueDate,
            paidDate: null,
            paymentMethod: null,
            status: 'Unpaid',
            paidAmount: paidAmount,
          );
          return inst.toMap();
        },
      );

      final Map<String, dynamic> payload = {
        'id': studentId,
        'name': name,

        "paidAmount": paidAmount,

        'groupId': groupId,
        'totalFee': totalFee,
        'numberOfInstallments': numberOfInstallments,
        'amountPerMonth': amountPerMonth,
        'installments': installments,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await _firestore
          .collection('student_installment')
          .doc(studentId)
          .set(payload, SetOptions(merge: true));
      var docRef = FirebaseFirestore.instance
          .collection('fee_history_group_wise')
          .doc(groupId);
      DocumentSnapshot<Map<String, dynamic>> snapshot = await docRef.get();
      if (!snapshot.exists) {
        await docRef.set({
          "total": totalFee,
          "received": 0,
          // "remaining": totalFee,
        });
      } else {
        Map<String, dynamic>? mapOfData = snapshot.data();
        double previousTotal;
        double newTotal;
        // double newRemaining;
        // double previousRemaining;
        if (mapOfData != null) {
          previousTotal = mapOfData["total"];
          // previousRemaining = mapOfData["remaining"];
          newTotal = totalFee + previousTotal;
          // newRemaining = newTotal - previousRemaining;
          mapOfData["total"] = newTotal;
          // mapOfData["remaining"] = newRemaining;
          docRef.set(mapOfData);
        }
      }
    } catch (e) {
      throw Exception('Failed to create installment plan: $e');
    }
  }

  @override
  Future<StudentFeeFeatureEntityClass?> getStudent(String studentId) async {
    try {
      final doc =
          await _firestore
              .collection('student_installment')
              .doc(studentId)
              .get();

      if (!doc.exists) {
        print("<<<<<<<<doc does not exits >>>>>>>>>>>");
        return null;
      }
      final data = doc.data()!;
      debugPrint("fetched student data is $data");

      final Map<String, dynamic> normalized = {
        'id': data['id'] ?? studentId,
        'name': data['name'] ?? '',
        'groupId': data['groupId'] ?? '',
        'totalFee': data['totalFee'] ?? 0,
        'paidAmount': data['paidAmount'] ?? 0,

        'installments':
            (data['installments'] as List<dynamic>? ?? [])
                .map((e) => Map<String, dynamic>.from(e as Map))
                .toList(),
      };

      return StudentFeeFeatureEntityClass.fromMap(normalized);
    } catch (e) {
      throw Exception('Failed to fetch installment plan: $e');
    }
  }

  @override
  removeFromDefaulter(
    String groupId,
    String studentId,
    double paidAmount,
    double totalReaminingFeeForThisStudent,
  ) async {
    try {
      // Get a reference to the document
      DocumentReference documentRef = _firestore
          .collection("$groupId defaulter students")
          .doc(studentId);

      // Call the delete() method
      await documentRef.delete();

      print(
        'Document with ID "$studentId" successfully deleted from collection "$groupId defaulter students"!',
      );
    } on FirebaseException catch (e) {
      // Handle any Firestore-specific errors, e.g., permission denied
      print('Error deleting document: ${e.code} - ${e.message}');
    } catch (e) {
      // Handle any other unexpected errors
      print('An unexpected error occurred: $e');
    }
    // updating fee defaulters collective now
    DocumentSnapshot<Map<String, dynamic>> documentOfCurrentGroup =
        await _firestore
            .collection("fee_defaulters_collective_data")
            .doc(groupId)
            .get();
    // var newRemaingFee;
    Map<String, dynamic>? mapOfData = documentOfCurrentGroup.data();
    var previousRemaingFee = (mapOfData!["remaingFee"] as num).toDouble();
    var previousTotal = (mapOfData["total"] as num).toDouble();
    print("Hello!!!!!!!!!!!!!paidAmount is  :$paidAmount ");
    // newRemaingFee =  totalReaminingFeeForGroup;
    previousTotal = previousTotal - 1;
    print("previousRemaingFee :$previousRemaingFee");
    print("totalReaminingFeeForThisStudent: $totalReaminingFeeForThisStudent");
    print("paidAmount:$paidAmount");
    print(
      "after calculation totalReaminingFeeForThisStudent - paidAmount = ${totalReaminingFeeForThisStudent - paidAmount}",
    );
    print(
      "after calculation previousRemaingFee - (totalReaminingFeeForThisStudent - paidAmount) = ${previousRemaingFee - (totalReaminingFeeForThisStudent - paidAmount)}",
    );
    if ((previousRemaingFee - totalReaminingFeeForThisStudent) == 0) {
      print("!!!!!!!!!!!!!!!!zero so delete this document");
      try {
        // Get a reference to the document
        DocumentReference documentRef = _firestore
            .collection("fee_defaulters_collective_data")
            .doc(groupId);

        // Call the delete() method
        await documentRef.delete();

        print(
          'Document with ID "$groupId" successfully deleted from collection "fee_defaulters_collective_data"!',
        );
      } on FirebaseException catch (e) {
        // Handle any Firestore-specific errors, e.g., permission denied
        print('Error deleting document: ${e.code} - ${e.message}');
      } catch (e) {
        // Handle any other unexpected errors
        print('An unexpected error occurred: $e');
      }
    } else {
      debugPrint("!!!!!!!!!!! not zero so not deleted");
      mapOfData["remaingFee"] =
          (previousRemaingFee - totalReaminingFeeForThisStudent) - paidAmount;
      mapOfData["total"] = previousTotal;
      // refrenceOfCollection.doc(group).set(mapOfData);
      await _firestore
          .collection("fee_defaulters_collective_data")
          .doc(groupId)
          .set(mapOfData);
    }
  }

  @override
  Future<List<FeeEntityClass>> fetchFeesByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final startTs = Timestamp.fromDate(
      DateTime(start.year, start.month, start.day, 0, 0, 0),
    );
    final endTs = Timestamp.fromDate(
      DateTime(end.year, end.month, end.day, 23, 59, 59, 999),
    );

    final snapshot =
        await _firestore
            .collection("fee_history_daywise")
            .where('createdAt', isGreaterThanOrEqualTo: startTs)
            .where('createdAt', isLessThanOrEqualTo: endTs)
            .orderBy('createdAt', descending: true)
            .get();
    var forPrint = snapshot.docs.toList();
    for (var element in forPrint) {
      debugPrint("||||||||||||${element.data()}|||||||||||||");
    }
    return snapshot.docs
        .map((d) => FeeEntityClass.fromMap(d.data(), id: d.id))
        .toList();
  }

  @override
  Future<List<FeeEntityClass>> fetchTodayFees() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day, 0, 0, 0);
    final end = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
    return fetchFeesByDateRange(start, end);
  }

  @override
  Future<void> addToFeeDefaulters({
    required String studentId,
    required String name,
    required double remaingFee,
    required String groupId,
  }) async {
    Map<String, dynamic> data = {
      "name": name,
      "rollnum": studentId,
      "remaingFee": remaingFee,
      "createdAt": DateTime.now(),
    };

    return await _firestore
        .collection("$groupId defaulter students")
        .doc(studentId)
        .set(data);
  }

  @override
  Future<bool> UpdateCollectiveFeeDefaultersDataGroupwise(
    double remaingFee,
    String group,
  ) async {
    debugPrint(
      "&&&&&&&&& Checking for 'fee_defaulters_collective_data' collection existence &&&&&&&&&&&&&&&",
    );

    var refrenceOfCollection = _firestore.collection(
      "fee_defaulters_collective_data",
    );
    DocumentSnapshot<Map<String, dynamic>> documentRefrence =
        await refrenceOfCollection.doc(group).get();

    if (!documentRefrence.exists) {
      debugPrint("this document doesnot exist");
      Map<String, dynamic> dataMap = {"remaingFee": remaingFee, "total": 1};
      refrenceOfCollection.doc(group).set(dataMap);
    } else {
      debugPrint("this document exist so we need to update it ");
      if (documentRefrence.data() != null) {
        Map<String, dynamic>? mapOfData = documentRefrence.data();
        var previousRemaingFee = (mapOfData!["remaingFee"] as num).toDouble();
        var previousTotal = (mapOfData["total"] as num).toDouble();
        remaingFee = remaingFee + previousRemaingFee;
        previousTotal = previousTotal + 1;
        mapOfData["remaingFee"] = remaingFee;
        mapOfData["total"] = previousTotal;
        refrenceOfCollection.doc(group).set(mapOfData);
      } else {
        debugPrint("map is null we can not update it ");
      }
    }
    return true;

    // try {
    //   var refrenceOfCollection = _firestore.collection(
    //     "fee_defaulters_collective_data",
    //   );

    //   var querySnapshot = await refrenceOfCollection.limit(1).get();
    //   DocumentSnapshot<Map<String, dynamic>> documentRefrence =
    //       await refrenceOfCollection.doc(group).get();
    //   // If querySnapshot.docs is not empty, it means there's at least one document in the collection.
    //   if (querySnapshot.docs.isNotEmpty) {
    //     debugPrint(
    //       "Collection 'fee_defaulters_collective_data' HAS documents.",
    //     );

    //     if (!documentRefrence.exists) {
    //       debugPrint("this document doesnot exist");
    //       Map<String, dynamic> dataMap = {"remaingFee": remaingFee, "total": 0};
    //       refrenceOfCollection.doc(group).set(dataMap);
    //     } else {
    //       debugPrint("this document exist so we need to update it ");
    //       if (documentRefrence.data() != null) {
    //         Map<String, dynamic>? mapOfData = documentRefrence.data();
    //         var previousRemaingFee =
    //             (mapOfData!["remaingFee"] as num).toDouble();
    //         var previousTotal = (mapOfData["total"] as num).toDouble();
    //         remaingFee = remaingFee + previousRemaingFee;
    //         previousTotal = previousTotal + 1;
    //       } else {
    //         debugPrint("map is null we can not update it ");
    //       }
    //     }

    //     return true;
    //   } else {
    //     debugPrint(
    //       "Collection 'fee_defaulters_collective_data' does NOT have any documents.",
    //     );

    //     return false;
    //   }
    // } catch (e) {
    //   debugPrint("Error checking collection existence: $e");
    //   return false; // In case of an error, assume it doesn't exist or isn't accessible.
    // }
  }

  @override
  Future<List<FeeDefaulterEntity>> readFeeDefultersDataBasedOnGroup(
    String groupId,
  ) async {
    debugPrint("readFeeDefultersDataBasedOnGroup called");
    QuerySnapshot<Map<String, dynamic>> allDocsRef =
        await _firestore.collection("$groupId defaulter students").get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> allDocs = allDocsRef.docs;
    List<FeeDefaulterEntity> listOfData = [];
    for (var doc in allDocs) {
      listOfData.add(FeeDefaulterEntity.fromMap(doc.data()));
    }
    debugPrint("listOfData:$listOfData");
    return listOfData;
  }

  /// Repository method to fetch the fee defaulters collective data for a given group ID.
  ///
  /// Throws a [FirebaseException] if the Firestore operation fails.
  /// Returns `null` if the document does not exist.
  ///
  /// [groupId]: The ID of the group to query.
  @override
  Future<FeeDefaultersCollective?> readFeeDefultersCollectiveDataBasedOnGroup(
    String groupId,
  ) async {
    // Input validation
    if (groupId.isEmpty) {
      throw ArgumentError('groupId cannot be empty');
    }

    const collectionName =
        'fee_defaulters_collective_data'; // Extract to constant or config

    try {
      debugPrint('Fetching FeeDefaultersCollective for groupId: $groupId');

      final DocumentSnapshot<Map<String, dynamic>> docRef = await _firestore
          .collection(collectionName)
          .doc(groupId)
          .get(
            const GetOptions(source: Source.serverAndCache),
          ); // Prefer server+cache for fresh data

      debugPrint(
        'Document reference fetched for groupId: $groupId, exists: ${docRef.exists}',
      );

      if (!docRef.exists) {
        debugPrint('Document not found for groupId: $groupId');
        return null;
      }

      final Map<String, dynamic>? data = docRef.data();
      if (data == null) {
        debugPrint('Document data is null for groupId: $groupId');
        return null;
      }

      debugPrint('Deserializing data for groupId: $groupId');

      final FeeDefaultersCollective collective =
          FeeDefaultersCollective.fromMap(data);

      debugPrint(
        'Successfully loaded FeeDefaultersCollective for groupId: $groupId',
      );
      return collective;
    } on FirebaseException catch (e) {
      debugPrint(
        'Firebase error while fetching FeeDefaultersCollective for groupId: $groupId: ${e.message}',
      );
      rethrow; // Or wrap in custom exception
    } catch (e) {
      debugPrint(
        'Unexpected error while fetching FeeDefaultersCollective for groupId: $groupId: $e',
      );
      rethrow;
    }
  }

  @override
  Future<List<String>> readFeeDefaulterGroopNames() async {
    var collectionRef =
        await _firestore.collection("fee_defaulters_collective_data").get();
    var docsList = collectionRef.docs;
    List<String> listOfGroupNames = [];
    for (var doc in docsList) {
      listOfGroupNames.add(doc.id);
    }
    debugPrint("$listOfGroupNames");
    return listOfGroupNames;
  }

  @override
  Future<bool> checkIfStudentIsDefaulter(
    String groupId,
    String studentId,
  ) async {
    try {
      // Get an instance of the Firestore database
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Construct the full path to the document
      final DocumentReference documentRef = firestore
          .collection("$groupId defaulter students")
          .doc(studentId);

      // Fetch the document snapshot
      final DocumentSnapshot documentSnapshot = await documentRef.get();

      // The 'exists' property of the DocumentSnapshot tells us if it's there
      return documentSnapshot.exists;
    } catch (e) {
      // If any error occurs during the process (e.g., network issues, permissions),
      // we'll log it and assume the document doesn't exist to be safe.
      print("Error checking document existence: $e");
      return false;
    }
  }

  @override
  addToSuperAdminApprovalList(
    // FeeInstallmentEntityClass installment,
    StudentFeeFeatureEntityClass student,
    int index,
  ) async {
    try {
      StudentFeeFeatureEntityClass? updatedStudent = await getStudent(
        student.id,
      );

      await _firestore
          .collection("not_approved_fee_installments")
          .doc(student.id)
          .set(updatedStudent!.toMap());
    } catch (e) {
      print("addinsg ToSuperAdminApprovalList failed due to this error $e");
    }
  }

  @override
  @override
  addToPendingFee2(
    StudentFeeFeatureEntityClass student,
    FeeInstallmentEntityClass adminSidePayedInstalment,
    double paidAmount,
    String paymentMethod,
  ) async {
    final docRef = _firestore.collection('student_installment').doc(student.id);
    final doc = await docRef.get();

    if (!doc.exists) {
      throw Exception('Student installment document not found');
    }

    final data = doc.data()!;
    final List<Map<String, dynamic>> installments =
        List<Map<String, dynamic>>.from(data['installments'] ?? []);
    Map<String, dynamic> currentMap;

    for (var i = 0; i < installments.length; i++) {
      currentMap = installments.elementAt(i);

      if (currentMap["id"] == adminSidePayedInstalment.id) {
        double total = currentMap["totalAmount"];

        // If paid amount is 0, mark as paid with 0 amount and move total to next installment
        if (paidAmount == 0) {
          currentMap["status"] = "skipped";
          currentMap["paidAmount"] = 0;
          currentMap["paidDate"] = DateTime.now().toIso8601String();
          currentMap["paymentMethod"] = paymentMethod;
          installments.removeAt(i);
          installments.insert(i, currentMap);

          // Add current installment's total amount to the next installment
          if (i != installments.length - 1) {
            // Add to the next existing installment
            Map<String, dynamic> nextMap = installments.elementAt(i + 1);
            double nextInstallmentCurrentTotal = nextMap["totalAmount"];
            nextMap["totalAmount"] = nextInstallmentCurrentTotal + total;
            installments.removeAt(i + 1);
            installments.insert(i + 1, nextMap);
          } else {
            // Create a new installment with the current installment's amount
            final newDueDate = DateTime.now().add(Duration(days: 30 * (i + 2)));
            installments.add({
              "id": _uuid.v4(),
              "paidAmount": 0,
              "paidDate": null,
              "paymentMethod": null,
              "status": "Unpaid",
              "title": "Installment ${i + 2}",
              "totalAmount": total,
              "dueDate": newDueDate.toIso8601String(),
            });
          }
        } else {
          // Original logic for non-zero paid amounts
          // Update current installment to pending status
          currentMap["status"] = "pending";
          currentMap["paidAmount"] = paidAmount;
          currentMap["paidDate"] = DateTime.now().toIso8601String();
          currentMap["paymentMethod"] = paymentMethod;
          installments.removeAt(i);
          installments.insert(i, currentMap);

          // Handle remaining amount if this is a partial payment
          if (paidAmount < total) {
            double remainingAmount = total - paidAmount;

            if (i != installments.length - 1) {
              // Add remaining amount to the next existing installment
              Map<String, dynamic> nextMap = installments.elementAt(i + 1);
              double nextInstallmentCurrentTotal = nextMap["totalAmount"];
              nextMap["totalAmount"] =
                  nextInstallmentCurrentTotal + remainingAmount;
              installments.removeAt(i + 1);
              installments.insert(i + 1, nextMap);
            } else {
              // Create a new installment for the remaining amount
              final newDueDate = DateTime.now().add(
                Duration(days: 30 * (i + 2)),
              );
              installments.add({
                "id": _uuid.v4(),
                "paidAmount": 0,
                "paidDate": null,
                "paymentMethod": null,
                "status": "Unpaid",
                "title": "Installment ${i + 2}",
                "totalAmount": remainingAmount,
                "dueDate": newDueDate.toIso8601String(),
              });
            }
          }
        }
        break;
      }
    }

    // Update the student installment document
    await docRef.update({"installments": installments});

    // Update the not approved fee installments document only if paidAmount > 0
    if (paidAmount > 0) {
      var docref2 = _firestore
          .collection("not_approved_fee_installments")
          .doc(student.id);

      var modifyableStudentMap = student.toMap();
      modifyableStudentMap["installments"] = installments;
      await docref2.set(modifyableStudentMap);
    }
  }

  @override
  Future<Map<DateTime, double>> fetchDayWiseFeesByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    debugPrint("========================================");
    debugPrint("fetchDayWiseFeesByDateRange: START");
    debugPrint("Start Date: $start");
    debugPrint("End Date: $end");
    debugPrint("========================================");

    final startTs = Timestamp.fromDate(
      DateTime(start.year, start.month, start.day, 0, 0, 0),
    );
    final endTs = Timestamp.fromDate(
      DateTime(end.year, end.month, end.day, 23, 59, 59, 999),
    );

    try {
      final snapshot =
          await _firestore
              .collection("fee_history_daywise")
              .where('createdAt', isGreaterThanOrEqualTo: startTs)
              .where('createdAt', isLessThanOrEqualTo: endTs)
              .orderBy('createdAt', descending: true)
              .get();

      debugPrint(
        "fetchDayWiseFeesByDateRange: Fetched ${snapshot.docs.length} documents",
      );

      // Map to store date -> total amount
      final Map<DateTime, double> dayWiseTotals = {};

      for (var doc in snapshot.docs) {
        final data = doc.data();
        debugPrint("Processing document: ${doc.id}");
        debugPrint("Document data: $data");

        if (data['createdAt'] != null && data['paidAmount'] != null) {
          final Timestamp timestamp = data['createdAt'] as Timestamp;
          final DateTime dateTime = timestamp.toDate();

          // Normalize to date only (remove time component)
          final DateTime dateOnly = DateTime(
            dateTime.year,
            dateTime.month,
            dateTime.day,
          );

          final double paidAmount = (data['paidAmount'] as num).toDouble();

          debugPrint(
            "Date: $dateOnly, Amount: $paidAmount, Student: ${data['name']}",
          );

          // Add to total for this date
          if (dayWiseTotals.containsKey(dateOnly)) {
            dayWiseTotals[dateOnly] = dayWiseTotals[dateOnly]! + paidAmount;
          } else {
            dayWiseTotals[dateOnly] = paidAmount;
          }
        } else {
          debugPrint("⚠️ Document missing createdAt or paidAmount: ${doc.id}");
        }
      }

      debugPrint("========================================");
      debugPrint("Day-wise totals:");
      dayWiseTotals.forEach((date, total) {
        debugPrint("  ${date.toString().split(' ')[0]}: $total");
      });
      debugPrint("Total unique dates: ${dayWiseTotals.length}");
      debugPrint("========================================");

      return dayWiseTotals;
    } catch (e) {
      debugPrint("❌ ERROR in fetchDayWiseFeesByDateRange: $e");
      rethrow;
    }
  }
}
// await _firestore.collection("pending_fees2").doc(student.id).set({
    //   "studentId": student.id,
    //   "instalmentId": adminSidePayedInstalment.id,
    // });