import 'package:jimbro_mobile/models/member.dart';

class Group {
  final int id;
  final String name;
  final List<Member> members;

  Group({required this.id, required this.name, required this.members});

  factory Group.fromJson(Map<String, dynamic> json) {
    var membersList = json['members'] as List?; // Use List?
    List<Member> members = (membersList ?? []).map((i) => Member.fromJson(i)).toList();
    return Group(
      id: json['id'],
      name: json['name'],
      members: members
    );
  }
  String get membersText {
    return members.isNotEmpty
        ? members.map((member) => member.name).join(', ')
        : 'No members';
  }
}