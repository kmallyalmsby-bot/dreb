class OrderRequestModel {
  final String orderId;
  final int ticketCount;
  final int totalAmount;
  final String status;

  OrderRequestModel({
    required this.orderId,
    required this.ticketCount,
    required this.totalAmount,
    this.status = "قيد الانتظار",
  });
}