import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _userName = " UserName ";
  String _userPhone = "770000000";
  String _userAddress = "صنعاء - شارع الستين";
  String _userEmail = "username@email.com";

  @override
  Widget build(BuildContext context) {
    const bool isDark = false; 
    const bool isAr = true;

    final bgColor = const Color(0xFFF6F8FB);
    final cardColor = Colors.white;
    final primaryTextColor = const Color(0xFF0D1B3E);
    final secondaryTextColor = Colors.grey[600];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bgColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildModernHeader(isAr, isDark),
              const SizedBox(height: 10),
              _buildStatsBar(cardColor, primaryTextColor, isAr),
              const SizedBox(height: 25),
              _buildMenuSection(cardColor, primaryTextColor, secondaryTextColor, isAr, isDark),
              _buildLogoutButton(isAr),
              const SizedBox(height: 30),
              Text(
                "إصدار التطبيق 1.0.24",
                style: TextStyle(color: secondaryTextColor, fontSize: 11, letterSpacing: 1.2),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // 1. الهيدر (Header)
  Widget _buildModernHeader(bool isAr, bool isDark) {
    return Stack(
      children: [
        Container(
          height: 240,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE79C24), Color(0xFFD18B1E)],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50)),
          ),
        ),
        Positioned(
          top: 50,
          right: 15,
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 22),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(top: 70),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white24,
                child: CircleAvatar(
                  radius: 47,
                  backgroundColor: Color(0xFFF0F2F5),
                  child: Icon(Icons.person, size: 50, color: Color(0xFF0D1B3E)),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _userName, 
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900),
              ),
              Text(
                _userEmail,
                style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 2. شريط الإحصائيات
  Widget _buildStatsBar(Color cardColor, Color textColor, bool isAr) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statItem("الرحلات", "12", Colors.blue, textColor),
          _statItem("النقاط", "120", Colors.orange, textColor),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value, Color color, Color textColor) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: textColor.withOpacity(0.6), fontSize: 11)),
      ],
    );
  }

  // 3. قائمة الخيارات
  Widget _buildMenuSection(Color cardColor, Color textColor, Color? secondaryTextColor, bool isAr, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(25)),
      child: Column(
        children: [
          _menuTile(Icons.person_outline_rounded, "تعديل الحساب", Colors.blue, textColor, () => _goToEditProfile(isAr, isDark)),
          _divider(isDark),
          _menuTile(Icons.lock_outline_rounded, "الأمان والخصوصية", Colors.cyan, textColor, () => _goToPrivacyPage()),
          _divider(isDark),
          _menuTile(Icons.headset_mic_outlined, "الدعم الفني", Colors.teal, textColor, () => _goToSupportPage()),
        ],
      ),
    );
  }

  // دوال التنقل 

  void _goToEditProfile(bool isAr, bool isDark) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          name: _userName,
          phone: _userPhone,
          address: _userAddress,
          isDark: isDark,
          isAr: isAr,
        ),
      ),
    );

    if (result != null && result is Map<String, String>) {
      setState(() {
        _userName = result['name']!;
        _userPhone = result['phone']!;
        _userAddress = result['address']!;
      });
    }
  }

  void _goToPrivacyPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()));
  }

  void _goToSupportPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const SupportScreen()));
  }

  Widget _buildLogoutButton(bool isAr) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('welcome_screen.dart', (route) => false),
          icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
          label: const Text("تسجيل الخروج", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent.withOpacity(0.1),
            elevation: 0, padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
        ),
      ),
    );
  }

  Widget _iconBox(IconData icon, Color color) => Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
    child: Icon(icon, color: color, size: 20),
  );

  Widget _menuTile(IconData icon, String title, Color iconColor, Color textColor, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      leading: _iconBox(icon, iconColor),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: textColor)),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
    );
  }

  Widget _divider(bool isDark) => Divider(height: 1, indent: 70, endIndent: 20, color: Colors.grey[100]);
}

//  1. صفحة تعديل الملف الشخصي 
class EditProfileScreen extends StatefulWidget {
  final String name, phone, address;
  final bool isDark, isAr;
  const EditProfileScreen({super.key, required this.name, required this.phone, required this.address, required this.isDark, required this.isAr});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _addressCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.name);
    _phoneCtrl = TextEditingController(text: widget.phone);
    _addressCtrl = TextEditingController(text: widget.address);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F7FA),
        appBar: AppBar(
          title: const Text("تعديل الحساب", style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF0D1B3E),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildField(Icons.person, "الاسم الكامل", _nameCtrl),
              const SizedBox(height: 20),
              _buildField(Icons.phone, "رقم الهاتف", _phoneCtrl),
              const SizedBox(height: 20),
              _buildField(Icons.location_on, "العنوان", _addressCtrl),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE79C24),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 2,
                  ),
                  onPressed: () {
                    // إرجاع البيانات الجديدة عند الضغط على حفظ
                    Navigator.pop(context, {
                      'name': _nameCtrl.text,
                      'phone': _phoneCtrl.text,
                      'address': _addressCtrl.text
                    });
                  },
                  child: const Text("حفظ التغييرات", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(IconData icon, String label, TextEditingController ctrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey)),
        const SizedBox(height: 8),
        TextField(
          controller: ctrl,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFFE79C24)),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey.shade200)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color(0xFFE79C24))),
          ),
        ),
      ],
    );
  }
}

// 2. صفحة الأمان والخصوصية 
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F7FA),
        appBar: AppBar(
          title: const Text("الأمان والخصوصية"),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF0D1B3E),
          elevation: 0,
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildInfoCard("حماية البيانات", "نحن نستخدم أحدث تقنيات التشفير لضمان أن بياناتك الشخصية وحجوزاتك في أمان تام ولا يتم مشاركتها مع أي طرف ثالث."),
            _buildInfoCard("صلاحيات التطبيق", "يطلب التطبيق الوصول إلى الموقع لتحسين تجربة اختيار المحطات القريبة منك فقط."),
            _buildInfoCard("سياسة التذاكر", "جميع تذاكرك محفوظة في سجلاتنا الإلكترونية لضمان حقك في حال ضياع الهاتف."),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFFE79C24))),
          const SizedBox(height: 8),
          Text(content, style: const TextStyle(color: Colors.black87, height: 1.5)),
        ],
      ),
    );
  }
}

// 3. صفحة الدعم الفني 
class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F7FA),
        appBar: AppBar(
          title: const Text("الدعم الفني"),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF0D1B3E),
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Icon(Icons.headset_mic_rounded, size: 80, color: Color(0xFFE79C24)),
              const SizedBox(height: 20),
              const Text("كيف يمكننا مساعدتك؟", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text("فريق الدعم متاح 24/7 للرد على استفساراتكم", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 30),
              _contactTile(Icons.phone, "اتصل بنا", "800-000-000"),
              _contactTile(Icons.email, "البريد الإلكتروني", "support@darb-app.com"),
              _contactTile(Icons.chat_bubble_outline, "واتساب", "+967 770000000"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _contactTile(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFFE79C24)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      ),
    );
  }
}