import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/scripts/migrate_missing_installments.dart';
import 'package:flutter_cas_app_main/src/services/fee_plan_validation_service.dart';

/// Admin Tool: Migration & Validation Dashboard
/// 
/// PURPOSE:
/// Provides UI for admins to:
/// 1. Run the migration script to fix missing students
/// 2. View validation results showing discrepancies
/// 3. Monitor which students need fee plans created
/// 
/// HOW TO ACCESS:
/// Add this to your admin menu or settings:
/// Navigator.push(context, MaterialPageRoute(builder: (_) => MigrationValidationPage()));

class MigrationValidationPage extends StatefulWidget {
  const MigrationValidationPage({super.key});

  @override
  State<MigrationValidationPage> createState() => _MigrationValidationPageState();
}

class _MigrationValidationPageState extends State<MigrationValidationPage> {
  final FeePlanValidationService _validationService = FeePlanValidationService();
  
  bool _isMigrating = false;
  bool _isvalidating = false;
  MigrationResult? _migrationResult;
  List<GroupFeeValidationSummary> _validationResults = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Migration & Validation'),
        backgroundColor: const Color(0xFF6C5CE7),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Migration Section
            _buildSectionCard(
              title: '🔧 Fix Missing Students',
              description: 'Create missing installment documents for enrolled students',
              child: Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: _isMigrating ? null : _runMigration,
                    icon: _isMigrating 
                        ? const SizedBox(
                            width: 20, 
                            height: 20, 
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.sync),
                    label: Text(_isMigrating ? 'Running Migration...' : 'Run Migration'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C5CE7),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: _isMigrating ? null : _runDryRun,
                    icon: const Icon(Icons.visibility),
                    label: const Text('Preview (Dry Run)'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                  if (_migrationResult != null) ...[
                    const SizedBox(height: 16),
                    _buildMigrationResultCard(),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Validation Section
            _buildSectionCard(
              title: '📊 Validation Report',
              description: 'Check for discrepancies in all groups',
              child: Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: _isvalidating ? null : _runValidation,
                    icon: _isvalidating
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.assessment),
                    label: Text(_isvalidating ? 'Validating...' : 'Run Validation'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00D9A3),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                  if (_validationResults.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _buildValidationResultsCard(),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required String description,
    required Widget child,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildMigrationResultCard() {
    final result = _migrationResult!;
    return Card(
      color: result.fatalError != null 
          ? Colors.red[50]
          : result.migratedStudents.isEmpty 
              ? Colors.blue[50]
              : Colors.green[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  result.fatalError != null
                      ? Icons.error
                      : result.migratedStudents.isEmpty
                          ? Icons.info
                          : Icons.check_circle,
                  color: result.fatalError != null
                      ? Colors.red
                      : result.migratedStudents.isEmpty
                          ? Colors.blue
                          : Colors.green,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    result.fatalError != null
                        ? 'Migration Failed'
                        : result.migratedStudents.isEmpty
                            ? 'No Missing Students Found'
                            : 'Migration Successful!',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('Groups processed: ${result.totalGroupsProcessed}'),
            Text('Students migrated: ${result.migratedStudents.length}'),
            Text('Errors: ${result.errors.length}'),
            Text('Duration: ${result.duration?.inSeconds ?? 0}s'),
            if (result.migratedStudents.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text('Migrated IDs:', style: TextStyle(fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: result.migratedStudents
                    .map((id) => Chip(
                          label: Text(id, style: const TextStyle(fontSize: 12)),
                          padding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                        ))
                    .toList(),
              ),
            ],
            if (result.errors.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text('Errors:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
              ...result.errors.map((e) => Text('• $e', style: const TextStyle(color: Colors.red, fontSize: 12))),
            ],
            if (result.fatalError != null) ...[
              const SizedBox(height: 8),
              Text('Fatal: ${result.fatalError}', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildValidationResultsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Group Validation Summary',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ..._validationResults.map((summary) => _buildGroupSummaryCard(summary)),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupSummaryCard(GroupFeeValidationSummary summary) {
    final hasIssues = summary.hasDiscrepancies || summary.pendingFeePlans > 0;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: hasIssues ? Colors.orange[50] : Colors.green[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: hasIssues ? Colors.orange : Colors.green,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                hasIssues ? Icons.warning : Icons.check_circle,
                color: hasIssues ? Colors.orange : Colors.green,
                size: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  summary.groupId,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('Enrolled: ${summary.totalEnrolled}'),
          Text('Has Installment Doc: ${summary.hasInstallmentDoc}'),
          Text('With Fee Plans: ${summary.withFeePlans}'),
          Text('Pending Fee Plans: ${summary.pendingFeePlans}'),
          if (summary.missingInstallmentDocs > 0)
            Text(
              '⚠️ Missing: ${summary.missingInstallmentDocs} students',
              style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          const Divider(),
          Text('Total Fees: PKR ${summary.totalFees.toStringAsFixed(0)}'),
          Text('Received: PKR ${summary.totalReceived.toStringAsFixed(0)}'),
          Text('Remaining: PKR ${summary.remainingBalance.toStringAsFixed(0)}'),
          if (summary.error != null)
            Text('Error: ${summary.error}', style: const TextStyle(color: Colors.red)),
        ],
      ),
    );
  }

  Future<void> _runMigration() async {
    setState(() {
      _isMigrating = true;
      _migrationResult = null;
    });

    try {
      final result = await runInstallmentMigration(dryRun: false);
      setState(() {
        _migrationResult = result;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result.fatalError != null
                  ? 'Migration failed: ${result.fatalError}'
                  : 'Migration complete! ${result.migratedStudents.length} students fixed',
            ),
            backgroundColor: result.fatalError != null ? Colors.red : Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Migration failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isMigrating = false;
      });
    }
  }

  Future<void> _runDryRun() async {
    setState(() {
      _isMigrating = true;
      _migrationResult = null;
    });

    try {
      final result = await runInstallmentMigration(dryRun: true);
      setState(() {
        _migrationResult = result;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Dry run complete! ${result.migratedStudents.length} students would be migrated'),
            backgroundColor: Colors.blue,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Dry run failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isMigrating = false;
      });
    }
  }

  Future<void> _runValidation() async {
    setState(() {
      _isvalidating = true;
      _validationResults = [];
    });

    try {
      final results = await _validationService.validateAllGroups();
      setState(() {
        _validationResults = results;
      });

      if (mounted) {
        final groupsWithIssues = results.where((r) => r.hasDiscrepancies || r.pendingFeePlans > 0).length;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Validation complete! ${results.length} groups checked, $groupsWithIssues have issues',
            ),
            backgroundColor: groupsWithIssues > 0 ? Colors.orange : Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Validation failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isvalidating = false;
      });
    }
  }
}
