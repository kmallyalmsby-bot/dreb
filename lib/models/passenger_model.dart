import 'package:flutter/services.dart';

class PassengerModel {
  String name = "";
  String id = "";
  String phone = "";
  bool hasMeal = false;
  bool hasInsurance = false;
}

// كلاس لتنسيق تاريخ انتهاء البطاقة
class CardExpirationFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;
    if (newValue.selection.baseOffset == 0) return newValue;
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      int index = i + 1;
      if (index % 2 == 0 && index != text.length && !text.contains('/')) {
        buffer.write('/');
      }
    }
    final string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}