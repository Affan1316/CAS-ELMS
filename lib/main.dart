import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/firebase_options.dart';
import 'package:flutter_cas_app_main/src/core/dependencies/injections.dart';
import 'package:flutter_cas_app_main/src/core/theme/app_theme.dart';
import 'package:flutter_cas_app_main/src/features/Chat_Page/presentation/bloc/chat_page_bloc.dart';
import 'package:flutter_cas_app_main/src/features/add_courses/presentation/bloc/add_course_bloc.dart';
import 'package:flutter_cas_app_main/src/features/add_instructor_screen/presentation/bloc/add_instructor_bloc.dart';
import 'package:flutter_cas_app_main/src/features/admin_home_page/presentation/bloc/admin_home_bloc.dart';
import 'package:flutter_cas_app_main/src/features/admin_home_page/presentation/pages/admin_home_page.dart';
import 'package:flutter_cas_app_main/src/features/admin_login_screen/presentation/bloc/admin_login_bloc.dart';
import 'package:flutter_cas_app_main/src/features/categories_and_login_screen/presentation/bloc/login_onboarding_bloc.dart';
import 'package:flutter_cas_app_main/src/features/fee%20history/data/local_fee_service.dart';
import 'package:flutter_cas_app_main/src/features/fee%20history/presentation/bloc/fee_history_bloc.dart';
import 'package:flutter_cas_app_main/src/features/fee%20history/presentation/bloc/fee_history_event.dart';
import 'package:flutter_cas_app_main/src/features/fee%20history/presentation/page/fee_history_screen.dart';
import 'package:flutter_cas_app_main/src/features/group/data/repositories/group_repository_implementation.dart';
import 'package:flutter_cas_app_main/src/features/group/domain/usecases/add_group_usecase.dart';
import 'package:flutter_cas_app_main/src/features/group/domain/usecases/update_group_usecase.dart';
import 'package:flutter_cas_app_main/src/features/group/presentation/bloc/group_bloc.dart';
import 'package:flutter_cas_app_main/src/features/inquiry/presentation/bloc/inquiry_bloc.dart';
import 'package:flutter_cas_app_main/src/features/installment_page/presentation/bloc/installment_page_bloc.dart';
import 'package:flutter_cas_app_main/src/features/installment_page/presentation/installment_service.dart';
import 'package:flutter_cas_app_main/src/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/bloc/student_feature_bloc.dart';
import 'package:intl/intl.dart';
import 'package:responsive_ui_kit/responsive_ui_kit.dart';
// import 'package:flutter_cas_app_main/src/features/course_catalog/presentation/pages/course_catalog_screen_state.dart';

// void main() {
//   runApp(const MyApp());
// }

// add that
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutProvider(
      child: MultiBlocProvider(
        providers: [
          BlocProvider<OnboardingBloc>(create: (context) => OnboardingBloc()),
          BlocProvider<ChatPageBloc>(create: (context) => ChatPageBloc()),
          BlocProvider<AdminHomeBloc>(create: (context) => AdminHomeBloc()),
          BlocProvider<StudentFeatureBloc>(
            create: (context) => StudentFeatureBloc(),
          ),
          BlocProvider<InquiryBloc>(create: (context) => sl<InquiryBloc>()),
          BlocProvider<AddCourseBloc>(create: (context) => sl<AddCourseBloc>()),
          BlocProvider<InstallmentPageBloc>(
            create:
                (context) => InstallmentPageBloc(
                  installmentService: InstallmentService(),
                ),
          ),

          BlocProvider<AddInstructorBloc>(
            create: (context) => AddInstructorBloc(),
          ),
          BlocProvider<AdminLoginBloc>(create: (context) => AdminLoginBloc()),
          BlocProvider<FeeHistoryBloc>(
            create:
                (context) => FeeHistoryBloc(LocalFeeService())..add(LoadFees()),
            child: FeeHistoryScreen(),
          ),
          BlocProvider<AddGroupBloc>(
            create:
                (context) => AddGroupBloc(
                  addGroupUsecase: AddGroupUsecase(
                    abstractGroupRepository: GroupRepositoryImplementation(),
                  ),
                  updateGroupUsecase: UpdateGroupUsecase(
                    abstractGroupRepository: GroupRepositoryImplementation(),
                  ),
                ),
          ),
        ],
        child: MaterialApp(
          title: 'CAS ELMS',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          home: AdminHomePage(),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return OnboardingScreen();
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_cas_app_main/src/features/student_feature/data/student_entity_class.dart';
// import 'package:flutter_cas_app_main/src/features/student_feature/presentation/pages/StudentDetailPage.dart';

// void main() {
//   runApp(const DemoApp());
// }

// class DemoApp extends StatelessWidget {
//   const DemoApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Student Detail Demo',
//       theme: ThemeData(
//         brightness: Brightness.light,
//         scaffoldBackgroundColor: const Color(0xFFE0E0E0), // light grey base
//       ),
//       home: StudentDetailPage(
//         student: StudentEntityClass(
//           id: "STU123",
//           name: "Ali Raza",
//           email: "ali.raza@example.com",
//           cnic: "35202-1234567-8",
//           phone: "+92 301 2345678",
//           address: "123 Main Street, Lahore",
//           gender: "Male",
//           fatherName: "Ahmed Raza",
//           fatherOccupation: "Businessman",
//           group: "Science",
//         ),
//       ),
//     );
//   }
// }
// _________________________________________________________________________________________________

// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// } // 🌈 App Entry

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: "Groups UI",
//       theme: ThemeData(fontFamily: "Roboto"),
//       home: const GroupsLoadingScreen(),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

class Group {
  final String id;
  final String code;
  final String name;
  final List<String> memberIds;

  Group({
    required this.id,
    required this.code,
    required this.name,
    required this.memberIds,
  });
}

class Student {
  final String id;
  final String name;
  final String groupId;
  final double totalFee;
  final List<FeeInstallment> installments;

  Student({
    required this.id,
    required this.name,
    required this.groupId,
    required this.totalFee,
    required this.installments,
  });

  double get totalPaid {
    return installments.fold(
      0,
      (sum, installment) => sum + installment.paidAmount,
    );
  }

  double get remainingAmount {
    return totalFee - totalPaid;
  }
}

class FeeInstallment {
  final String id;
  final String title;
  final double totalAmount;
  double paidAmount;
  DateTime dueDate;
  DateTime? paidDate;
  String? paymentMethod;

  FeeInstallment({
    required this.id,
    required this.title,
    required this.totalAmount,
    required this.paidAmount,
    required this.dueDate,
    this.paidDate,
    this.paymentMethod,
  });

  String get status {
    if (paidAmount >= totalAmount) return "Paid";
    if (paidAmount > 0) return "Partial";
    return "Unpaid";
  }
}

class DataService {
  static final List<Group> groups = [
    Group(
      id: "g1",
      code: "Ai",
      name: "Artificial Intelligence",
      memberIds: ["s1", "s2"],
    ),
    Group(
      id: "g2",
      code: "A14",
      name: "Android Development",
      memberIds: ["s3", "s4"],
    ),
  ];

  static final List<Student> students = [
    Student(
      id: "s1",
      name: "Muzammil Ashraf",
      groupId: "g1",
      totalFee: 95000,
      installments: [
        FeeInstallment(
          id: "f1",
          title: "Installment 1",
          totalAmount: 15000,
          paidAmount: 15000,
          dueDate: DateTime(2023, 1, 15),
          paidDate: DateTime(2023, 1, 10),
          paymentMethod: "Cash",
        ),
        FeeInstallment(
          id: "f2",
          title: "Installment 2",
          totalAmount: 15000,
          paidAmount: 0,
          dueDate: DateTime(2023, 2, 15),
        ),
        FeeInstallment(
          id: "f3",
          title: "Installment 3",
          totalAmount: 20000,
          paidAmount: 0,
          dueDate: DateTime(2023, 3, 15),
        ),
      ],
    ),
    Student(
      id: "s2",
      name: "Muzammil Qadeer",
      groupId: "g1",
      totalFee: 95000,
      installments: [
        FeeInstallment(
          id: "f4",
          title: "Installment 1",
          totalAmount: 15000,
          paidAmount: 15000,
          dueDate: DateTime(2023, 1, 15),
          paidDate: DateTime(2023, 1, 10),
          paymentMethod: "JazzCash",
        ),
        FeeInstallment(
          id: "f5",
          title: "Installment 2",
          totalAmount: 15000,
          paidAmount: 15000,
          dueDate: DateTime(2023, 2, 15),
          paidDate: DateTime(2023, 2, 12),
          paymentMethod: "EasyPaisa",
        ),
        FeeInstallment(
          id: "f6",
          title: "Installment 3",
          totalAmount: 20000,
          paidAmount: 10000,
          dueDate: DateTime(2023, 3, 15),
          paidDate: DateTime(2023, 3, 10),
          paymentMethod: "UBL",
        ),
      ],
    ),
  ];

  static List<Group> getGroups() {
    return groups;
  }

  static List<Student> getStudentsByGroup(String groupId) {
    return students.where((student) => student.groupId == groupId).toList();
  }

  static Student getStudent(String studentId) {
    return students.firstWhere((student) => student.id == studentId);
  }

  static void updateInstallment(
    String studentId,
    String installmentId,
    double amount,
    String method,
    DateTime date,
  ) {
    final student = students.firstWhere((s) => s.id == studentId);
    final installment = student.installments.firstWhere(
      (inst) => inst.id == installmentId,
    );

    installment.paidAmount = amount;
    installment.paymentMethod = method;
    installment.paidDate = date;
  }
}

class GradientBackground extends StatelessWidget {
  final Widget child;
  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFEDE7F6), Color(0xFFB2DFDB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: child,
    );
  }
}

class ResponsiveText extends StatelessWidget {
  final String text;
  final double phoneSize;
  final double tabletSize;
  final FontWeight weight;
  final Color color;

  const ResponsiveText({
    super.key,
    required this.text,
    required this.phoneSize,
    required this.tabletSize,
    this.weight = FontWeight.normal,
    this.color = const Color(0xFF3E206D),
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    return Text(
      text,
      style: TextStyle(
        fontSize: isTablet ? tabletSize : phoneSize,
        fontWeight: weight,
        color: color,
      ),
    );
  }
}

class ResponsivePadding extends StatelessWidget {
  final Widget child;
  const ResponsivePadding({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 48 : 24,
        vertical: isTablet ? 24 : 16,
      ),
      child: child,
    );
  }
}

class NeuCard extends StatelessWidget {
  final Widget child;
  const NeuCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFB2DFDB),
            offset: Offset(4, 4),
            blurRadius: 10,
          ),
          BoxShadow(
            color: Colors.white,
            offset: Offset(-4, -4),
            blurRadius: 10,
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: child,
    );
  }
}

class ScreenHeader extends StatelessWidget {
  final String title;
  const ScreenHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF3E206D)),
          onPressed: () => Navigator.pop(context),
        ),
        Expanded(
          child: ResponsiveText(
            text: title,
            phoneSize: 20,
            tabletSize: 26,
            weight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class GroupsLoadingScreen extends StatefulWidget {
  const GroupsLoadingScreen({super.key});

  @override
  State<GroupsLoadingScreen> createState() => _GroupsLoadingScreenState();
}

class _GroupsLoadingScreenState extends State<GroupsLoadingScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const GroupsListScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    return GradientBackground(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: isTablet ? 80 : 50,
                height: isTablet ? 80 : 50,
                child: const CircularProgressIndicator(
                  color: Color(0xFF3E206D),
                  strokeWidth: 5,
                ),
              ),
              const SizedBox(height: 20),
              const ResponsiveText(
                text: "Loading Groups...",
                phoneSize: 16,
                tabletSize: 22,
                weight: FontWeight.w600,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GroupsListScreen extends StatelessWidget {
  const GroupsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final groups = DataService.getGroups();
    final isTablet = MediaQuery.of(context).size.width > 600;

    return GradientBackground(
      child: Scaffold(
        body: SafeArea(
          child: ResponsivePadding(
            child: Column(
              children: [
                const ScreenHeader(title: "Groups"),
                const SizedBox(height: 20),
                Expanded(
                  child:
                      isTablet
                          ? GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20,
                                  childAspectRatio: 3.5,
                                ),
                            itemCount: groups.length,
                            itemBuilder: (context, i) {
                              final group = groups[i];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => GroupMembersScreen(
                                            groupId: group.id,
                                          ),
                                    ),
                                  );
                                },
                                child: NeuCard(
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: isTablet ? 30 : 24,
                                        backgroundColor: const Color(
                                          0xFF009688,
                                        ),
                                        child: Text(
                                          group.code,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: isTablet ? 24 : 16),
                                      Expanded(
                                        child: ResponsiveText(
                                          text: group.name,
                                          phoneSize: 16,
                                          tabletSize: 20,
                                          weight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                          : ListView.separated(
                            itemCount: groups.length,
                            separatorBuilder:
                                (_, __) => const SizedBox(height: 16),
                            itemBuilder: (context, i) {
                              final group = groups[i];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => GroupMembersScreen(
                                            groupId: group.id,
                                          ),
                                    ),
                                  );
                                },
                                child: NeuCard(
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 24,
                                        backgroundColor: const Color(
                                          0xFF009688,
                                        ),
                                        child: Text(
                                          group.code,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: ResponsiveText(
                                          text: group.name,
                                          phoneSize: 16,
                                          tabletSize: 20,
                                          weight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GroupMembersScreen extends StatelessWidget {
  final String groupId;
  const GroupMembersScreen({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    final students = DataService.getStudentsByGroup(groupId);
    final group = DataService.getGroups().firstWhere((g) => g.id == groupId);

    return GradientBackground(
      child: Scaffold(
        body: SafeArea(
          child: ResponsivePadding(
            child: Column(
              children: [
                ScreenHeader(title: group.name),
                const SizedBox(height: 20),
                Expanded(
                  child:
                      isTablet
                          ? GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20,
                                  childAspectRatio: 3.5,
                                ),
                            itemCount: students.length,
                            itemBuilder: (context, index) {
                              final student = students[index];
                              return NeuCard(
                                child: MemberCardContent(student: student),
                              );
                            },
                          )
                          : ListView.separated(
                            itemCount: students.length,
                            separatorBuilder:
                                (_, __) => const SizedBox(height: 16),
                            itemBuilder: (context, index) {
                              final student = students[index];
                              return NeuCard(
                                child: MemberCardContent(student: student),
                              );
                            },
                          ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MemberCardContent extends StatelessWidget {
  final Student student;
  const MemberCardContent({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    return Row(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: const Color(0xFF009688),
          child: Text(
            student.name.split(' ').map((e) => e[0]).take(2).join(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(width: isTablet ? 24 : 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ResponsiveText(
                text: student.name,
                phoneSize: 16,
                tabletSize: 20,
                weight: FontWeight.w600,
              ),
              ResponsiveText(
                text: student.id,
                phoneSize: 13,
                tabletSize: 15,
                color: Colors.grey,
              ),
            ],
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF009688),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FeeDetailsScreen(studentId: student.id),
              ),
            );
          },
          child: const ResponsiveText(
            text: "View Fee",
            phoneSize: 13,
            tabletSize: 16,
            color: Colors.white,
            weight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class FeeDetailsScreen extends StatefulWidget {
  final String studentId;
  const FeeDetailsScreen({super.key, required this.studentId});

  @override
  State<FeeDetailsScreen> createState() => _FeeDetailsScreenState();
}

class _FeeDetailsScreenState extends State<FeeDetailsScreen> {
  late Student student;

  @override
  void initState() {
    super.initState();
    student = DataService.getStudent(widget.studentId);
  }

  void _refreshData() {
    setState(() {
      student = DataService.getStudent(widget.studentId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    final currencyFormat = NumberFormat.currency(locale: 'en_US', symbol: '');

    return GradientBackground(
      child: Scaffold(
        body: SafeArea(
          child: ResponsivePadding(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ScreenHeader(title: student.name),
                const SizedBox(height: 20),
                NeuCard(
                  child: Padding(
                    padding: EdgeInsets.all(isTablet ? 28 : 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ResponsiveText(
                          text:
                              "Total Fee: ${currencyFormat.format(student.totalFee)}",
                          phoneSize: 16,
                          tabletSize: 20,
                          weight: FontWeight.bold,
                        ),
                        const SizedBox(height: 8),
                        ResponsiveText(
                          text:
                              "Total Received: ${currencyFormat.format(student.totalPaid)}",
                          phoneSize: 16,
                          tabletSize: 20,
                        ),
                        const SizedBox(height: 8),
                        ResponsiveText(
                          text:
                              "Remaining: ${currencyFormat.format(student.remainingAmount)}",
                          phoneSize: 16,
                          tabletSize: 20,
                          color:
                              student.remainingAmount > 0
                                  ? Colors.redAccent
                                  : Colors.green,
                          weight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: NeuCard(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: isTablet ? 40 : 20,
                          columns: const [
                            DataColumn(label: Text("Id")),
                            DataColumn(label: Text("Due Date")),
                            DataColumn(label: Text("Total")),
                            DataColumn(label: Text("Paid")),
                            DataColumn(label: Text("Status")),
                            DataColumn(label: Text("Action")),
                          ],
                          rows:
                              student.installments.map((installment) {
                                return _buildRow(installment, context);
                              }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  DataRow _buildRow(FeeInstallment installment, BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'en_US', symbol: '');
    Color statusColor = Colors.green;

    if (installment.status == "Partial") {
      statusColor = Colors.orange;
    } else if (installment.status == "Unpaid") {
      statusColor = Colors.red;
    }

    return DataRow(
      cells: [
        DataCell(Text(installment.id)),
        DataCell(Text(DateFormat('MMM dd, yyyy').format(installment.dueDate))),
        DataCell(Text(currencyFormat.format(installment.totalAmount))),
        DataCell(Text(currencyFormat.format(installment.paidAmount))),
        DataCell(
          Text(
            installment.status,
            style: TextStyle(fontWeight: FontWeight.bold, color: statusColor),
          ),
        ),
        DataCell(
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder:
                    (_) => PayFeeModal(
                      totalFee: installment.totalAmount,
                      onPay: (amount, method, date) {
                        DataService.updateInstallment(
                          widget.studentId,
                          installment.id,
                          amount,
                          method,
                          date,
                        );
                        _refreshData();
                      },
                    ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3E206D),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Pay Fee", style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }
}

class PayFeeModal extends StatefulWidget {
  final double totalFee;
  final void Function(double amount, String method, DateTime date)? onPay;

  const PayFeeModal({super.key, required this.totalFee, this.onPay});

  @override
  State<PayFeeModal> createState() => _PayFeeModalState();
}

class _PayFeeModalState extends State<PayFeeModal> {
  final TextEditingController _amountController = TextEditingController();
  DateTime? _selectedDate;
  String _paymentMethod = "Cash";

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _amountController.text = widget.totalFee.toStringAsFixed(2);
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: EdgeInsets.all(isTablet ? 60 : 20),
      child: NeuCard(
        child: Padding(
          padding: EdgeInsets.all(isTablet ? 32 : 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ResponsiveText(
                text: "Pay Fee",
                phoneSize: 20,
                tabletSize: 26,
                weight: FontWeight.bold,
              ),
              const SizedBox(height: 16),

              Text("Total: ${widget.totalFee.toStringAsFixed(2)}"),

              const SizedBox(height: 16),

              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Paying Amount",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              InkWell(
                onTap: _pickDate,
                child: IgnorePointer(
                  child: TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "Select Date",
                      hintText:
                          _selectedDate != null
                              ? DateFormat(
                                'MMM dd, yyyy',
                              ).format(_selectedDate!)
                              : "Choose a date",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Column(
                children: [
                  _buildRadio("Cash"),
                  _buildRadio("UBL"),
                  _buildRadio("JazzCash"),
                  _buildRadio("EasyPaisa"),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _modalButton("Pay", Colors.blue, () {
                    final amount = double.tryParse(_amountController.text);
                    if (amount != null && _selectedDate != null) {
                      widget.onPay?.call(
                        amount,
                        _paymentMethod,
                        _selectedDate!,
                      );
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Enter valid amount & date"),
                        ),
                      );
                    }
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRadio(String method) {
    return RadioListTile(
      title: Text(method),
      value: method,
      groupValue: _paymentMethod,
      onChanged: (value) {
        setState(() => _paymentMethod = value.toString());
      },
    );
  }

  Widget _modalButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }
}

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Fee Management System',
//       theme: ThemeData(
//         primarySwatch: Colors.teal,
//         useMaterial3: true,
//       ),
//       home: const GroupsLoadingScreen(),
//     );
//   }
// }
