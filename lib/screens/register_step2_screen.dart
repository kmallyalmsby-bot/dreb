import 'package:flutter/material.dart';
import '../models/register_step2_model.dart';
import 'home_screen.dart';

class RegisterStep2Screen extends StatefulWidget {
  const RegisterStep2Screen({super.key});

  @override
  State<RegisterStep2Screen> createState() => _RegisterStep2ScreenState();
}

class _RegisterStep2ScreenState extends State<RegisterStep2Screen> {
  final RegisterStep2Model _model = RegisterStep2Model();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              
              const Text(
                "إكمال البيانات",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0D1B3E),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStepIndicator(width: 35, color: const Color(0xFFE79C24)),
                  const SizedBox(width: 8),
                  _buildStepIndicator(width: 15, color: const Color(0xFFE5E7EB)),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                "الخطوة 2 من 2",
                style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 13),
              ),
              
              const SizedBox(height: 40),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildLabel("الاسم الكامل"),
                  _buildTextField(
                    hint: "مثال: UserName ",
                    controller: _nameController,
                    onChanged: (val) => _model.fullName = val,
                  ),
                  const SizedBox(height: 20),
                  _buildLabel("تاريخ الميلاد"),
                  _buildTextField(
                    hint: "يوم / شهر / سنة",
                    controller: _dateController,
                    onChanged: (val) => _model.birthDate = val,
                  ),
                  const SizedBox(height: 20),
                  _buildLabel("العنوان"),
                  _buildTextField(
                    hint: "المدينة، الحي",
                    controller: _addressController,
                    onChanged: (val) => _model.address = val,
                  ),
                  const SizedBox(height: 20),
                  _buildLabel("رقم الهاتف"),
                  _buildTextField(
                    hint: "05X XXX XXXX",
                    controller: _phoneController,
                    onChanged: (val) => _model.phoneNumber = val,
                  ),
                ],
              ),

              const SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildMainButton("تسجيل الحساب", () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                      );
                    }),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    flex: 1,
                    child: _buildSecondaryButton("السابق", () {
                      Navigator.pop(context);
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator({required double width, required Color color}) {
    return Container(
      width: width,
      height: 6,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF374151))),
    );
  }

  Widget _buildTextField({
    required String hint, 
    TextEditingController? controller,
    Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
        hintStyle: const TextStyle(color: Color(0xFFD1D5DB), fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFFF3F4F6)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFFE79C24)),
        ),
      ),
    );
  }

  Widget _buildMainButton(String text, VoidCallback onTap) {
    return Container(
      height: 58,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE79C24).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE79C24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 0,
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton(String text, VoidCallback onTap) {
    return SizedBox(
      height: 58,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE5E7EB),
          foregroundColor: const Color(0xFF374151),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 0,
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}