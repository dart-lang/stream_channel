// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

abstract class ReceivePort implements Stream {
  void close();

  SendPort get sendPort;

  factory ReceivePort() =>
      throw UnsupportedError('IsolateChannel does not work on this platform');
}

abstract class SendPort {
  void send(dynamic data);
}