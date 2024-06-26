import 'dart:js_interop';

extension type Response._(JSObject _) implements JSObject {
  external Response();
  external JSArrayBuffer arrayBuffer();
}

@JS('fetch')
external JSPromise<Response> fetch(String url);
