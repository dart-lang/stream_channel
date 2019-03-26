// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';

import 'package:stream_channel/stream_channel.dart';
import 'package:test/test.dart';

void main() {
  StreamController<String> streamController;
  StreamController<String> sinkController;
  StreamChannel<String> channel;
  setUp(() {
    streamController = StreamController<String>();
    sinkController = StreamController<String>();
    channel =
        StreamChannel<String>(streamController.stream, sinkController.sink);
  });

  test("decodes JSON emitted by the channel", () {
    var transformed = channel.transform(jsonDocument);
    streamController.add('{"foo": "bar"}');
    expect(transformed.stream.first, completion(equals({"foo": "bar"})));
  });

  test("encodes objects added to the channel", () {
    var transformed = channel.transform(jsonDocument);
    transformed.sink.add({"foo": "bar"});
    expect(sinkController.stream.first,
        completion(equals(jsonEncode({"foo": "bar"}))));
  });

  test("supports the reviver function", () {
    var transformed = channel
        .transform(JsonDocumentTransformer(reviver: (key, value) => "decoded"));
    streamController.add('{"foo": "bar"}');
    expect(transformed.stream.first, completion(equals("decoded")));
  });

  test("supports the toEncodable function", () {
    var transformed = channel
        .transform(JsonDocumentTransformer(toEncodable: (object) => "encoded"));
    transformed.sink.add(Object());
    expect(sinkController.stream.first, completion(equals('"encoded"')));
  });

  test("emits a stream error when incoming JSON is malformed", () {
    var transformed = channel.transform(jsonDocument);
    streamController.add("{invalid");
    expect(transformed.stream.first, throwsFormatException);
  });

  test("synchronously throws if an unencodable object is added", () {
    var transformed = channel.transform(jsonDocument);
    expect(() => transformed.sink.add(Object()),
        throwsA(TypeMatcher<JsonUnsupportedObjectError>()));
  });
}
