import 'dart:convert';
import 'dart:io';

int parse(String text) {
  var total = 0;
  var parenthesisDepth = 0, openParenthesis;
  var lastOp = '+';
  for (var i = 0; i < text.length; i++) {
    var c = String.fromCharCode(text.codeUnitAt(i));
    if (c == ' ') continue;
    if (parenthesisDepth == 0) {
      if (c == '+' || c == '*') {
        lastOp = c;
      } else if (c == '(') {
        parenthesisDepth++;
        openParenthesis = i;
      } else {
        if (lastOp == '+') {
          total += int.parse(c);
        } else if (lastOp == '*') {
          total *= int.parse(c);
        }
      }
    } else {
      if (c == '(') parenthesisDepth++;
      if (c == ')') parenthesisDepth--;
      if (parenthesisDepth == 0) {
        if (lastOp == '+') {
          total += parse(text.substring(openParenthesis+1, i));
        } else if (lastOp == '*') {
          total *= parse(text.substring(openParenthesis+1, i));
        }
      }
    }
  }
  return total;
}

void main(List<String> arguments) {
  File('input.txt')
      .openRead()
      .transform(utf8.decoder)
      .transform(LineSplitter())
      .map((line) => parse(line))
      .reduce((previous, element) => element + previous)
      .then((value) => print(value));
}
