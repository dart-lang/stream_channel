abstract class ReceivePort implements Stream {
  void close();

  SendPort get sendPort;

  factory ReceivePort() =>
      throw UnsupportedError('IsolateChannel does not work on this platform');
}

abstract class SendPort {
  void send(dynamic data);
}
