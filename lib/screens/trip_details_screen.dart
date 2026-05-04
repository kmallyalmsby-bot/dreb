import 'package:flutter/material.dart';
import 'reservation_screen.dart'; 

class TripDetailsScreen extends StatefulWidget {
  final dynamic trip;
  final String companyName;
  final double rating;

  const TripDetailsScreen({
    super.key,
    required this.trip,
    required this.companyName,
    required this.rating,
  });

  @override
  State<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  int ticketCount = 1;

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFE79C24);
    const darkBlue = Color(0xFF0D1B3E);
    
    // محاولة قراءة السعر 
    int unitPrice = 0;
    try {
      unitPrice = int.parse(widget.trip.price.toString().replaceAll(',', ''));
    } catch (e) {
      unitPrice = 0; // قيمة افتراضية في حال فشل القراءة
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F7FA),
        bottomNavigationBar: _buildStickyFooter(unitPrice, primaryColor, darkBlue),
        body: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  _buildSliverHeader(primaryColor, darkBlue),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle("مخطط الرحلة"),
                          _buildAdvancedTimeline(primaryColor),
                          const SizedBox(height: 16),
                          
                          // سياسات الحجز
                          _buildSectionTitle("سياسات الحجز والإلغاء"),
                          _buildBookingPolicies(primaryColor),
                          const SizedBox(height: 16),
                          
                          _buildSectionTitle("سياسة الأمتعة"),
                          _buildBaggageInfo(),
                          const SizedBox(height: 16),
                          _buildSectionTitle("مواصفات الحافلة"),
                          _buildBusEssentials(),
                          const SizedBox(height: 16),
                          _buildSectionTitle("تحديد الركاب"),
                          _buildQuantitySelector(primaryColor),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ودجت سياسات الحجز
  Widget _buildBookingPolicies(Color primary) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primary.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          _policyRow(Icons.history_toggle_off, "التعديل والإلغاء:", "مسموح قبل موعد الرحلة بـ 6 ساعات."),
          const SizedBox(height: 10),
          _policyRow(Icons.timer_outlined, "وقت الحضور:", "يجب التواجد في المحطة قبل الإقلاع بـ 30 دقيقة."),
          const SizedBox(height: 10),
          _policyRow(Icons.business_center_outlined, "نقطة الوصول:", "يتم الإنزال في فرع الشركة الرئيسي بالمدينة المستهدفة."),
          const SizedBox(height: 10),
          _policyRow(Icons.assignment_turned_in_outlined, "تأكيد الحجز:", "يعتبر الحجز مؤكداً فقط بعد إتمام عملية الدفع وإرفاق السند."),
        ],
      ),
    );
  }

  Widget _policyRow(IconData icon, String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: const Color(0xFFE79C24)),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 12, color: Colors.black87),
              children: [
                TextSpan(text: "$title ", style: const TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: desc),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSliverHeader(Color primary, Color dark) {
    return SliverAppBar(
      expandedHeight: 140,
      pinned: true,
      elevation: 0,
      backgroundColor: dark,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [dark, primary.withOpacity(0.9)]),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Text("${widget.trip.from ?? ''} ⟵ ${widget.trip.to ?? ''}", 
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              Text(widget.companyName, style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdvancedTimeline(Color primary) {
    String depTime = "08:00 ص";
    String arrTime = "04:00 م";

    try {
      depTime = widget.trip.time ?? "08:00 ص"; 
    } catch (e) {
      depTime = "08:00 ص";
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          _buildTimelineItem(depTime, widget.trip.from ?? "نقطة الانطلاق", "انطلاق من المحطة", true, primary),
          _buildTimelineItem(arrTime, widget.trip.to ?? "نقطة الوصول", "وصول لفرع الشركة", false, Colors.green),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(String time, String loc, String sub, bool showLine, Color color) {
    return Row(
      children: [
        Column(
          children: [
            Icon(Icons.radio_button_checked, color: color, size: 16),
            if (showLine) Container(width: 2, height: 30, color: Colors.grey[200]),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(loc, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  Text(sub, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                ],
              ),
              Text(time, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBaggageInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _IconText(Icons.luggage, "شحن 25kg"),
          _IconText(Icons.shopping_bag, "يدوية 7kg"),
        ],
      ),
    );
  }

  Widget _buildBusEssentials() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(Icons.ac_unit, size: 20, color: Color(0xFF0D1B3E)),
          Icon(Icons.wifi, size: 20, color: Color(0xFF0D1B3E)),
          Icon(Icons.bolt, size: 20, color: Color(0xFF0D1B3E)),
          Icon(Icons.airline_seat_recline_normal, size: 20, color: Color(0xFF0D1B3E)),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector(Color primary) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          const Text("عدد الركاب", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const Spacer(),
          IconButton(onPressed: () => setState(() => ticketCount > 1 ? ticketCount-- : null), icon: const Icon(Icons.remove_circle_outline, size: 20)),
          Text("$ticketCount", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          IconButton(onPressed: () => setState(() => ticketCount++), icon: Icon(Icons.add_circle, color: primary, size: 20)),
        ],
      ),
    );
  }

  Widget _buildStickyFooter(int unitPrice, Color primary, Color dark) {
    return Container(
      height: 90, 
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("المبلغ الإجمالي", style: TextStyle(color: Colors.grey, fontSize: 11)),
              Text("${unitPrice * ticketCount} ر.ي", style: TextStyle(color: dark, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReservationScreen(
                      ticketCount: ticketCount,
                      unitPrice: unitPrice,
                      route: "${widget.trip.from ?? ''} ⟵ ${widget.trip.to ?? ''}",
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("استمرار", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0D1B3E))),
  );
}

class _IconText extends StatelessWidget {
  final IconData icon;
  final String text;
  const _IconText(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFFE79C24)),
        const SizedBox(width: 5),
        Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }
}