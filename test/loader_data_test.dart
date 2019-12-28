// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@TestOn('vm')

import 'dart:convert';

import 'package:resource/resource.dart';
import 'package:test/test.dart';

const content = 'Rødgrød med fløde';

void main() {
  void testFile(Encoding encoding, bool base64) {
    group("${encoding.name}${base64 ? " base64" : ""}", () {
      Uri uri;
      setUp(() {
        var dataUri =
            UriData.fromString(content, encoding: encoding, base64: base64);
        uri = dataUri.uri;
      });

      test('read string', () async {
        var loader = ResourceLoader.defaultLoader;
        var string = await loader.readAsString(uri, encoding: encoding);
        expect(string, content);
      });

      test('read bytes', () async {
        var loader = ResourceLoader.defaultLoader;
        var bytes = await loader.readAsBytes(uri);
        expect(bytes, encoding.encode(content));
      });

      test('read byte stream', () async {
        var loader = ResourceLoader.defaultLoader;
        var bytes = loader.openRead(uri);
        var buffer = [];
        await bytes.forEach(buffer.addAll);
        expect(buffer, encoding.encode(content));
      });
    });
  }

  testFile(latin1, true);
  testFile(latin1, false);
  testFile(utf8, true);
  testFile(utf8, false);
}
