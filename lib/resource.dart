// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// A `Resource` is data that can be read into a Dart program.
///
/// A resource is identified by a URI. It can be loaded as bytes or data.
/// The resource URI may be a `package:` URI.
///
/// Example:
///
///     var resource = new Resource("package:foo/foo_data.txt");
///     var string = await resource.readAsString(utf8);
///     print(string);
///
/// Example:
///
///     var resource = new Resource("http://example.com/data.json");
///     var obj = await resource.openRead()   // Reads as stream of bytes.
///                             .transform(utf8.fuse(JSON).decoder)
///                             .first;
library resource;

export 'src/resource.dart' show Resource;
export 'src/resource_loader.dart' show ResourceLoader;
