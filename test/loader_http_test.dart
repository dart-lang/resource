// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@TestOn('vm')

import 'dart:convert';
import 'dart:io';

import 'package:pedantic/pedantic.dart';
import 'package:resource/resource.dart';
import 'package:test/test.dart';

const content = 'Rødgrød med fløde';

void main() {
  HttpServer server;
  Uri uri;
  setUp(() async {
    var addr = (await InternetAddress.lookup('localhost'))[0];
    server = await HttpServer.bind(addr, 0);
    var port = server.port;
    uri = Uri.parse('http://localhost:$port/default.html');
    unawaited(server.forEach((HttpRequest request) {
      if (request.uri.path.endsWith('.not')) {
        request.response
          ..statusCode = HttpStatus.notFound
          ..close();
        return;
      }
      var encodings = request.headers[HttpHeaders.acceptCharsetHeader];
      var encoding = parseAcceptCharset(encodings);
      request.response.headers.contentType =
          ContentType('text', 'plain', charset: encoding.name);
      if (request.uri.query.contains('length')) {
        request.response.headers.contentLength =
            encoding.encode(content).length;
      }
      request.response
        ..write(content)
        ..close();
    }).catchError((e, stack) {
      print(e);
      print(stack);
    }));
  });

  test('Default encoding', () async {
    var loader = ResourceLoader.defaultLoader;
    var string = await loader.readAsString(uri);
    expect(string, content);
  });

  test('Latin-1 encoding', () async {
    var loader = ResourceLoader.defaultLoader;
    var string = await loader.readAsString(uri, encoding: latin1);
    expect(string, content);
  });

  test('Latin-1 encoding w/ length', () async {
    // Regression test for issue #21.
    var loader = ResourceLoader.defaultLoader;
    // ignore: non_constant_identifier_names
    var Uri = uri.replace(query: 'length'); // Request length set.
    var string = await loader.readAsString(Uri, encoding: latin1);
    expect(string, content);
  });

  test('UTF-8 encoding', () async {
    var loader = ResourceLoader.defaultLoader;
    // ignore: non_constant_identifier_names
    var Uri = uri.replace(query: 'length'); // Request length set.
    var string = await loader.readAsString(Uri, encoding: utf8);
    expect(string, content);
  });

  test('UTF-8 encoding w/ length', () async {
    var loader = ResourceLoader.defaultLoader;
    var string = await loader.readAsString(uri, encoding: utf8);
    expect(string, content);
  });

  test('bytes', () async {
    var loader = ResourceLoader.defaultLoader;
    var bytes = await loader.readAsBytes(uri); // Sender uses Latin-1.
    expect(bytes, content.codeUnits);
  });

  test('bytes w/ length', () async {
    var loader = ResourceLoader.defaultLoader;
    // ignore: non_constant_identifier_names
    var Uri = uri.replace(query: 'length'); // Request length set.
    var bytes = await loader.readAsBytes(Uri); // Sender uses Latin-1.
    expect(bytes, content.codeUnits);
  });

  test('byte stream', () async {
    var loader = ResourceLoader.defaultLoader;
    var bytes = loader.openRead(uri); // Sender uses Latin-1.
    var buffer = [];
    await bytes.forEach(buffer.addAll);
    expect(buffer, content.codeUnits);
  });

  test('not found - String', () async {
    var loader = ResourceLoader.defaultLoader;
    var badUri = uri.resolve('file.not'); // .not makes server fail.
    expect(loader.readAsString(badUri), throwsException);
  });

  test('not found - bytes', () async {
    var loader = ResourceLoader.defaultLoader;
    var badUri = uri.resolve('file.not'); // .not makes server fail.
    expect(loader.readAsBytes(badUri), throwsException);
  });

  test('not found - byte stream', () async {
    var loader = ResourceLoader.defaultLoader;
    var badUri = uri.resolve('file.not'); // .not makes server fail.
    expect(loader.openRead(badUri).length, throwsException);
  });

  tearDown(() {
    server.close();
    server = null;
  });
}

Encoding parseAcceptCharset(List<String> headers) {
  Encoding encoding = latin1;
  if (headers != null) {
    var weight = 0.0;
    var pattern = RegExp(r'([\w-]+)(;\s*q=[\d.]+)?');
    for (var acceptCharset in headers) {
      for (var match in pattern.allMatches(acceptCharset)) {
        var e = Encoding.getByName(match[1]);
        if (e == null) continue;
        var w = 1.0;
        if (match[2] != null) {
          w = double.parse(match[2]);
        }
        if (w > weight) {
          weight = w;
          encoding = e;
        }
      }
    }
  }
  return encoding;
}
