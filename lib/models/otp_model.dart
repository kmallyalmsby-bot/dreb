class ForgotPasswordModel {
  final String phoneNumber;
  final String otpCode;
  final bool isLoading;

  ForgotPasswordModel({
    this.phoneNumber = "966+ 5X XXX XXXX",
    this.otpCode = "",
    this.isLoading = false,
  });

  ForgotPasswordModel copyWith({
    String? phoneNumber,
    String? otpCode,
    bool? isLoading,
  }) {
    return ForgotPasswordModel(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      otpCode: otpCode ?? this.otpCode,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}