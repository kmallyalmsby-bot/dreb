enum NotiType { 
  booking,        
  payment,        
  adminAlert,     
  bookingUpdate,  
  bookingCancel,  
  requestAccepted 
}

class NotificationModel {
  String id;
  String title;
  String body;
  DateTime timestamp;
  NotiType type;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    required this.type,
    this.isRead = false,
  });
  
  static List<NotificationModel> dummyNotifications = [
    NotificationModel(
      id: "1",
      title: "تم تأكيد حجزك بنجاح",
      body: "رحلتك رقم #7821 من صنعاء إلى عدن مؤكدة. نتمنى لك رحلة سعيدة.",
      timestamp: DateTime.now(),
      type: NotiType.booking,
    ),
    NotificationModel(
      id: "2",
      title: "تحديث أمني للنظام",
      body: "يرجى العلم بأنه سيتم إجراء صيانة دورية للخوادم يوم الجمعة القادم من الساعة 2 صباحاً.",
      timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
      type: NotiType.adminAlert,
    ),
    NotificationModel(
      id: "3",
      title: "الموافقة على طلب التعديل",
      body: "تمت الموافقة على تعديل حجزك. يمكنك الآن عرض التذكرة بالموعد الجديد.",
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      type: NotiType.requestAccepted,
    ),
    NotificationModel(
      id: "4",
      title: "إيصال الدفع تحت المراجعة",
      body: "شكراً لك، تم استلام صورة الإيصال. سيتم إشعارك فور تفعيل التذكرة.",
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      type: NotiType.payment,
    ),
    NotificationModel(
      id: "5",
      title: "تنبيه إداري",
      body: "تم تحديث سياسة الأمتعة المسموح بها في الرحلات الدولية، يرجى مراجعة الشروط.",
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      type: NotiType.adminAlert,
    ),
    NotificationModel(
      id: "6",
      title: "طلب تعديل على الحجز",
      body: "تم استلام طلبك لتغيير موعد الرحلة #7821. الطلب قيد المراجعة حالياً.",
      timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      type: NotiType.bookingUpdate,
    ),
  ];

  static List<NotificationModel> getFiltered(List<NotificationModel> list, String filter) {
    if (filter == "الكل") return list;
    if (filter == "حجوزات") {
      return list.where((n) => 
        n.type == NotiType.booking || 
        n.type == NotiType.bookingUpdate || 
        n.type == NotiType.bookingCancel || 
        n.type == NotiType.requestAccepted
      ).toList();
    }
    if (filter == "المدفوعات") return list.where((n) => n.type == NotiType.payment).toList();
    if (filter == "تنبيهات إدارية") return list.where((n) => n.type == NotiType.adminAlert).toList();
    return list;
  }
}