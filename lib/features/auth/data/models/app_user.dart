class AppUser {
  final String id;
  final String firebaseUid;
  final String? name;
  final String? email;
  final String? phone;
  final String? photoUrl;

  AppUser({
    required this.id,
    required this.firebaseUid,
    this.name,
    this.email,
    this.phone,
    this.photoUrl,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
    id: json['id'],
    firebaseUid: json['firebase_uid'],
    name: json['name'],
    email: json['email'],
    phone: json['phone'],
    photoUrl: json['photo_url'],
  );

  Map<String, dynamic> toJson() => {
    'firebase_uid': firebaseUid,
    'name': name,
    'email': email,
    'phone': phone,
    'photo_url': photoUrl,
  };
}
