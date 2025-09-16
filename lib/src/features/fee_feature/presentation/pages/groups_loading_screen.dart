// Data Models

import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/data_source/data_service_fee_feature.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/gradient_background.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/entities/group_fee_feature.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/pages/group_members_screen.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/pages/groups_list_screen.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/neu_card.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/responsive_padding.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/responsive_text.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/screen_header.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/search_field.dart';

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
