import 'package:flutter/material.dart';
import '../shared/enums.dart'; // Import shared enums and helpers

class ResponsiveFilters extends StatelessWidget {
  final bool showFilters;
  final LeaveStatus? selectedStatus;
  final String? selectedSection;
  final ValueChanged<LeaveStatus?> onStatusChanged;
  final ValueChanged<String?> onSectionChanged;
  final VoidCallback onApplyFilters;
  final VoidCallback onClearFilters;
  final bool isMobile;
  final bool isDesktop;
  final double horizontalPadding;

  const ResponsiveFilters({
    super.key,
    required this.showFilters,
    required this.selectedStatus,
    required this.selectedSection,
    required this.onStatusChanged,
    required this.onSectionChanged,
    required this.onApplyFilters,
    required this.onClearFilters,
    required this.isMobile,
    required this.isDesktop,
    required this.horizontalPadding,
  });

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = !isMobile;

    double getFilterHeight() {
      if (!showFilters) return 0;

      final basePadding = isLargeScreen ? 40 : 32; // Increased padding
      final dropdownHeight = 56.0;
      final spacingHeight = 16.0;
      final buttonHeight = 40.0;

      if (isLargeScreen) {
        return basePadding + dropdownHeight + spacingHeight + buttonHeight;
      } else {
        return basePadding + dropdownHeight + spacingHeight + buttonHeight;
      }
    }

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: getFilterHeight(),
      child:
          showFilters
              ? Container(
                margin: EdgeInsets.symmetric(horizontal: horizontalPadding),
                padding: EdgeInsets.all(isLargeScreen ? 24 : 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      isLargeScreen
                          ? Row(
                            children: [
                              Expanded(child: _buildStatusDropdown()),
                              SizedBox(width: 16),
                              Expanded(child: _buildSectionDropdown()),
                              Spacer(flex: 2),
                            ],
                          )
                          : Row(
                            children: [
                              Expanded(child: _buildStatusDropdown()),
                              SizedBox(width: 16),
                              Expanded(child: _buildSectionDropdown()),
                            ],
                          ),
                      SizedBox(height: 16),
                      // Clear All button only
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: onClearFilters,
                            child: Text(
                              "Clear All",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
              : SizedBox.shrink(),
    );
  }

  Widget _buildStatusDropdown() {
    return DropdownButtonFormField<LeaveStatus>(
      decoration: InputDecoration(
        labelText: "Status",
        labelStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      dropdownColor: Color(0xFF6366F1),
      style: TextStyle(color: Colors.white),
      initialValue: selectedStatus,
      items: [
        DropdownMenuItem(
          value: null,
          child: Text("All Status", style: TextStyle(color: Colors.white)),
        ),
        ...LeaveStatus.values.map(
          (status) => DropdownMenuItem(
            value: status,
            child: Text(
              LeaveStatusHelper.getStatusText(status),
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
      onChanged: onStatusChanged,
    );
  }

  Widget _buildSectionDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: "Section",
        labelStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      dropdownColor: Color(0xFF6366F1),
      style: TextStyle(color: Colors.white),
      initialValue: selectedSection,
      items: [
        DropdownMenuItem(
          value: null,
          child: Text("All Sections", style: TextStyle(color: Colors.white)),
        ),
        DropdownMenuItem(
          value: "Section A",
          child: Text("Section A", style: TextStyle(color: Colors.white)),
        ),
        DropdownMenuItem(
          value: "Section B",
          child: Text("Section B", style: TextStyle(color: Colors.white)),
        ),
        DropdownMenuItem(
          value: "Section C",
          child: Text("Section C", style: TextStyle(color: Colors.white)),
        ),
      ],
      onChanged: onSectionChanged,
    );
  }
}
