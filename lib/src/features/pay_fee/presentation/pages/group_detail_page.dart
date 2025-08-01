import 'package:flutter/material.dart';
import '../widgets/student_card.dart';

class AGroupPage extends StatefulWidget {
  const AGroupPage({super.key});

  @override
  _AGroupPageState createState() => _AGroupPageState();
}

class _AGroupPageState extends State<AGroupPage> {
  final List<Student> allStudents = [
    Student(name: "Muzammil Ashraf", roll: "Ai-24"),
    Student(name: "Muhammad Abdullah Waqar", roll: "Ai-08"),
    Student(name: "Haroon Ashraf", roll: "Ai-02"),
    Student(name: "Abdullah Qureshi", roll: "Ai-11"),
    Student(name: "Gulraiz Javiad", roll: "Ai-09"),
    Student(name: "Mushtaq Ahmed", roll: "Ai-23"),
    Student(name: "Abu Bakar", roll: "Ai-31"),
    Student(name: "Roman Ali", roll: "Ai-33"),
    Student(name: "Muhammad Rashid", roll: "Ai-04"),
  ];

  List<Student> filteredStudents = [];
  bool isSearching = false;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredStudents = allStudents;
  }

  void _filterStudents(String query) {
    final searchLower = query.toLowerCase();
    setState(() {
      filteredStudents = allStudents.where((student) {
        return student.name.toLowerCase().contains(searchLower) ||
            student.roll.toLowerCase().contains(searchLower);
      }).toList();
    });
  }

  void _startSearch() => setState(() => isSearching = true);

  void _stopSearch() {
    setState(() {
      isSearching = false;
      searchController.clear();
      filteredStudents = allStudents;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      appBar: AppBar(
        title: isSearching
            ? TextField(
                controller: searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search students...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white60),
                ),
                style: const TextStyle(color: Colors.white, fontSize: 18),
                onChanged: _filterStudents,
              )
            : const Text(
                "AI Group",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0097B2),
        elevation: 6,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (isSearching)
            IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: _stopSearch)
          else
            IconButton(icon: const Icon(Icons.search, color: Colors.white), onPressed: _startSearch),
          const SizedBox(width: 4),
          const Icon(Icons.refresh, color: Colors.white),
          const SizedBox(width: 12),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredStudents.length,
        itemBuilder: (context, index) {
          return StudentCard(student: filteredStudents[index]);
        },
      ),
    );
  }
}

class Student {
  final String name;
  final String roll;
  Student({required this.name, required this.roll});
}
