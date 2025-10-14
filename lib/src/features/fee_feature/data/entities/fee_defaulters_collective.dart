// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class FeeDefaultersCollective {
  num remaingFee;
  num total;
  FeeDefaultersCollective({required this.remaingFee, required this.total});

  FeeDefaultersCollective copyWith({num? remaingFee, num? total}) {
    return FeeDefaultersCollective(
      remaingFee: remaingFee ?? this.remaingFee,
      total: total ?? this.total,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'remaingFee': remaingFee, 'total': total};
  }

  factory FeeDefaultersCollective.fromMap(Map<String, dynamic> map) {
    return FeeDefaultersCollective(
      remaingFee: map['remaingFee'] as num,
      total: map['total'] as num,
    );
  }

  String toJson() => json.encode(toMap());

  factory FeeDefaultersCollective.fromJson(String source) =>
      FeeDefaultersCollective.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  @override
  String toString() =>
      'FeeDefaultersCollective(remaingFee: $remaingFee, total: $total)';

  @override
  bool operator ==(covariant FeeDefaultersCollective other) {
    if (identical(this, other)) return true;

    return other.remaingFee == remaingFee && other.total == total;
  }

  @override
  int get hashCode => remaingFee.hashCode ^ total.hashCode;
}
