import 'dart:convert';
import 'dart:io';

int parse(String text) {
  while (text.contains('(')) {
    var parenthesisDepth = 0,
        openParenthesis;
    for (var i = 0; i < text.length; i++) {
      var c = String.fromCharCode(text.codeUnitAt(i));
      if (c == ' ') continue;
      if (parenthesisDepth == 0) {
        if (c == '(') {
          parenthesisDepth++;
          openParenthesis = i;
        }
      } else {
        if (c == '(') parenthesisDepth++;
        if (c == ')') parenthesisDepth--;
        if (parenthesisDepth == 0) {
          text = text.replaceRange(openParenthesis, i + 1,
              parse(text.substring(openParenthesis + 1, i)).toString());
          i = openParenthesis - 1;
        }
      }
    }
  }
  while (text.contains('+')) {
    text = text.replaceFirstMapped(RegExp(r'(\d+) \+ (\d+)'), (match) {
      return (int.parse(match.group(1)) + int.parse(match.group(2))).toString();
    });
  }
  while (text.contains('*')) {
    text = text.replaceFirstMapped(RegExp(r'(\d+) \* (\d+)'), (match) {
      return (int.parse(match.group(1)) * int.parse(match.group(2))).toString();
    });
  }
  return int.parse(text);
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
