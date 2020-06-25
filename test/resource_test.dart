// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@TestOn('vm')

import 'dart:async' show Future, Stream;
import 'dart:convert' show Encoding, ascii;
import 'dart:isolate' show Isolate;
import 'package:resource/resource.dart';
import 'package:test/test.dart';

void main() {
  Uri pkguri(path) => Uri(scheme: 'package', path: path);

  Future<Uri> resolve(Uri source) async {
    if (source.scheme == 'package') {
      return Isolate.resolvePackageUri(source);
    }
    return Uri.base.resolveUri(source);
  }

  group('loading', () {
    Future testLoad(Uri uri) async {
      var loader = LogLoader();
      var resource = Resource(uri, loader: loader);
      var res = await resource.openRead().toList();
      var resolved = await resolve(uri);
      expect(res, [
        [0, 0, 0]
      ]);
      var res1 = await resource.readAsBytes();
      expect(res1, [0, 0, 0]);
      var res2 = await resource.readAsString(encoding: ascii);
      expect(res2, '\x00\x00\x00');

      expect(loader.requests, [
        ['Stream', resolved],
        ['Bytes', resolved],
        ['String', resolved, ascii]
      ]);
    }

    test('load package: URIs', () async {
      await testLoad(pkguri('resource/bar/baz'));
      await testLoad(pkguri('test/foo/baz'));
    });
    test('load non-pkgUri', () async {
      await testLoad(Uri.parse('file://localhost/something?x#y'));
      await testLoad(Uri.parse('http://auth/something?x#y'));
      await testLoad(Uri.parse('https://auth/something?x#y'));
      await testLoad(Uri.parse('data:,something?x'));
      await testLoad(Uri.parse('unknown:/something'));
    });
  });
}

class LogLoader implements ResourceLoader {
  final List requests = [];
  void reset() {
    requests.clear();
  }

  @override
  Stream<List<int>> openRead(Uri uri) async* {
    requests.add(['Stream', uri]);
    yield [0x00, 0x00, 0x00];
  }

  @override
  Future<List<int>> readAsBytes(Uri uri) async {
    requests.add(['Bytes', uri]);
    return [0x00, 0x00, 0x00];
  }

  @override
  Future<String> readAsString(Uri uri, {Encoding encoding}) async {
    requests.add(['String', uri, encoding]);
    return '\x00\x00\x00';
  }
}
