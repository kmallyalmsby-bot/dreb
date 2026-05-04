import 'package:flutter/material.dart';
 import 'package:darb_app/models/company_model.dart'; 
import 'company_details_screen.dart'; 

class CompaniesScreen extends StatelessWidget {
  const CompaniesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFE79C24);
    const darkBlue = Color(0xFF0D1B3E);
    const bgColor = Color(0xFFF8F9FD);

    final List<Company> companiesList = [
      Company(name: "الرويشان", rating: 4.8, totalTrips: 24),
      Company(name: "الأولى", rating: 4.5, totalTrips: 30),
      Company(name: "راحة", rating: 4.9, totalTrips: 15),
      Company(name: "النور", rating: 4.2, totalTrips: 10),
      Company(name: "البراق", rating: 4.0, totalTrips: 18),
      Company(name: "المتحدة", rating: 4.3, totalTrips: 22),
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bgColor,
        body: Column(
          children: [
            _buildStandardHeader(context, primaryColor),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 45,
                  crossAxisSpacing: 15,
                  childAspectRatio: 0.72,
                ),
                itemCount: companiesList.length,
                itemBuilder: (context, index) =>
                    _buildUltimateCompanyCard(context, companiesList[index], primaryColor, darkBlue),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStandardHeader(BuildContext context, Color primaryColor) {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(35),
          bottomRight: Radius.circular(35),
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("شركات النقل", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text("اختر شريك رحلتك القادمة", style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 13)),
                ],
              ),
            ),
            Positioned(
              right: 15, top: 15,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUltimateCompanyCard(BuildContext context, Company company, Color primary, Color dark) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [BoxShadow(color: dark.withOpacity(0.06), blurRadius: 20, offset: const Offset(0, 10))],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(height: 35),
                Text(
                  company.name,
                  style: TextStyle(color: dark, fontWeight: FontWeight.w900, fontSize: 17),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                    Text(" ${company.rating}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    const SizedBox(width: 8),
                    Text("| ${company.totalTrips} رحلة", style: TextStyle(color: Colors.grey.withOpacity(0.8), fontSize: 11)),
                  ],
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CompanyDetailsScreen(
                          companyName: company.name,
                          rating: company.rating,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(color: const Color(0xFFF0F3FF), borderRadius: BorderRadius.circular(15)),
                    child: Center(
                      child: Text("استكشف", style: TextStyle(color: dark, fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: -28,
          child: Container(
            height: 70, width: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: primary.withOpacity(0.25), blurRadius: 15, offset: const Offset(0, 8))],
              border: Border.all(color: Colors.white, width: 4),
            ),
            child: Center(child: Icon(Icons.directions_bus_filled_rounded, color: primary, size: 35)),
          ),
        ),
      ],
    );
  }
}