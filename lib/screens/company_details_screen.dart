import 'package:flutter/material.dart';
 import 'trip_details_screen.dart'; 

class CompanyTrip {
  final String from;
  final String to;
  final String time;
  final String price;
  final int remainingSeats;

  CompanyTrip({
    required this.from,
    required this.to,
    required this.time,
    required this.price,
    required this.remainingSeats,
  });
}

class CompanyDetailsScreen extends StatelessWidget {
  final String companyName;
  final double rating;

  const CompanyDetailsScreen({
    super.key,
    required this.companyName,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFE79C24);
    const darkBlue = Color(0xFF0D1B3E);

    List<CompanyTrip> companyTrips = [
      CompanyTrip(from: "صنعاء", to: "عدن", time: "08:00 ص", price: "25,000", remainingSeats: 5),
      CompanyTrip(from: "صنعاء", to: "تعز", time: "09:30 ص", price: "15,000", remainingSeats: 12),
      CompanyTrip(from: "إب", to: "صنعاء", time: "02:00 م", price: "12,000", remainingSeats: 8),
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F7FA),
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildSliverHeader(context, primaryColor, darkBlue),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _buildMainInfo(darkBlue),
                    const SizedBox(height: 30),
                    _buildSectionTitle("الخدمات والمميزات"),
                    _buildModernAmenities(primaryColor, darkBlue),
                    const SizedBox(height: 30),
                    _buildSectionTitle("الرحلات القادمة"),

                    ...companyTrips.map((trip) => _buildPremiumTripCard(context, trip, primaryColor, darkBlue)),
                    const SizedBox(height: 30),
                    _buildSectionTitle("مكاتبنا الرئيسية"),
                    _buildHorizontalBranches(primaryColor),
                    const SizedBox(height: 30),
                    _buildSectionTitle("رائي المسافرون؟"),
                    _buildReviewCard(darkBlue),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverHeader(BuildContext context, Color primary, Color dark) {
    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      elevation: 0,
      stretch: true,
      backgroundColor: dark,
      automaticallyImplyLeading: false,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: Colors.white24,
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        background: Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [dark, primary.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Positioned(
              top: -50,
              left: -50,
              child: CircleAvatar(radius: 100, backgroundColor: Colors.white.withOpacity(0.05)),
            ),
            Positioned(
              bottom: 30,
              child: Hero(
                tag: companyName,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      )
                    ],
                  ),
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.directions_bus_filled_rounded,
                        color: primary,
                        size: 50,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainInfo(Color dark) {
    return Center(
      child: Column(
        children: [
          Text(companyName,
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: dark,
                  letterSpacing: 0.5)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: [
                    const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                    Text(" $rating ",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.orange)),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              const Text("(154 تعليق)",
                  style: TextStyle(color: Colors.grey, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            "رائدون في النقل السياحي والبري بأحدث الأساطيل وأعلى معايير السلامة لضمان راحتكم طوال الرحلة.",
            textAlign: TextAlign.center,
            style:
                TextStyle(color: Colors.grey[600], height: 1.6, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildModernAmenities(Color primary, Color dark) {
    final List<Map<String, dynamic>> items = [
      {"icon": Icons.wifi_rounded, "label": "إنترنت"},
      {"icon": Icons.ac_unit_rounded, "label": "تكييف"},
      {"icon": Icons.battery_charging_full_rounded, "label": "شحن"},
      {"icon": Icons.fastfood_rounded, "label": "ضيافة"},
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: items
          .map((item) => Container(
                width: 75,
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.02), blurRadius: 10)
                  ],
                ),
                child: Column(
                  children: [
                    Icon(item['icon'], color: primary, size: 28),
                    const SizedBox(height: 8),
                    Text(item['label'],
                        style: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.bold, color: dark)),
                  ],
                ),
              ))
          .toList(),
    );
  }

  Widget _buildPremiumTripCard(
      BuildContext context, CompanyTrip trip, Color primary, Color dark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 15,
              offset: const Offset(0, 5))
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildCityPoint(trip.from, trip.time),
              Expanded(
                child: Column(
                  children: [
                    Icon(Icons.chevron_left_rounded,
                        color: primary.withOpacity(0.5)),
                    Container(
                        height: 2,
                        color: primary.withOpacity(0.1),
                        margin: const EdgeInsets.symmetric(horizontal: 10)),
                  ],
                ),
              ),
              _buildCityPoint(trip.to, "04:00 م"),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${trip.price} ر.ي",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: dark)),
                  Text("مقاعد متبقية: ${trip.remainingSeats}",
                      style: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 11,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TripDetailsScreen(
                        trip: trip,
                        companyName: companyName,
                        rating: rating,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: dark,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 0,
                ),
                child: const Text("احجز الآن",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCityPoint(String city, String time) {
    return Column(
      children: [
        Text(city,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 4),
        Text(time, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
      ],
    );
  }

  Widget _buildHorizontalBranches(Color primary) {
    final branches = ["صنعاء - الستين", "عدن - الشيخ عثمان", "تعز - الحوبان"];
    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: branches.length,
        itemBuilder: (context, i) => Container(
          margin: const EdgeInsets.only(left: 10),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: primary.withOpacity(0.2)),
          ),
          child: Center(
              child: Text(branches[i],
                  style: TextStyle(
                      color: primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12))),
        ),
      ),
    );
  }

  Widget _buildReviewCard(Color dark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(25)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
              backgroundColor: Color(0xFFF0F3FF),
              child: Icon(Icons.person, color: Colors.grey)),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(" UserName ",
                        style: TextStyle(fontWeight: FontWeight.bold, color: dark)),
                    const Row(children: [
                      Icon(Icons.star, color: Colors.amber, size: 14),
                      Text(" 5.0", style: TextStyle(fontSize: 12))
                    ]),
                  ],
                ),
                const SizedBox(height: 5),
                const Text(
                    "باصات نظيفة جداً والسائق كان محترم والمواعيد مضبوطة بالدقيقة.",
                    style: TextStyle(
                        fontSize: 13, color: Colors.grey, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Text(title,
          style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Color(0xFF0D1B3E))),
    );
  }
}