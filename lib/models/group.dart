import 'package:jimbro_mobile/models/member.dart';

class Group {
  final int id;
  final String name;
  final List<int> members;

  Group({required this.id, required this.name, required this.members});

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      name: json['name'],
      members: List<int>.from(json['members']),
    );
  }
}
