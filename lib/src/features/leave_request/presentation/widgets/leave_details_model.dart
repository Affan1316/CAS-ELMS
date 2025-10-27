import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class LeaveDetailsModal {
  static double _getResponsiveFontSize(double screenWidth, double mobile, double tablet) {
    if (screenWidth >= 768) return tablet;
    return mobile;
  }

  static Widget _buildDetailRow(String label, String value, double screenWidth, bool isTablet) {
    return Padding(
      padding: EdgeInsets.only(bottom: isTablet ? 20 : 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: isTablet ? 120 : 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: _getResponsiveFontSize(screenWidth, 14, 16),
                fontWeight: FontWeight.w600,
                color: const Color(0xFF8E8E93),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: _getResponsiveFontSize(screenWidth, 14, 16),
                fontWeight: FontWeight.w500,
                color: const Color(0xFF1C1C1E),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static void show(BuildContext context, Map<String, dynamic> item) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth >= 768;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      constraints: isTablet 
          ? BoxConstraints(
              maxWidth: 600,
              maxHeight: screenHeight * 0.8,
            )
          : null,
      builder: (context) => Container(
        height: isTablet ? screenHeight * 0.8 : screenHeight * 0.7,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isTablet ? 32 : 28),
            topRight: Radius.circular(isTablet ? 32 : 28),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(isTablet ? 32 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: isTablet ? 50 : 40,
                  height: isTablet ? 5 : 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: isTablet ? 32 : 24),
              Text(
                'Leave Details',
                style: TextStyle(
                  fontSize: _getResponsiveFontSize(screenWidth, 24, 28),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1C1C1E),
                ),
              ),
              SizedBox(height: isTablet ? 32 : 24),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildDetailRow('Type', item['type'] as String, screenWidth, isTablet),
                      _buildDetailRow('From Date', item['fromDate'] as String, screenWidth, isTablet),
                      _buildDetailRow('To Date', item['toDate'] as String, screenWidth, isTablet),
                      _buildDetailRow('Status', item['status'] as String, screenWidth, isTablet),
                      _buildDetailRow('Applied Date', item['appliedDate'] as String, screenWidth, isTablet),
                      _buildDetailRow('Reason', item['reason'] as String, screenWidth, isTablet),
                      
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}