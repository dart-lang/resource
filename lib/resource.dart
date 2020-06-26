// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// **NOTICE** This package is **discontinued**.
/// It will not be maintained or upgraded in the future.
///
/// This package combines two functionalities:
/// * Converting a `package:` URI to a platform specific URI
///   (usually `http:` or `file:`, depending on the platform)
/// * Load the contents of such platform specific URIs.
///
/// The former no longer makes sense when a large number of Dart
/// programs are ahead-of-time compiled.
/// Those programs do not have access to *source* files at runtime,
/// and a `package:` URI references a source file.
/// There is no standard way to find a *runtime* location of a source file,
/// or even ensure that it is available.
///
/// The platform specific loading functionality can still be useful.
/// However, without a way to produce such platform specific URIs from
/// platform independent ones, the only URIs which can still
/// be loaded on all platforms are `http:`/`https:` ones.
/// Loading those is *better* supported by the [`http` package][package:http].
///
/// As such, this package can no longer supports its original goal,
/// being a *cross platform* resource loading solution.
/// It will be discontinued rather than provide an inadequate solution.
///
/// [package:http]: https://pub.dartlang.org/packages/http
///
/// ----
///
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
@Deprecated('This package has been discontinued.'
    ' See library documentation of README.md for more infomration')
library resource;

export 'src/resource.dart' show Resource;
export 'src/resource_loader.dart' show ResourceLoader;
