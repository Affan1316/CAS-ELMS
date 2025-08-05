import 'package:flutter/material.dart';

class SelectFeePlanPage extends StatelessWidget {
  const SelectFeePlanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    var Size(:width, :height) = size;
    height -= kToolbarHeight;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF6DD5FA),
        title: Text('Select Fee Plan'),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
      ),
      body: Center(
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(color: Colors.white),
          child: ListView.builder(
            itemCount: 15,
            itemBuilder:
                (context, index) => NeumorphicFeeTile(
                  fee: '90,000',
                  installments: '11',
                  perMonth: '10,000',
                  onDelete: () {},
                ),
          ),
        ),
      ),
    );
  }
}

class NeumorphicFeeTile extends StatelessWidget {
  final String fee;
  final String installments;
  final String perMonth;
  final VoidCallback onDelete;

  const NeumorphicFeeTile({
    super.key,
    required this.fee,
    required this.installments,
    required this.perMonth,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    const background = Color(
      0xFFF3F6FA,
    ); // Light background for neumorphic effect

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          // Outer shadows for soft 3D look
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            offset: const Offset(6, 6),
            blurRadius: 12,
          ),
          const BoxShadow(
            color: Colors.white,
            offset: Offset(-6, -6),
            blurRadius: 12,
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        leading: Container(
          decoration: BoxDecoration(
            color: background,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                offset: const Offset(4, 4),
                blurRadius: 8,
              ),
              const BoxShadow(
                color: Colors.white,
                offset: Offset(-4, -4),
                blurRadius: 8,
              ),
            ],
          ),
          child: const CircleAvatar(
            radius: 26,
            backgroundColor: Colors.transparent,
            child: Icon(Icons.attach_money, color: Colors.black87, size: 28),
          ),
        ),
        title: Text(
          "Fee: $fee",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          "Installments: $installments\nPer Month: $perMonth",
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.redAccent, size: 26),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
