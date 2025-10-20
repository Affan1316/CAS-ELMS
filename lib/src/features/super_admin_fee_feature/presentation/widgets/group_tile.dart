import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/presentation/widgets/neomorphic_container.dart';

class GroupTile extends StatelessWidget {
  final String groupName;
  final VoidCallback onTap;

  const GroupTile({super.key, required this.groupName, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: NeomorphicContainer(
        child: ListTile(
          leading: NeomorphicContainer(
            width: 40,
            height: 40,
            child: Icon(Icons.group, color: Colors.grey[700], size: 20),
          ),
          title: Text(
            groupName,
            style: TextStyle(
              color: Colors.grey[800],
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          subtitle: Text(
            'Tap to view fee history',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
          trailing: NeomorphicContainer(
            width: 30,
            height: 30,
            child: Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.grey[700],
              size: 14,
            ),
          ),
        ),
      ),
    );
  }
}
