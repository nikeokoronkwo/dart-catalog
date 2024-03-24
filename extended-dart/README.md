# Extended Dart: Make your dart easier

This package pulls together best practices, useful functions, extensions, variables and other features into a single package you can use to streamline working with Dart without having to reimplement functionality.

With this package, you can work on your web or vm projects with ease without having to stress on features not directly relating to your project. 

## Note

Like the package name says, this package is like Dart with more standard features. This isn't a separate language or a superset of Dart. This is just a collection of useful functionality that can be used in your project.

## Using this Package
```dart
import 'package:extended_dart/core.dart';

void main(List<String> args) {
  // Here are some instances with lists

  // Get the number of occurences of an item in a list
  var myList = [9, 6, 5, 2, 6, 10];
  print(myList.count(6));
}
```

There are three libraries included in this package: **core** (`package:extended_dart/core.dart`), **vm** (`package:extended_dart/vm.dart`) and **web** (`package:extended_dart/web.dart`).
The `core` library can be used on either platform, while `web` and `vm` are platform-specific, being used on the web (dart2js) and virtual machine platforms respectively.

## Contributions

This package is still in early stages and we would love to get feedback from you!

Contributions are welcome! Please check the guidelines to see how you can contribute.