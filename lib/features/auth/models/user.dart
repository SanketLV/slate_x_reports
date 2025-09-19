class User {
  final String firstName;
  final String lastName;
  final String token;
  final String roleId;
  final String roleName;
  final int branchId;
  final int employeeId;
  final int restaurantId;

  User({
    required this.firstName,
    required this.lastName,
    required this.token,
    required this.roleId,
    required this.roleName,
    required this.branchId,
    required this.employeeId,
    required this.restaurantId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['first_name'] ?? "",
      lastName: json['last_name'] ?? "",
      token: json['token'] ?? "",
      roleId: json['role_id'] ?? "",
      roleName: json['role_name'] ?? "",
      branchId: json['branch_id'] ?? 0,
      employeeId: json['employee_id'] ?? 0,
      restaurantId: json['restaurant_id'] ?? 0,
    );
  }
}
