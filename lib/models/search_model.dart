class Trip {
  final String company;
  final double rating;
  final int reviews;
  final int price;
  final String departureTime;
  final String arrivalTime;
  final int seatsLeft;
  final String fromCity; // المدينة للتأكد من الفلترة
  final String toCity;   // المدينة للتأكد من الفلترة
  final String period;   // الفترة (صباحية/مسائية)

  Trip({
    required this.company,
    required this.rating,
    required this.reviews,
    required this.price,
    required this.departureTime,
    required this.arrivalTime,
    required this.seatsLeft,
    required this.fromCity,
    required this.toCity,
    required this.period,
  });
}