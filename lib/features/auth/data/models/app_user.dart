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
    id: json['id'] as String? ?? '',
    firebaseUid: json['firebase_uid'] as String? ?? '',
    name: json['name'] as String?,
    email: json['email'] as String?,
    phone: json['phone'] as String?,
    photoUrl: json['photo_url'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'firebase_uid': firebaseUid,
    'name': name,
    'email': email,
    'phone': phone,
    'photo_url': photoUrl,
  };
}
