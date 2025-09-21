// // Data Models

// import 'package:flutter_cas_app_main/src/features/fee_feature/data/entities/group_fee_feature.dart';
// import 'package:flutter_cas_app_main/src/features/installment_page/presentation/fee_installment.dart';

// class DataServiceFeeFeature {
//   static final List<GroupFeeFeature> groups = [
//     GroupFeeFeature(
//       id: "g1",
//       name: "Artificial Intelligence",
//       memberIds: ["s1", "s2"],
//     ),
//     GroupFeeFeature(
//       id: "g2",
//       name: "Android Development",
//       memberIds: ["s3", "s4"],
//     ),
//     GroupFeeFeature(id: "g3", name: "Web Development", memberIds: ["s5", "s6"]),
//     GroupFeeFeature(id: "g4", name: "Data Science", memberIds: ["s7", "s8"]),
//   ];

//   static final List<StudentFeeFeature> students = [
//     StudentFeeFeature(
//       id: "s1",
//       name: "Muzammil Ashraf",
//       groupId: "g1",
//       totalFee: 95000,
//       installments: [
//         FeeInstallment(
//           id: "f1",
//           title: "Installment 1",
//           totalAmount: 15000,
//           paidAmount: 15000,
//           dueDate: DateTime(2023, 1, 15),
//           paidDate: DateTime(2023, 1, 10),
//           paymentMethod: "Cash",
//         ),
//         FeeInstallment(
//           id: "f2",
//           title: "Installment 2",
//           totalAmount: 15000,
//           paidAmount: 0,
//           dueDate: DateTime(2023, 2, 15),
//         ),
//         FeeInstallment(
//           id: "f3",
//           title: "Installment 3",
//           totalAmount: 20000,
//           paidAmount: 0,
//           dueDate: DateTime(2023, 3, 15),
//         ),
//       ],
//     ),
//     StudentFeeFeature(
//       id: "s2",
//       name: "Muzammil Qadeer",
//       groupId: "g1",
//       totalFee: 95000,
//       installments: [
//         FeeInstallment(
//           id: "f4",
//           title: "Installment 1",
//           totalAmount: 15000,
//           paidAmount: 15000,
//           dueDate: DateTime(2023, 1, 15),
//           paidDate: DateTime(2023, 1, 10),
//           paymentMethod: "JazzCash",
//         ),
//         FeeInstallment(
//           id: "f5",
//           title: "Installment 2",
//           totalAmount: 15000,
//           paidAmount: 15000,
//           dueDate: DateTime(2023, 2, 15),
//           paidDate: DateTime(2023, 2, 12),
//           paymentMethod: "EasyPaisa",
//         ),
//         FeeInstallment(
//           id: "f6",
//           title: "Installment 3",
//           totalAmount: 20000,
//           paidAmount: 10000,
//           dueDate: DateTime(2023, 3, 15),
//           paidDate: DateTime(2023, 3, 10),
//           paymentMethod: "UBL",
//         ),
//       ],
//     ),
//     StudentFeeFeature(
//       id: "s3",
//       name: "Ahmed Khan",
//       groupId: "g2",
//       totalFee: 85000,
//       installments: [
//         FeeInstallment(
//           id: "f7",
//           title: "Installment 1",
//           totalAmount: 15000,
//           paidAmount: 15000,
//           dueDate: DateTime(2023, 1, 15),
//           paidDate: DateTime(2023, 1, 10),
//           paymentMethod: "Cash",
//         ),
//       ],
//     ),
//     StudentFeeFeature(
//       id: "s4",
//       name: "Fatima Ali",
//       groupId: "g2",
//       totalFee: 85000,
//       installments: [
//         FeeInstallment(
//           id: "f8",
//           title: "Installment 1",
//           totalAmount: 15000,
//           paidAmount: 10000,
//           dueDate: DateTime(2023, 1, 15),
//           paidDate: DateTime(2023, 1, 10),
//           paymentMethod: "JazzCash",
//         ),
//       ],
//     ),
//   ];

//   static List<GroupFeeFeature> getGroups() {
//     return groups;
//   }

//   static List<StudentFeeFeature> getStudentsByGroup(String groupId) {
//     return students.where((student) => student.groupId == groupId).toList();
//   }

//   static StudentFeeFeature getStudent(String studentId) {
//     return students.firstWhere((student) => student.id == studentId);
//   }

//   static void updateInstallment(
//     String studentId,
//     String installmentId,
//     double amount,
//     String method,
//     DateTime date,
//   ) {
//     final student = students.firstWhere((s) => s.id == studentId);
//     final installment = student.installments.firstWhere(
//       (inst) => inst.id == installmentId,
//     );

//     installment.paidAmount = amount;
//     installment.paymentMethod = method;
//     installment.paidDate = date;
//   }
// }
