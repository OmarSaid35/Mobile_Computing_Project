class UserModel {
  String _id;
  String _email;
  String _name;
  DateTime _birthDate;
  bool _isAdmin;
  String _schoolName; // New field for security question (school name)

  UserModel({
    required String id,
    required String email,
    required String name,
    required DateTime birthDate,
    bool isAdmin = false,
    required String schoolName, // Add schoolName to the constructor
  })  : _id = id,
        _email = email,
        _name = name,
        _birthDate = birthDate,
        _isAdmin = isAdmin,
        _schoolName = schoolName; // Initialize schoolName

  // Getters
  String get id => _id;
  String get email => _email;
  String get name => _name;
  DateTime get birthDate => _birthDate;
  bool get isAdmin => _isAdmin;
  String get schoolName => _schoolName; // Getter for schoolName

  // Setters
  set id(String value) => _id = value;
  set email(String value) => _email = value;
  set name(String value) => _name = value;
  set birthDate(DateTime value) => _birthDate = value;
  set isAdmin(bool value) => _isAdmin = value;
  set schoolName(String value) => _schoolName = value; // Setter for schoolName

  // Updated fromJson to include schoolName
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      birthDate: DateTime.parse(json['birthDate']),
      isAdmin: json['isAdmin'] ?? false,
      schoolName: json['schoolName'] ?? '', // Handle missing schoolName
    );
  }

  // Updated toJson to include schoolName
  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'email': _email,
      'name': _name,
      'birthDate': _birthDate.toIso8601String(),
      'isAdmin': _isAdmin,
      'schoolName': _schoolName, // Add schoolName to JSON
    };
  }
}
