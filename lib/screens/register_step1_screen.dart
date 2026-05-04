import 'package:flutter/material.dart';
import '../models/register_model.dart'; 
import 'register_step2_screen.dart';

class RegisterStep1Screen extends StatefulWidget {
  const RegisterStep1Screen({super.key});

  @override
  State<RegisterStep1Screen> createState() => _RegisterStep1ScreenState();
}

class _RegisterStep1ScreenState extends State<RegisterStep1Screen> {
  final RegisterStep1Model _model = RegisterStep1Model();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
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
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.topRight,
                child: _buildCircleBackButton(context),
              ),
              const SizedBox(height: 20),
              const Text(
                "إنشاء حساب جديد",
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
                  _buildStepIndicator(width: 15, color: const Color(0xFFE5E7EB)),
                  const SizedBox(width: 8),
                  _buildStepIndicator(width: 35, color: const Color(0xFFE79C24)),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                "الخطوة 1 من 2",
                style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 13),
              ),
              const SizedBox(height: 40),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildLabel("البريد الإلكتروني"),
                  _buildTextField(
                    hint: "example@gmail.com",
                    controller: _emailController,
                    onChanged: (val) => _model.email = val,
                  ),
                  const SizedBox(height: 20),
                  _buildLabel("كلمة المرور"),
                  _buildTextField(
                    hint: "كلمة المرور",
                    isPassword: true,
                    controller: _passwordController,
                    onChanged: (val) => _model.password = val,
                  ),
                  const SizedBox(height: 20),
                  _buildLabel("تأكيد كلمة المرور"),
                  _buildTextField(
                    hint: "تأكيد كلمة المرور",
                    isPassword: true,
                    controller: _confirmController,
                    onChanged: (val) => _model.confirmPassword = val,
                  ),
                ],
              ),
              const SizedBox(height: 40),
              _buildMainButton("التالي", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterStep2Screen()),
                );
              }),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      "تسجيل الدخول",
                      style: TextStyle(color: Color(0xFFE79C24), fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Text(" لديك حساب؟ ", style: TextStyle(color: Color(0xFF6B7280))),
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
    bool isPassword = false,
    TextEditingController? controller,
    Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      obscureText: isPassword,
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
        hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
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
      width: double.infinity,
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
          style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildCircleBackButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(color: Color(0xFFE79C24), shape: BoxShape.circle),
        child: const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
      ),
    );
  }
}