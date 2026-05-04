import 'package:flutter/material.dart';
import 'search_results.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart'; 
import 'my_bookings_screen.dart'; 
import 'companies_screen.dart';
import 'package:darb_app/models/home_model.dart';  

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeDataModel homeData = HomeDataModel();

  void _onItemTapped(int index) {
    setState(() {
      homeData.selectedIndex = index;
    });

    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MyBookingsScreen()),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: homeData.selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFFE79C24)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != homeData.selectedDate) {
      setState(() {
        homeData.selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildUpperSection(),
            const SizedBox(height: 25),
            
            _buildSectionTitle("رحلاتك القادمة", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyBookingsScreen()),
              );
            }),
            
            _buildEnhancedTripCard(),
            const SizedBox(height: 25),
            
            _buildSectionTitle("شركات النقل ", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CompaniesScreen()),
              );
            }),
            
            _buildCompaniesList(),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildUpperSection() {
    return Stack(
      children: [
        Container(
          height: 240,
          decoration: const BoxDecoration(
            color: Color(0xFFE79C24),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
        ),
        SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 10),
              _buildSearchCard(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.notifications_none_rounded, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationsScreen(userType: "passenger"),
                  ),
                );
              },
            ),
          ),
          const Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("أهلاً، مستخدم", 
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  Text("إلى أين تريد الذهاب اليوم؟", 
                    style: TextStyle(fontSize: 12, color: Colors.white70)),
                ],
              ),
              SizedBox(width: 12),
              CircleAvatar(
                radius: 22,
                backgroundColor: Color(0xFF0D1B3E),
                child: Icon(Icons.person, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 30, offset: const Offset(0, 15))
        ],
      ),
      child: Column(
        children: [
          _buildDropdownField(Icons.location_on, "من محافظة الانطلاق", homeData.selectedFrom, homeData.governorates, (val) => setState(() => homeData.selectedFrom = val!)),
          const SizedBox(height: 12),
          _buildDropdownField(Icons.navigation, "إلى محافظة الوصول", homeData.selectedTo, homeData.governorates, (val) => setState(() => homeData.selectedTo = val!)),
          const SizedBox(height: 12),
          _buildDropdownField(Icons.business_rounded, "شركة النقل", homeData.selectedCompany, homeData.companiesList, (val) => setState(() => homeData.selectedCompany = val!)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => _selectDate(context),
                  child: _buildSearchField(Icons.calendar_today, "التاريخ", "${homeData.selectedDate.day} / ${homeData.selectedDate.month}"),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildDropdownField(Icons.access_time, "الفترة", homeData.selectedTime, homeData.times, (val) => setState(() => homeData.selectedTime = val!)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchResultsScreen(
                      fromCity: homeData.selectedFrom,
                      toCity: homeData.selectedTo,
                      company: homeData.selectedCompany,
                      travelDate: homeData.selectedDate,
                      timePeriod: homeData.selectedTime,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE79C24),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 0,
              ),
              child: const Text(
                "البحث عن رحلات", 
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(IconData icon, String label, String currentValue, List<String> items, Function(String?) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: DropdownButtonHideUnderline(
                child: DropdownButtonFormField<String>(
                  value: currentValue,
                  icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF9CA3AF), size: 20),
                  decoration: InputDecoration(
                    labelText: label,
                    labelStyle: const TextStyle(fontSize: 13, color: Color(0xFF6B7280), fontWeight: FontWeight.w500),
                    border: InputBorder.none,
                  ),
                  items: items.map((String value) => DropdownMenuItem(
                    value: value,
                    alignment: Alignment.centerRight,
                    child: Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0D1B3E))),
                  )).toList(),
                  onChanged: onChanged,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Icon(icon, color: const Color(0xFFE79C24), size: 18),
        ],
      ),
    );
  }

  Widget _buildSearchField(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
                Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0D1B3E))),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Icon(icon, color: const Color(0xFFE79C24), size: 18),
        ],
      ),
    );
  }

  Widget _buildEnhancedTripCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1B3E),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(color: const Color(0xFF0D1B3E).withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 8))
        ]
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("رقم الحجز: #7821", style: TextStyle(color: Colors.white54, fontSize: 10)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.orange.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                child: const Text("قيد الانتظار", style: TextStyle(color: Colors.orange, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _tripLocation("صنعاء", "08:00 ص"),
              const Icon(Icons.swap_horiz, color: Colors.orange, size: 28),
              _tripLocation("عدن", "04:00 م"),
            ],
          ),
          const Divider(color: Colors.white10, height: 30),
          const Row(
            children: [
              Icon(Icons.directions_bus, color: Colors.orange, size: 16),
              SizedBox(width: 8),
              Text("شركة الرويشان للنقل", style: TextStyle(color: Colors.white, fontSize: 12)),
              Spacer(),
              Text("غداً، 26 إبريل", style: TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          )
        ],
      ),
    );
  }

  Widget _tripLocation(String city, String time) {
    return Column(
      children: [
        Text(city, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        Text(time, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  Widget _buildCompaniesList() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: homeData.logoNames.length,
        reverse: true,
        itemBuilder: (context, index) {
          return Container(
            width: 100,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFF3F4F6)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.directions_bus_filled_rounded, color: Color(0xFFE79C24), size: 35),
                const SizedBox(height: 8),
                Text(homeData.logoNames[index], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0D1B3E))),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: onTap,
            child: const Text("عرض الكل", style: TextStyle(fontSize: 12, color: Color(0xFFE79C24), fontWeight: FontWeight.bold)),
          ),
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0D1B3E))),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]
      ),
      child: BottomNavigationBar(
        currentIndex: homeData.selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFFE79C24),
        unselectedItemColor: const Color(0xFF9CA3AF),
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "حسابي"),
          BottomNavigationBarItem(icon: Icon(Icons.confirmation_number_outlined), label: "حجوزاتي"),
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: "الرئيسية"),
        ],
      ),
    );
  }
}