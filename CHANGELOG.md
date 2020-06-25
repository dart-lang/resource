## 2.1.7
- **This package is discontinued**.
  The package is not going to be maintained or upgraded in the future.
  See the `README.md` for more information.

## 2.1.6
- Cast stream to `List<int>` in 'readAsString', this is in preparation for
  `HttpClientResponse` implementing `Stream<Uint8List>` (forward compatible
  change, should be a no-op for existing usages)

## 2.1.5
- Require at least Dart 2.0.0-dev.61.

## 2.1.4
- Require at least Dart 2.0.0.

## 2.1.3
- Fix bug in `readAsBytes` which returned twice as much data as expected.

## 2.1.2
- Fix bug in `readAsString` when charset is LATIN-1 and content-length is set.

## 2.1.1
- Reduce max concurrent connections to the same host to 6 when using `dart:io`.
  That's the same limit that many browsers use.
- Trying to load a resource from a non-existing package now gives a better
  error message.

## 2.1.0
- Make failing HTTP requests throw an `HttpException`.

## 2.0.2
- Update README.md.

## 2.0.1
- Fix type warnings.

## 2.0.0
- Use configuration dependent imports to avoid having separate implementations
  for `dart:io` and `dart:html`.
- Remove `browser_resource.dart`.

## 1.1.0

- Added browser-compatible version as `browser_resource.dart` library.
  Only needed because configurable imports are not available yet.

## 1.0.0

- Initial version
