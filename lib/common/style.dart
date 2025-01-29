import 'package:flutter/material.dart';

const Color textColor = Color(0xFF1E1E1E);

final commonButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: const Color(0xFF4DB6AC),
  padding: const EdgeInsets.symmetric(horizontal: 16),
  minimumSize: const Size(0, 36),
  maximumSize: const Size(double.infinity, 36),
  textStyle: const TextStyle(
    fontSize: 13,
    color: textColor,
  ),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(4),
  ),
  foregroundColor: textColor,
);

const textFieldStyle = TextStyle(
  color: Color(0xFFD4D4D4),
  fontSize: 13,
);

const textFieldDecor = InputDecoration(
  border: OutlineInputBorder(
    borderSide: BorderSide(
      color: Color(0xFF474747),
      width: 1,
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Color(0xFF2C4C49),
      width: 1,
    ),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Color(0xFF474747),
      width: 1,
    ),
  ),
  hintText: 'Search...',
  hintStyle: TextStyle(
    color: Color(0xFF808080),
    fontSize: 13,
  ),
  filled: true,
  fillColor: Color(0xFF2E2E2E),
  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 11),
  constraints: BoxConstraints(
    maxHeight: 30,
    minHeight: 30,
  ),
);

const menuItemStyle = ButtonStyle(
  foregroundColor: WidgetStatePropertyAll(Color(0xFFD4D4D4)),
  backgroundColor: WidgetStatePropertyAll(Color(0xFF333333)),
  padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 16)),
  minimumSize: WidgetStatePropertyAll(Size.fromHeight(40)),
  maximumSize: WidgetStatePropertyAll(Size.fromHeight(40)),
  textStyle: WidgetStatePropertyAll(
    TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.normal,
    ),
  ),
);

const menuButtonStyle = ButtonStyle(
  foregroundColor: WidgetStatePropertyAll(Color(0xFFD4D4D4)),
  padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 8)),
  minimumSize: WidgetStatePropertyAll(Size(0, 40)),
  textStyle: WidgetStatePropertyAll(
    TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.normal,
    ),
  ),
);

const menuStyle = MenuStyle(
  backgroundColor: WidgetStatePropertyAll(Color(0xFF252526)),
  padding: WidgetStatePropertyAll(EdgeInsets.zero),
  alignment: AlignmentDirectional.topStart,
);
