import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:darb_app/models/otp_model.dart';  

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  ForgotPasswordModel model = ForgotPasswordModel();

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
              
              const SizedBox(height: 60),
              
              // العنوان الرئيسي
              const Text(
                "نسيت كلمة المرور ؟",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0D1B3E),
                ),
              ),
              const SizedBox(height: 40),

              // نص رمز التحقق
              const Text(
                "رمز التحقق",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 15),

              // وصف إرسال الرمز (يأخذ البيانات من المودل)
              Text(
                "أدخل الرمز المكون من 4 أرقام المرسل إلى ${model.phoneNumber}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 50),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _otpBox(first: true, last: false),
                  const SizedBox(width: 15),
                  _otpBox(first: false, last: false),
                  const SizedBox(width: 15),
                  _otpBox(first: false, last: false),
                  const SizedBox(width: 15),
                  _otpBox(first: false, last: true),
                ],
              ),

              const SizedBox(height: 60),

              // قسم إعادة إرسال الرمز
              const Text(
                "لم يصلك الرمز ؟",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  // منطق إعادة إرسال الرمز
                },
                child: const Text(
                  "إعادة إرسال الرمز",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE79C24),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _otpBox({required bool first, required bool last}) {
    return Container(
      height: 65,
      width: 60,
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: TextField(
        autofocus: first, 
        showCursor: true, 
        cursorColor: const Color(0xFFE79C24), 
        readOnly: false, 
        enabled: true, 
        onChanged: (value) {
          if (value.length == 1 && last == false) {
            FocusScope.of(context).nextFocus();
          }
          if (value.isEmpty && first == false) {
            FocusScope.of(context).previousFocus();
          }
        },
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 22, 
          fontWeight: FontWeight.bold,
          color: Color(0xFF0D1B3E),
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "-",
          hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 20),
          contentPadding: EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }

  Widget _buildCircleBackButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Color(0xFFE79C24),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.arrow_forward, color: Colors.white, size: 22),
      ),
    );
  }
}