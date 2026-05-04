import 'package:flutter/material.dart';
import '../models/search_model.dart';

class SearchResultsScreen extends StatefulWidget {
  final String fromCity;
  final String toCity;
  final String company;
  final DateTime travelDate;
  final String timePeriod;

  const SearchResultsScreen({
    super.key,
    required this.fromCity,
    required this.toCity,
    required this.company,
    required this.travelDate,
    required this.timePeriod,
  });

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  final List<Trip> allTripsData = [
    Trip(company: "الرويشان", rating: 4.8, reviews: 120, price: 25000, departureTime: "08:00 ص", arrivalTime: "04:00 م", seatsLeft: 5, fromCity: "صنعاء", toCity: "عدن", period: "الصباحية"),
    Trip(company: "الأولى", rating: 4.2, reviews: 85, price: 20000, departureTime: "06:00 ص", arrivalTime: "02:00 م", seatsLeft: 12, fromCity: "صنعاء", toCity: "عدن", period: "الصباحية"),
    Trip(company: "راحة", rating: 4.9, reviews: 210, price: 32000, departureTime: "10:30 م", arrivalTime: "06:30 ص", seatsLeft: 2, fromCity: "صنعاء", toCity: "عدن", period: "المسائية"),
    Trip(company: "البراق", rating: 3.5, reviews: 40, price: 18000, departureTime: "09:00 ص", arrivalTime: "05:00 م", seatsLeft: 20, fromCity: "عدن", toCity: "تعز", period: "الصباحية"),
  ];

  List<Trip> displayedTrips = []; 
  List<String> selectedFilters = ["الأرخص سعراً"];

  @override
  void initState() {
    super.initState();
    _applyInitialFilterAndSort();
  }

  void _applyInitialFilterAndSort() {
    setState(() {
      displayedTrips = allTripsData.where((trip) {
        bool matchFrom = trip.fromCity == widget.fromCity;
        bool matchTo = trip.toCity == widget.toCity;
        bool matchPeriod = trip.period == widget.timePeriod;
        bool matchCompany = (widget.company == "كل الشركات") || (trip.company == widget.company);
        
        return matchFrom && matchTo && matchPeriod && matchCompany;
      }).toList();

      _applySorting();
    });
  }

  void _applySorting() {
    setState(() {
      for (var filter in selectedFilters) {
        if (filter == "الأرخص سعراً") {
          displayedTrips.sort((a, b) => a.price.compareTo(b.price));
        } else if (filter == "الأعلى تقييماً") {
          displayedTrips.sort((a, b) => b.rating.compareTo(a.rating));
        } else if (filter == "الأقرب وقتاً") {
          displayedTrips.sort((a, b) => a.departureTime.compareTo(b.departureTime));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F7FA),
        body: Column(
          children: [
            _buildModernHeader(context),
            _buildHorizontalFilterBar(),
            Expanded(
              child: displayedTrips.isEmpty 
                ? _buildNoResults() 
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 10, bottom: 20),
                    itemCount: displayedTrips.length,
                    itemBuilder: (context, index) => _buildProfessionalTripCard(context, displayedTrips[index]),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bus_alert_rounded, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text("لا توجد رحلات متاحة حالياً", style: TextStyle(color: Colors.grey[600], fontSize: 16, fontWeight: FontWeight.bold)),
          Text("جرّب تغيير خيارات البحث", style: TextStyle(color: Colors.grey[400], fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildModernHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 50, bottom: 25, left: 20, right: 20),
      decoration: const BoxDecoration(
        color: Color(0xFFE79C24),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 22),
                onPressed: () => Navigator.of(context).pop(),
              ),
              const Text("نتائج البحث", style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold)),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _headerLocationInfo(widget.fromCity, "من"),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Icon(Icons.sync_alt_rounded, color: Colors.white.withOpacity(0.9), size: 28),
                ),
                _headerLocationInfo(widget.toCity, "إلى"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerLocationInfo(String city, String label) {
    return Column(
      children: [
        Text(city, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12)),
      ],
    );
  }

  Widget _buildHorizontalFilterBar() {
    return SizedBox(
      height: 65,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        children: [
          _buildFilterChip("الأرخص سعراً", Icons.payments_outlined),
          _buildFilterChip("الأقرب وقتاً", Icons.access_time_rounded),
          _buildFilterChip("الأعلى تقييماً", Icons.star_outline_rounded),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, IconData icon) {
    bool isActive = selectedFilters.contains(label);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isActive) {
            selectedFilters.remove(label);
          } else {
            selectedFilters.add(label);
          }
          _applySorting();
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(left: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF0D1B3E) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: isActive ? Colors.transparent : const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 17, color: isActive ? Colors.white : const Color(0xFF0D1B3E)),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(color: isActive ? Colors.white : const Color(0xFF0D1B3E), fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildProfessionalTripCard(BuildContext context, Trip trip) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: const Color(0xFF0D1B3E).withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(15)),
                  child: const Icon(Icons.directions_bus_filled, color: Color(0xFF0D1B3E), size: 26),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(trip.company, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: Color(0xFFFFB800), size: 18),
                          const SizedBox(width: 4),
                          Text("${trip.rating}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          Text(" (${trip.reviews} تقييم)", style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("${trip.price}", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFFE79C24))),
                    const Text("ريال يمني", style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
            const Divider(height: 30, color: Color(0xFFF3F4F6)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTimeNode(trip.departureTime, widget.fromCity),
                const Expanded(child: Icon(Icons.trending_flat, color: Colors.grey)),
                _buildTimeNode(trip.arrivalTime, widget.toCity),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: const Color(0xFFFEF2F2), borderRadius: BorderRadius.circular(8)),
                  child: Text("باقي ${trip.seatsLeft} مقاعد", style: const TextStyle(color: Color(0xFFEF4444), fontSize: 11, fontWeight: FontWeight.bold)),
                ),
                const Spacer(),
                const Text("تفاصيل الرحله", style: TextStyle(color: Color(0xFF0D1B3E), fontSize: 12, fontWeight: FontWeight.bold)),
                const Icon(Icons.arrow_back_rounded, size: 16, color: Color(0xFF0D1B3E)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeNode(String time, String city) {
    return Column(
      children: [
        Text(time, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF0D1B3E))),
        Text(city, style: const TextStyle(fontSize: 13, color: Color(0xFF9CA3AF))),
      ],
    );
  }
}