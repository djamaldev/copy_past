class PasswordListManager {
  int? id;
  String? password;

  PasswordListManager({
    this.id,
    this.password,
  });

  @override
  String toString() {
    return 'PasswordListManager{id: $id, text: $password}';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'password': password,
    };
  }

  PasswordListManager.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    password = json['password'];
  }
}
