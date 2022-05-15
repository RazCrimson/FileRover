import 'package:dartssh2/dartssh2.dart';
import 'package:file_rover/fs/backends/sftp/controller.dart';
import 'package:file_rover/models/credential.dart';

class SftpConnection {
  final Credential credential;

  SSHClient? _client;
  SftpClient? _sftpClient;

  SftpConnection(this.credential);

  Future<void> connect() async {
    final socket = await SSHSocket.connect(credential.host, credential.port);
    _client = SSHClient(
      socket,
      username: credential.username,
      onPasswordRequest: () => credential.password,
    );

    _sftpClient = await _client!.sftp();
  }

  Future<void> disconnect() async {
    _client?.close();
    await _client?.done;

    _client = null;
    _sftpClient = null;
  }

  bool get isConnected => _sftpClient != null;

  Future<SftpFsController> getController() async {
    if (!isConnected) await connect();
    return SftpFsController(_client!, _sftpClient!);
  }
}
