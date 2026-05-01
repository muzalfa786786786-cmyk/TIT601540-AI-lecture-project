// lib/models/user_model.dart

class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? photoURL;
  final DateTime? createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.photoURL,
    this.createdAt,
  });

  // For Firestore
  factory UserModel.fromFirestore(Map<String, dynamic> data, String id) {
    return UserModel(
      id: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? 'student',
      photoURL: data['photoURL'],
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as dynamic).toDate()  // ✅ Fixed: handle Timestamp
          : null,
    );
  }

  // For JSON storage (SharedPreferences)
  factory UserModel.fromJson(Map<String, dynamic> json, String id) {
    return UserModel(
      id: id,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'student',
      photoURL: json['photoURL'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'role': role,
      'photoURL': photoURL,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  // Copy with method for updates
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? photoURL,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      photoURL: photoURL ?? this.photoURL,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}