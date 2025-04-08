class UserModels {
  String? uid;
  String? email;
  String? displayName;
  String? photoUrl;

  UserModels({this.uid, this.email, this.displayName, this.photoUrl});

  factory UserModels.fromJson(Map<String, dynamic> json) {
    return UserModels(
      uid: json['uid'],
      email: json['email'],
      displayName: json['displayName'],
      photoUrl: json['photoUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
    };
  }
}
