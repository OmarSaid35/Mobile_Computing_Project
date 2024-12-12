class UserModel {
  String _id;
  String _email;
  String _name;
  DateTime _birthDate;
  bool _isAdmin;

  UserModel({
    required String id,
    required String email,
    required String name,
    required DateTime birthDate,
    bool isAdmin = false,
  })  : _id = id,
        _email = email,
        _name = name,
        _birthDate = birthDate,
        _isAdmin = isAdmin;

  // Getters
  String get id => _id;
  String get email => _email;
  String get name => _name;
  DateTime get birthDate => _birthDate;
  bool get isAdmin => _isAdmin;

  // Setters
  set id(String value) => _id = value;
  set email(String value) => _email = value;
  set name(String value) => _name = value;
  set birthDate(DateTime value) => _birthDate = value;
  set isAdmin(bool value) => _isAdmin = value;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      birthDate: DateTime.parse(json['birthDate']),
      isAdmin: json['isAdmin'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'email': _email,
      'name': _name,
      'birthDate': _birthDate.toIso8601String(),
      'isAdmin': _isAdmin,
    };
  }
}
