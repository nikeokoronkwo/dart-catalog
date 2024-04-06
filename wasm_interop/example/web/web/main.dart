import 'dart:js_interop';

import 'package:web/web.dart';
import 'package:wai/wai.dart';

void main() {
  final now = DateTime.now();
  final element = document.querySelector('#output') as HTMLDivElement;
  element.text = 'The time is ${now.hour}:${now.minute}'
      ' and your Dart web app is running!';
  WebAssembly.compileStreaming(fetch('wasm/main.wasm')).then((value) async {
    return await WebAssembly.instantiate(value);
  }).then((instance) {
    print((instance as WebAssemblyInstance).exports['sumofsquares'](9));
  });
}
