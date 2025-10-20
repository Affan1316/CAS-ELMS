/// Result class for installment processing
class InstallmentProcessResult {
  final List<Map<String, dynamic>> installments;
  final double totalPaidAmount;
  final bool updated;

  const InstallmentProcessResult({
    required this.installments,
    required this.totalPaidAmount,
    required this.updated,
  });
}
