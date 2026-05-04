import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import '../models/passenger_model.dart';
import '../models/order_request_model.dart';
import 'request_received_screen.dart';
class ReservationScreen extends StatefulWidget {
  final int ticketCount;
  final int unitPrice;
  final String route;
  final String companyName;
  final String departureTime;

  const ReservationScreen({
    super.key,
    required this.ticketCount,
    required this.unitPrice,
    required this.route,
    this.companyName = "شركة النقل البري",
    this.departureTime = "08:00 PM",
  });

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  final _formKey = GlobalKey<FormState>();
  late List<PassengerModel> passengers;
  File? _receiptImage;
  String? _paymentMethod;

  final Color primaryColor = const Color(0xFFE79C24);
  final Color darkBlue = const Color(0xFF0D1B3E);
  final Color bgColor = const Color(0xFFF4F7FA);

  @override
  void initState() {
    super.initState();
    passengers = List.generate(widget.ticketCount, (index) => PassengerModel());
  }

  int _calculateTotal() {
    int base = widget.unitPrice * widget.ticketCount;
    int extras = 0;
    for (var p in passengers) {
      if (p.hasMeal) extras += 2000;
      if (p.hasInsurance) extras += 1000;
    }
    return base + extras;
  }

  Future<void> _showImageSourceOptions() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "إرفاق صورة السند من:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0D1B3E)),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSourceItem(
                    icon: Icons.camera_alt_rounded,
                    label: "الكاميرا",
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.camera);
                    },
                  ),
                  _buildSourceItem(
                    icon: Icons.photo_library_rounded,
                    label: "المعرض",
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.gallery);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source);
    if (picked != null) {
      setState(() => _receiptImage = File(picked.path));
    }
  }

  Widget _buildSourceItem({required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(icon, color: primaryColor, size: 32),
          ),
          const SizedBox(height: 10),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0D1B3E))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bgColor,
        body: Column(
          children: [
            _buildRichHeader(),
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    const SizedBox(height: 25),
                    _buildSectionTitle("بيانات المسافرين والخدمات"),
                    ...List.generate(widget.ticketCount, (index) => _buildCollapsiblePassengerCard(index)),
                    const SizedBox(height: 25),
                    _buildSectionTitle("طريقة الدفع"),
                    _buildPaymentMethodSelector(),
                    if (_paymentMethod == "سند") _buildBankTransferSection(),
                    if (_paymentMethod == "بطاقة") _buildCreditCardSection(),
                    const SizedBox(height: 150),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomSheet: _buildStickyFooter(),
      ),
    );
  }

  Widget _buildRichHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 50, 15, 25),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(35)),
        boxShadow: [BoxShadow(color: primaryColor.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20)),
              const Spacer(),
              const Text("تأكيد حجز الرحلة", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const Spacer(),
              const SizedBox(width: 40),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: [
                const Icon(Icons.directions_bus_rounded, color: Colors.white, size: 30),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.route, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(height: 4),
                      Text("${widget.companyName} • ${widget.departureTime}", style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: darkBlue, borderRadius: BorderRadius.circular(10)),
                  child: Text("${widget.ticketCount} ركاب", style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollapsiblePassengerCard(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)]),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: index == 0,
          leading: Icon(Icons.person_pin_rounded, color: darkBlue),
          title: Text("بيانات المسافر ${index + 1}", style: TextStyle(color: darkBlue, fontWeight: FontWeight.bold)),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          children: [
            const Divider(),
            _buildField("الاسم الرباعي", Icons.edit, (v) => passengers[index].name = v!),
            const SizedBox(height: 12),
            _buildField("رقم الهوية", Icons.badge_outlined, (v) => passengers[index].id = v!),
            const SizedBox(height: 12),
            _buildField("رقم الجوال", Icons.phone_android, (v) => passengers[index].phone = v!, isNumber: true),
            const SizedBox(height: 15),
            _buildServiceBox(" انترنت (+2,000 ر.ي)", Icons.restaurant, passengers[index].hasMeal, (v) => setState(() => passengers[index].hasMeal = v)),
            const SizedBox(height: 8),
            _buildServiceBox(" تكييف (+1,000 ر.ي)", Icons.security, passengers[index].hasInsurance, (v) => setState(() => passengers[index].hasInsurance = v)),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodSelector() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          RadioListTile<String>(
            title: const Text("تحويل بنكي", style: TextStyle(fontSize: 14)),
            value: "سند", groupValue: _paymentMethod, activeColor: primaryColor,
            onChanged: (v) => setState(() => _paymentMethod = v),
          ),
          RadioListTile<String>(
            title: const Text("بطاقة ائتمانية", style: TextStyle(fontSize: 14)),
            value: "بطاقة", groupValue: _paymentMethod, activeColor: primaryColor,
            onChanged: (v) => setState(() => _paymentMethod = v),
          ),
        ],
      ),
    );
  }

  Widget _buildBankTransferSection() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
      child: Column(
        children: [
          _buildAccountRow("بنك الكريمي", "123456789"),
          const SizedBox(height: 20),
          if (_receiptImage != null)
            Stack(
              alignment: Alignment.topLeft,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.file(_receiptImage!, height: 120, width: double.infinity, fit: BoxFit.cover),
                ),
                IconButton(
                  onPressed: () => setState(() => _receiptImage = null),
                  icon: const Icon(Icons.cancel, color: Colors.red),
                ),
              ],
            ),
          const SizedBox(height: 10),
          TextButton.icon(
            onPressed: _showImageSourceOptions,
            icon: Icon(Icons.add_a_photo_rounded, color: darkBlue),
            label: Text(_receiptImage == null ? "إرفاق صورة السند" : "تغيير الصورة", style: TextStyle(color: darkBlue, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Widget _buildCreditCardSection() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
      child: Column(
        children: [
          _buildField("رقم البطاقة (16 رقم)", Icons.credit_card, (v) {}, isNumber: true),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                    CardExpirationFormatter(),
                  ],
                  decoration: _inputDecoration("التاريخ MM/YY", Icons.calendar_month),
                  validator: (v) => v!.isEmpty ? "مطلوب" : null,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(child: _buildField("CVV", Icons.lock, (v) {}, isNumber: true)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStickyFooter() {
    return Container(
      padding: const EdgeInsets.fromLTRB(25, 15, 25, 35),
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("المجموع", style: TextStyle(color: Colors.grey, fontSize: 11)),
              Text("${_calculateTotal()} ر.ي", style: TextStyle(color: darkBlue, fontSize: 24, fontWeight: FontWeight.w900)),
            ],
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                if (_paymentMethod == null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("يرجى اختيار طريقة الدفع")));
                  return;
                }
                if (_paymentMethod == "سند" && _receiptImage == null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("يرجى إرفاق صورة السند")));
                  return;
                }
                showDialog(context: context, builder: (context) => Center(child: CircularProgressIndicator(color: primaryColor)));
                await Future.delayed(const Duration(seconds: 1));
                if (!mounted) return;
                Navigator.pop(context);

Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => RequestReceivedScreen(
      orderData: OrderRequestModel(
        orderId: "BR-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}",
        ticketCount: widget.ticketCount,
        totalAmount: _calculateTotal(),
      ),
    ),
  ),
);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            ),
            child: const Text("تأكيد الحجز", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          )
        ],
      ),
    );
  }

  Widget _buildField(String hint, IconData icon, Function(String?) onSaved, {bool isNumber = false}) {
    return TextFormField(
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: _inputDecoration(hint, icon),
      validator: (v) => v!.isEmpty ? "مطلوب *" : null,
      onSaved: onSaved,
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) => InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: darkBlue),
        filled: true,
        fillColor: bgColor,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      );

  Widget _buildServiceBox(String t, IconData i, bool v, Function(bool) c) => Container(
        margin: const EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(15)),
        child: SwitchListTile(secondary: Icon(i, color: v ? primaryColor : darkBlue), title: Text(t, style: const TextStyle(fontSize: 12)), value: v, onChanged: c, activeColor: primaryColor),
      );

  Widget _buildAccountRow(String b, String n) => ListTile(title: Text(b), subtitle: Text(n), trailing: Icon(Icons.copy, size: 18, color: darkBlue), contentPadding: EdgeInsets.zero);
  Widget _buildSectionTitle(String t) => Padding(padding: const EdgeInsets.only(bottom: 12), child: Text(t, style: TextStyle(fontWeight: FontWeight.bold, color: darkBlue)));
}