# Resource

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
