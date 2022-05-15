import 'package:equatable/equatable.dart';

class Credential extends Equatable {
  final int? id;
  final String username;
  final String password;
  final String host;
  final int port;

  const Credential({
    this.id,
    required this.username,
    required this.password,
    required this.host,
    required this.port,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {
      'username': username,
      'password': password,
      'host': host,
      'port': port,
    };

    if (id != null) data['id'] = id;
    return data;
  }

  static Credential fromMap(Map<String, dynamic> map) {
    return Credential(
      id: map.containsKey("id") ? map["id"] : null,
      username: map["username"],
      password: map["password"],
      host: map["host"],
      port: map["port"],
    );
  }

  // Implement props for equality checks
  @override
  List<Object> get props => [username, password, host, port];

  // To generate toString methods
  @override
  bool get stringify => true;
}
