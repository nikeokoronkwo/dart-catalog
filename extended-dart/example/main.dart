import 'package:extended_dart/core.dart';

void main(List<String> args) {
  // Here are some instances with lists

  var myList = [9, 6, 5, 2, 6, 10];
  // Number of even numbers in the list
  print(myList.countIf((element) => element % 2 == 0));

  var secondList = [null, 4, 5, 1, null, 5, 8, null];
  // Number of null values in the list
  print(secondList.countNull());
}
