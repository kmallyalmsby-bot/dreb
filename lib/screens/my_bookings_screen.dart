import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:darb_app/models/booking_model.dart';

class MyBookingsScreen extends StatefulWidget {
  final String initialFilter;
  const MyBookingsScreen({super.key, this.initialFilter = "الكل"});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  late String selectedFilter;

  @override
  void initState() {
    super.initState();
    selectedFilter = widget.initialFilter;
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredList = selectedFilter == "الكل"
        ? BookingModel.allBookings
        : BookingModel.allBookings.where((b) => b['status'] == selectedFilter).toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F7FA),
        body: Column(
          children: [
            _buildModernHeader(context),
            _buildHorizontalFilterBar(),
            Expanded(
              child: filteredList.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 30),
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) => _buildBookingTicket(filteredList[index]),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 50, bottom: 25, left: 15, right: 15),
      decoration: const BoxDecoration(
        color: Color(0xFFE79C24),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 22),
                onPressed: () => Navigator.of(context).pop(),
              ),
              const Text("حجوزاتي", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _headerStat("الكل", "${BookingModel.allBookings.length}"),
                _headerStat("مؤكد", "${BookingModel.allBookings.where((e) => e['status'] == "مؤكد").length}"),
                _headerStat("قيد الانتظار", "${BookingModel.allBookings.where((e) => e['status'] == "قيد الانتظار").length}"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 11)),
      ],
    );
  }

  Widget _buildHorizontalFilterBar() {
    return SizedBox(
      height: 65,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        itemCount: BookingModel.statusFilters.length,
        itemBuilder: (context, index) {
          String status = BookingModel.statusFilters[index];
          bool isActive = selectedFilter == status;
          return GestureDetector(
            onTap: () => setState(() => selectedFilter = status),
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFF0D1B3E) : Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: isActive ? Colors.transparent : const Color(0xFFE5E7EB)),
              ),
              child: Center(
                child: Text(status, style: TextStyle(color: isActive ? Colors.white : const Color(0xFF0D1B3E), fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBookingTicket(Map<String, dynamic> trip) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: const Color(0xFF0D1B3E).withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(trip['co'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    _statusChip(trip['status'], trip['color']),
                  ],
                ),
                const Divider(height: 30, color: Color(0xFFF3F4F6)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _locationCol(trip['from'], trip['time']),
                    const Icon(Icons.swap_horiz, color: Color(0xFFCBD5E1), size: 24),
                    _locationCol(trip['to'], trip['date']),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: const BoxDecoration(color: Color(0xFFF9FAFB), borderRadius: BorderRadius.vertical(bottom: Radius.circular(24))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${trip['price']} ريال", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFE79C24))),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => BookingDetailsPage(trip: trip)));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D1B3E),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("عرض التفاصيل "),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
      child: Text(text, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }

  Widget _locationCol(String city, String sub) {
    return Column(
      children: [
        Text(city, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF0D1B3E))),
        Text(sub, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildEmptyState() {
    return const Center(child: Text("لا توجد سجلات حالياً"));
  }
}

class BookingDetailsPage extends StatefulWidget {
  final Map<String, dynamic> trip;
  const BookingDetailsPage({super.key, required this.trip});

  @override
  State<BookingDetailsPage> createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  int _userRating = 0;
  bool _isRated = false;
  File? _newReceipt;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("إدارة الحجز"),
          backgroundColor: const Color(0xFF0D1B3E),
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildTripSummaryCard(),
              const SizedBox(height: 25),
              _buildDynamicStatusView(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTripSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade200)),
      child: Column(
        children: [
          _rowDetail("كود الحجز", widget.trip['id']),
          _rowDetail("الناقل", widget.trip['co']),
          _rowDetail("عدد المقاعد", widget.trip['seats'] ?? "1"),
          _rowDetail("الحالة", widget.trip['status'], isStatus: true),
        ],
      ),
    );
  }

  Widget _buildDynamicStatusView(BuildContext context) {
    switch (widget.trip['status']) {
      case "قيد الانتظار":
        return Column(
          children: [
            _buildInfoBox("طلبك تحت المراجعة من قبل الشركة لمطابقة السند المرفق.", Colors.orange),
            const SizedBox(height: 20),
            _actionButton("تعديل بيانات الحجز", const Color(0xFFE79C24), Icons.edit, () {}),
            const SizedBox(height: 10),
            _actionButton("إلغاء الطلب", Colors.redAccent, Icons.cancel, () {}),
          ],
        );
      case "مؤكد":
        return Column(
          children: [
            const Icon(Icons.qr_code_scanner, size: 180, color: Color(0xFF0D1B3E)),
            const Text("التذكرة الإلكترونية (Electronic Ticket)", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _buildInfoBox("تم تأكيد الدفع. يرجى إبراز الباركود عند الصعود للحافلة.", Colors.green),
          ],
        );
      case "مكتملة":
        return _isRated ? _buildSuccessRatingState() : _buildRatingInputState();
      case "مرفوض":
        return Column(
          children: [
            _buildInfoBox("سبب الرفض: ${widget.trip['reject_reason']}", Colors.red),
            const SizedBox(height: 20),
            if (_newReceipt != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.file(_newReceipt!, height: 150, width: double.infinity, fit: BoxFit.cover),
                ),
              )
            else
              const Text("السند المرفوض سابقاً:", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            if (_newReceipt == null)
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(15),
                  image: const DecorationImage(image: NetworkImage("https://via.placeholder.com/150"), fit: BoxFit.cover),
                ),
              ),
            const SizedBox(height: 20),
            _actionButton(_newReceipt == null ? "رفع سند جديد (Upload Invoice)" : "تغيير السند المختار", const Color(0xFF0D1B3E), Icons.upload_file, _showImagePickerOptions),
            if (_newReceipt != null) ...[
              const SizedBox(height: 10),
              _actionButton("إرسال السند للمراجعة", Colors.green, Icons.send, () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تم إرسال السند الجديد بنجاح")));
              }),
            ]
          ],
        );
      case "ملغية":
        return Column(
          children: [
            _buildInfoBox("هذا الحجز ملغي. تم استرداد المبلغ للمحفظة إن وجد.", Colors.grey),
            const SizedBox(height: 20),
            _actionButton("حجز رحلة جديدة", const Color(0xFFE79C24), Icons.directions_bus, () {}),
          ],
        );
      default:
        return const SizedBox();
    }
  }

  Widget _buildRatingInputState() {
    return Column(
      children: [
        const Text("كيف كانت تجربتك في هذه الرحلة؟", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return IconButton(
              icon: Icon(index < _userRating ? Icons.star : Icons.star_border, color: Colors.amber, size: 45),
              onPressed: () => setState(() => _userRating = index + 1),
            );
          }),
        ),
        const SizedBox(height: 25),
        _actionButton("إرسال التقييم (Send Evaluation)", const Color(0xFF0D1B3E), Icons.rate_review, () {
          if (_userRating > 0) {
            setState(() => _isRated = true);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("يرجى اختيار عدد النجوم أولاً")));
          }
        }),
      ],
    );
  }

  Widget _buildSuccessRatingState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.green.withOpacity(0.05), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.green.withOpacity(0.3))),
      child: Column(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 70),
          const SizedBox(height: 15),
          const Text("شكراً لتقييمك!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.green)),
          const SizedBox(height: 10),
          const Text("تم استلام تقييمك بنجاح، ملاحظاتك تساعدنا في تحسين الخدمة.", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 20),
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("العودة لحجوزاتي", style: TextStyle(fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("اختر مصدر السند", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _sourceOption(Icons.camera_alt, "الكاميرا", ImageSource.camera),
                  _sourceOption(Icons.photo_library, "المعرض", ImageSource.gallery),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sourceOption(IconData icon, String label, ImageSource source) {
    return InkWell(
      onTap: () async {
        Navigator.pop(context);
        final picker = ImagePicker();
        final picked = await picker.pickImage(source: source);
        if (picked != null) setState(() => _newReceipt = File(picked.path));
      },
      child: Column(
        children: [
          CircleAvatar(radius: 30, backgroundColor: const Color(0xFFF4F7FA), child: Icon(icon, color: const Color(0xFFE79C24))),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildInfoBox(String text, Color color) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: color)),
      child: Text(text, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 13), textAlign: TextAlign.center),
    );
  }

  Widget _rowDetail(String label, String value, {bool isStatus = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: isStatus ? widget.trip['color'] : const Color(0xFF0D1B3E))),
        ],
      ),
    );
  }

  Widget _actionButton(String label, Color color, IconData icon, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(backgroundColor: color, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
      ),
    );
  }
}