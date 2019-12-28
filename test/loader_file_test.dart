// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@TestOn('vm')

import 'dart:convert';
import 'dart:io';

import 'package:resource/resource.dart';
import 'package:test/test.dart';

const content = 'Rødgrød med fløde';

void main() {
  Directory dir;
  var dirCounter = 0;
  setUp(() {
    dir = Directory.systemTemp.createTempSync('testdir${dirCounter++}');
  });
  void testFile(Encoding encoding) {
    group('${encoding.name}', () {
      File file;
      Uri uri;
      setUp(() {
        var dirUri = dir.uri;
        uri = dirUri.resolve('file.txt');
        file = File.fromUri(uri);
        // ignore: cascade_invocations
        file.writeAsBytesSync(encoding.encode(content));
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

      tearDown(() {
        file.deleteSync();
      });
    });
  }

  testFile(latin1);
  testFile(utf8);

  tearDown(() {
    dir.delete(recursive: true);
  });
}
