class HomeDataModel {
  int selectedIndex;
  
  // متغيرات البحث
  String selectedFrom;
  String selectedTo;
  String selectedCompany;
  String selectedTime;
  DateTime selectedDate;

  // البيانات المتاحة في القوائم
  final List<String> governorates = ["صنعاء", "عدن", "تعز", "حضرموت", "إب"];
  final List<String> companiesList = ["كل الشركات", "الرويشان", "الأولى", "راحة"];
  final List<String> times = ["الصباحية", "المسائية"];
  final List<String> logoNames = ["الرويشان", "الأولى", "راحة", "براق"];

  HomeDataModel({
    this.selectedIndex = 2,
    this.selectedFrom = "صنعاء",
    this.selectedTo = "عدن",
    this.selectedCompany = "كل الشركات",
    this.selectedTime = "الصباحية",
    DateTime? selectedDate,
  }) : selectedDate = selectedDate ?? DateTime.now();
}