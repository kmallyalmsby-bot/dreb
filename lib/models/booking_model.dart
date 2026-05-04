import 'package:flutter/material.dart';

class BookingModel {
  static const List<String> statusFilters = ["الكل", "مؤكد", "قيد الانتظار", "مكتملة", "مرفوض", "ملغية"];

  static final List<Map<String, dynamic>> allBookings = [
    {
      "id": "BK-902",
      "co": "شركة الأولى للنقل",
      "from": "صنعاء", "to": "عدن",
      "status": "مؤكد",
      "color": Colors.green,
      "date": "28 إبريل 2026",
      "price": "25,000",
      "time": "08:00 ص",
      "seats": "2"
    },
    {
      "id": "BK-441",
      "co": "شركة الرويشان",
      "from": "تعز", "to": "صنعاء",
      "status": "قيد الانتظار",
      "color": Colors.orange,
      "date": "30 إبريل 2026",
      "price": "18,000",
      "time": "10:30 م",
      "seats": "1"
    },
    {
      "id": "BK-772",
      "co": "شركة البركة",
      "from": "صنعاء", "to": "حضرموت",
      "status": "مكتملة",
      "color": Colors.blue,
      "date": "20 إبريل 2026",
      "price": "30,000",
      "time": "06:00 ص",
      "seats": "3"
    },
    {
      "id": "BK-110",
      "co": "شركة الراحة",
      "from": "عدن", "to": "تعز",
      "status": "مرفوض",
      "color": Colors.red,
      "date": "25 إبريل 2026",
      "price": "15,000",
      "reject_reason": "صورة السند غير واضحة، يرجى إعادة الإرسال.",
      "time": "09:00 ص",
      "seats": "1"
    },
    {
      "id": "BK-003",
      "co": "شركة السعيد",
      "from": "إب", "to": "صنعاء",
      "status": "ملغية",
      "color": Colors.grey,
      "date": "22 إبريل 2026",
      "price": "12,000",
      "time": "04:00 م",
      "seats": "1"
    },
  ];
}