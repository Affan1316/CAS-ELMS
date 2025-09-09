// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Course {
  final String id;
  final String name;
  final String? description;
  Course({
    required this.id,
    required this.name,
    this.description, 
  });
  

  Course copyWith({
    String? id,
    String? name,
    String? description,
  }) {
    return Course(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
    };
  }

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Course.fromJson(String source) => Course.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Course(id: $id, name: $name, description: $description)';

  @override
  bool operator ==(covariant Course other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.description == description;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ description.hashCode;
}
