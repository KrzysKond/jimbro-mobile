class Member {
  final String name;
  final int id;
  final String? profilePicture;
  Member({ required this.name, required this.id, required this.profilePicture});

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      name: json['name'],
      id: json['id'],
      profilePicture: json['profile_picture'],
    );
  }
}
