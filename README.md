# Resource

----
**NOTICE** This package is **discontinued**.
It will not be maintained or upgraded in the future.

This package combines two functionalities:
* Converting a `package:` URI to a platform specific URI
  (usually `http:` or `file:`, depending on the platform)
* Load the contents of such platform specific URIs.

The former no longer makes sense when a large number of Dart
programs are ahead-of-time compiled.
Those programs do not have access to *source* files at runtime,
and a `package:` URI references a source file.
There is no standard way to find a *runtime* location of a source file,
or even ensure that it is available.

The platform specific loading functionality can still be useful.
However, without a way to produce such platform specific URIs from
platform independent ones, the only URIs which can still
be loaded on all platforms are `http:`/`https:` ones.
Loading those is *better* supported by the [`http` package][package:http].

As such, this package can no longer supports its original goal,
being a *cross platform* resource loading solution.
It will be discontinued rather than provide an inadequate solution.

----

Reading data from package contents and files.

A resource is data that can be read into a Dart program at runtime.
A resource is identified by a URI. It can be loaded as bytes or data.
The resource URI may be a package: URI.

Example:

```dart
import 'package:resource/resource.dart' show Resource;
import 'dart:convert' show utf8;

main() async {
  var resource = new Resource("package:foo/foo_data.txt");
  var string = await resource.readAsString(encoding: utf8);
  print(string);
}
```

## Learning more

Please check out the [API docs](https://www.dartdocs.org/documentation/resource/latest).

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/dart-lang/resource/issues
[package:http]: https://pub.dartlang.org/packages/http
