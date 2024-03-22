library dart.extended;

export 'core.dart';
export 'vm.dart'
  if (dart.library.js_interop) 'web.dart';