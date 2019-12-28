// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@TestOn('browser')

import 'dart:convert';

import 'package:resource/resource.dart';
import 'package:test/test.dart';

const content = 'Rødgrød med fløde';

void main() {
  // Assume test files located next to Uri.base.
  // This is how "pub run test" currently works.

  test('Default encoding', () async {
    var loader = ResourceLoader.defaultLoader;
    // The HTTPXmlRequest loader defaults to UTF-8 encoding.
    var uri = Uri.base.resolve('testfile-utf8.txt');
    var string = await loader.readAsString(uri);
    expect(string, content);
  });

  test('Latin-1 encoding', () async {
    var loader = ResourceLoader.defaultLoader;
    var uri = Uri.base.resolve('testfile-latin1.txt');
    var string = await loader.readAsString(uri, encoding: latin1);
    expect(string, content);
  });

  test('UTF-8 encoding', () async {
    var loader = ResourceLoader.defaultLoader;
    var uri = Uri.base.resolve('testfile-utf8.txt');
    var string = await loader.readAsString(uri, encoding: utf8);
    expect(string, content);
  });

  test('bytes', () async {
    var loader = ResourceLoader.defaultLoader;
    var uri = Uri.base.resolve('testfile-latin1.txt');
    var bytes = await loader.readAsBytes(uri);
    expect(bytes, content.codeUnits);
  });

  test('byte stream', () async {
    var loader = ResourceLoader.defaultLoader;
    var uri = Uri.base.resolve('testfile-latin1.txt');
    var bytes = loader.openRead(uri);
    var buffer = [];
    await bytes.forEach(buffer.addAll);
    expect(buffer, content.codeUnits);
  });
}
