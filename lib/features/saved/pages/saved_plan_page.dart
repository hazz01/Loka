import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

// Plan Model
class Plan {
  final String id;
  final String title;
  final String transactionId;
  final String price;
  final String status;
  final Color statusColor;
  final Color statusBgColor;
  final String date;
  final String duration;
  final String category; // "Province", "Greater City", "City"

  Plan({
    required this.id,
    required this.title,
    required this.transactionId,
    required this.price,
    required this.status,
    required this.statusColor,
    required this.statusBgColor,
    required this.date,
    required this.duration,
    required this.category,
  });
}

class SavedPlanPage extends StatefulWidget {
  const SavedPlanPage({super.key});

  @override
  State<SavedPlanPage> createState() => _SavedPlanPageState();
}

class _SavedPlanPageState extends State<SavedPlanPage> {
  final TextEditingController searchController = TextEditingController();
  String selectedCategory = "Province";
  List<Plan> filteredPlans = [];

  // Dummy data plans
  final List<Plan> allPlans = [
    Plan(
      id: "1",
      title: "Malang Trip",
      transactionId: "698094554317",
      price: "IDR 150,000",
      status: "Process",
      statusColor: Color(0xFFF49A47),
      statusBgColor: Color(0xFFFDEBDA),
      date: "17 Sep 2023",
      duration: "10 Days",
      category: "Province",
    ),
    Plan(
      id: "2",
      title: "Bali Adventure",
      transactionId: "698094554318",
      price: "IDR 500,000",
      status: "Completed",
      statusColor: Color(0xFF4CAF50),
      statusBgColor: Color(0xFFE8F5E9),
      date: "10 Sep 2023",
      duration: "7 Days",
      category: "Province",
    ),
    Plan(
      id: "3",
      title: "Jakarta Tour",
      transactionId: "698094554319",
      price: "IDR 200,000",
      status: "Process",
      statusColor: Color(0xFFF49A47),
      statusBgColor: Color(0xFFFDEBDA),
      date: "20 Sep 2023",
      duration: "5 Days",
      category: "Greater City",
    ),
    Plan(
      id: "4",
      title: "Surabaya Explore",
      transactionId: "698094554320",
      price: "IDR 180,000",
      status: "Cancelled",
      statusColor: Color(0xFFE53935),
      statusBgColor: Color(0xFFFFEBEE),
      date: "15 Sep 2023",
      duration: "4 Days",
      category: "Greater City",
    ),
    Plan(
      id: "5",
      title: "Bandung City",
      transactionId: "698094554321",
      price: "IDR 120,000",
      status: "Completed",
      statusColor: Color(0xFF4CAF50),
      statusBgColor: Color(0xFFE8F5E9),
      date: "12 Sep 2023",
      duration: "3 Days",
      category: "City",
    ),
    Plan(
      id: "6",
      title: "Yogyakarta Heritage",
      transactionId: "698094554322",
      price: "IDR 250,000",
      status: "Process",
      statusColor: Color(0xFFF49A47),
      statusBgColor: Color(0xFFFDEBDA),
      date: "25 Sep 2023",
      duration: "6 Days",
      category: "Province",
    ),
    Plan(
      id: "7",
      title: "Semarang Trip",
      transactionId: "698094554323",
      price: "IDR 100,000",
      status: "Completed",
      statusColor: Color(0xFF4CAF50),
      statusBgColor: Color(0xFFE8F5E9),
      date: "08 Sep 2023",
      duration: "2 Days",
      category: "City",
    ),
    Plan(
      id: "8",
      title: "Medan Culinary",
      transactionId: "698094554324",
      price: "IDR 300,000",
      status: "Process",
      statusColor: Color(0xFFF49A47),
      statusBgColor: Color(0xFFFDEBDA),
      date: "22 Sep 2023",
      duration: "8 Days",
      category: "Greater City",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _applyFilters();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    setState(() {
      _applyFilters();
    });
  }

  void _applyFilters() {
    setState(() {
      var filtered = allPlans.where((plan) {
        // Filter by category
        final matchesCategory = plan.category == selectedCategory;

        // Filter by search query
        final matchesSearch =
            searchController.text.isEmpty ||
            plan.title.toLowerCase().contains(
              searchController.text.toLowerCase(),
            ) ||
            plan.transactionId.toLowerCase().contains(
              searchController.text.toLowerCase(),
            );

        return matchesCategory && matchesSearch;
      }).toList();

      filteredPlans = filtered;
    });
  }

  void _selectCategory(String category) {
    setState(() {
      selectedCategory = category;
      _applyFilters();
    });
  }

  Widget _buildPlanCard(Plan plan, bool isSmallScreen, double scale) {
    return Container(
      margin: EdgeInsets.only(bottom: (16 * scale).clamp(14.0, 18.0)),
      padding: EdgeInsets.all((16 * scale).clamp(14.0, 18.0)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isSmallScreen ? 10 : 12),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all((10 * scale).clamp(8.0, 12.0)),
                  decoration: BoxDecoration(
                    color: Color(0xFF539DF3),
                    borderRadius: BorderRadius.circular(
                      isSmallScreen ? 10 : 12,
                    ),
                  ),
                  child: Icon(
                    LucideIcons.map,
                    color: Colors.white,
                    size: (28 * scale).clamp(24.0, 32.0),
                  ),
                ),
                SizedBox(width: (16 * scale).clamp(12.0, 20.0)),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        plan.title,
                        style: TextStyle(
                          fontSize: (16 * scale).clamp(14.0, 18.0),
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF26273A),
                        ),
                      ),
                      SizedBox(height: (6 * scale).clamp(5.0, 7.0)),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Transaction ID: ",
                            style: TextStyle(
                              fontSize: (11 * scale).clamp(10.0, 12.0),
                              color: Color(0xFF7D7D89),
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Text(
                            plan.transactionId,
                            style: TextStyle(
                              color: Color(0xFF539DF3),
                              fontSize: (11 * scale).clamp(10.0, 12.0),
                              fontWeight: FontWeight.normal,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: (12 * scale).clamp(10.0, 14.0)),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                plan.price,
                style: TextStyle(
                  fontSize: (15 * scale).clamp(13.0, 17.0),
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF26273A),
                ),
              ),
              SizedBox(height: (5 * scale).clamp(4.0, 6.0)),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: (8 * scale).clamp(6.0, 10.0),
                  vertical: (4 * scale).clamp(3.0, 5.0),
                ),
                decoration: BoxDecoration(
                  color: plan.statusBgColor,
                  borderRadius: BorderRadius.circular(isSmallScreen ? 5 : 6),
                ),
                child: Text(
                  plan.status,
                  style: TextStyle(
                    fontSize: (10 * scale).clamp(9.0, 11.0),
                    color: plan.statusColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: (5 * scale).clamp(4.0, 6.0)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    plan.date,
                    style: TextStyle(
                      fontSize: (11 * scale).clamp(10.0, 12.0),
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF7D848D),
                    ),
                  ),
                  SizedBox(width: (2 * scale).clamp(1.0, 3.0)),
                  Text(
                    plan.duration,
                    style: TextStyle(
                      fontSize: (11 * scale).clamp(10.0, 12.0),
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF7D848D),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final scale = isSmallScreen ? 0.85 : (screenWidth / 375).clamp(0.85, 1.1);

    return Scaffold(
      backgroundColor: Color(0xFFF4F4F4),
      appBar: AppBar(
        toolbarHeight: isSmallScreen ? 56 : 70,
        backgroundColor: const Color(0xFFF4F4F4),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Your Plan",
          style: TextStyle(
            color: Colors.black,
            fontSize: (16 * scale).clamp(14.0, 18.0),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 20 : 30,
          vertical: isSmallScreen ? 16 : 20,
        ),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              onChanged: _performSearch,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Search destination here',
                hintStyle: TextStyle(
                  color: Colors.black.withOpacity(0.3),
                  fontSize: (14 * scale).clamp(12.0, 16.0),
                  fontWeight: FontWeight.w500,
                ),
                prefixIcon: Icon(
                  LucideIcons.search,
                  color: Colors.black.withOpacity(0.3),
                  size: (17 * scale).clamp(15.0, 19.0),
                ),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          LucideIcons.x,
                          color: Colors.black.withOpacity(0.3),
                          size: (17 * scale).clamp(15.0, 19.0),
                        ),
                        onPressed: () {
                          setState(() {
                            searchController.clear();
                            _performSearch('');
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(isSmallScreen ? 10 : 12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: (20 * scale).clamp(16.0, 24.0),
                  vertical: (12 * scale).clamp(10.0, 14.0),
                ),
              ),
            ),
            SizedBox(height: (20 * scale).clamp(16.0, 24.0)),
            Row(
              spacing: (10 * scale).clamp(8.0, 12.0),
              children: [
                GestureDetector(
                  onTap: () => _selectCategory("Province"),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: (16 * scale).clamp(14.0, 18.0),
                      vertical: (10 * scale).clamp(8.0, 12.0),
                    ),
                    decoration: BoxDecoration(
                      color: selectedCategory == "Province"
                          ? Color(0xFF539DF3)
                          : Color(0xFFD4E3F4),
                      borderRadius: BorderRadius.circular(
                        isSmallScreen ? 10 : 12,
                      ),
                    ),
                    child: Text(
                      "Province",
                      style: TextStyle(
                        fontSize: (14 * scale).clamp(12.0, 16.0),
                        fontWeight: selectedCategory == "Province"
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: selectedCategory == "Province"
                            ? Colors.white
                            : Color(0xFF539DF3),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _selectCategory("Greater City"),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: (16 * scale).clamp(14.0, 18.0),
                      vertical: (10 * scale).clamp(8.0, 12.0),
                    ),
                    decoration: BoxDecoration(
                      color: selectedCategory == "Greater City"
                          ? Color(0xFF539DF3)
                          : Color(0xFFD4E3F4),
                      borderRadius: BorderRadius.circular(
                        isSmallScreen ? 10 : 12,
                      ),
                    ),
                    child: Text(
                      "Greater City",
                      style: TextStyle(
                        fontSize: (14 * scale).clamp(12.0, 16.0),
                        fontWeight: selectedCategory == "Greater City"
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: selectedCategory == "Greater City"
                            ? Colors.white
                            : Color(0xFF539DF3),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _selectCategory("City"),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: (16 * scale).clamp(14.0, 18.0),
                      vertical: (10 * scale).clamp(8.0, 12.0),
                    ),
                    decoration: BoxDecoration(
                      color: selectedCategory == "City"
                          ? Color(0xFF539DF3)
                          : Color(0xFFD4E3F4),
                      borderRadius: BorderRadius.circular(
                        isSmallScreen ? 10 : 12,
                      ),
                    ),
                    child: Text(
                      "City",
                      style: TextStyle(
                        fontSize: (14 * scale).clamp(12.0, 16.0),
                        fontWeight: selectedCategory == "City"
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: selectedCategory == "City"
                            ? Colors.white
                            : Color(0xFF539DF3),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: (20 * scale).clamp(16.0, 24.0)),
            // Display filtered plans
            if (filteredPlans.isEmpty)
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: (40 * scale).clamp(30.0, 50.0),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        LucideIcons.searchX,
                        size: (48 * scale).clamp(40.0, 56.0),
                        color: Colors.black38,
                      ),
                      SizedBox(height: (16 * scale).clamp(12.0, 20.0)),
                      Text(
                        "No plans found",
                        style: TextStyle(
                          fontSize: (16 * scale).clamp(14.0, 18.0),
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Column(
                children: filteredPlans.map((plan) {
                  return _buildPlanCard(plan, isSmallScreen, scale);
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
