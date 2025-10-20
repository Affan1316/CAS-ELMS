class GroupFeeHistory {
  final double received;
  final double total;
  final double remaining;

  GroupFeeHistory({
    required this.received,
    required this.total,
    required this.remaining,
  });

  // Factory constructor to create instance from Firestore Map
  factory GroupFeeHistory.fromMap(Map<String, dynamic> map) {
    // Direct conversion from num to double since Firestore uses num
    final double received = (map['received'] as num?)?.toDouble() ?? 0.0;
    final double total = (map['total'] as num?)?.toDouble() ?? 0.0;

    // Calculate remaining amount
    final double remaining = total - received;

    return GroupFeeHistory(
      received: received,
      total: total,
      remaining: remaining,
    );
  }

  // Convert to Map for Firestore (if needed)
  Map<String, dynamic> toMap() {
    return {
      'received': received,
      'total': total,
      // Note: remaining is calculated, so we don't store it in Firestore
    };
  }

  // Override toString for debugging
  @override
  String toString() {
    return 'GroupFeeHistory{received: $received, total: $total, remaining: $remaining}';
  }

  // Override equality for testing and comparisons
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GroupFeeHistory &&
          runtimeType == other.runtimeType &&
          received == other.received &&
          total == other.total &&
          remaining == other.remaining;

  @override
  int get hashCode => received.hashCode ^ total.hashCode ^ remaining.hashCode;

  // Copy with method for immutability
  GroupFeeHistory copyWith({
    double? received,
    double? total,
    double? remaining,
  }) {
    return GroupFeeHistory(
      received: received ?? this.received,
      total: total ?? this.total,
      remaining: remaining ?? this.remaining,
    );
  }
}
