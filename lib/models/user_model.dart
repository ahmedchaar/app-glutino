class User {
  final String email;
  final String firstName;
  final String lastName;
  final String? photoBase64;
  final String sensitivity; // 👈 NEW

  User({
    required this.email,
    required this.firstName,
    required this.lastName,
    this.photoBase64,
    this.sensitivity = 'Sensible', // Default value
  });
  
  User copyWith({
    String? firstName, 
    String? lastName, 
    String? email, 
    String? photoBase64,
    String? sensitivity,
  }) {
    return User(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      photoBase64: photoBase64 ?? this.photoBase64,
      sensitivity: sensitivity ?? this.sensitivity,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'photoBase64': photoBase64,
      'sensitivity': sensitivity,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      photoBase64: json['photoBase64'] ?? '',
      sensitivity: json['sensitivity'] ?? 'Sensible',
    );
  }
}

