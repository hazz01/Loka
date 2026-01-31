import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

// Transaction Model
class Transaction {
  final IconData icon;
  final String title;
  final String transactionId;
  final String amount;
  final String status;
  final Color statusColor;
  final Color statusBgColor;
  final String date;
  final String time;
  final String period; // "This week" or "Last month"

  Transaction({
    required this.icon,
    required this.title,
    required this.transactionId,
    required this.amount,
    required this.status,
    required this.statusColor,
    required this.statusBgColor,
    required this.date,
    required this.time,
    required this.period,
  });
}

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  String selectedFilter = "This week";
  bool isSearchMode = false;
  final TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Transaction data array
  final List<Transaction> allTransactions = [
    // This week transactions
    Transaction(
      icon: LucideIcons.shoppingCart,
      title: "Trip payment",
      transactionId: "698094554317",
      amount: "Rp 2.500.000",
      status: "Confirmed",
      statusColor: Color(0xFF0DBB57),
      statusBgColor: Color(0xFFCFF1DD),
      date: "15 Oct 2025",
      time: "09:30 AM",
      period: "This week",
    ),
    Transaction(
      icon: LucideIcons.eye,
      title: "360° View Purchase",
      transactionId: "698094554318",
      amount: "-5 ViewCoins",
      status: "Completed",
      statusColor: Color(0xFF0DBB57),
      statusBgColor: Color(0xFFCFF1DD),
      date: "14 Oct 2025",
      time: "02:15 PM",
      period: "This week",
    ),
    // Last month transactions
    Transaction(
      icon: LucideIcons.wallet,
      title: "ViewCoin Purchase",
      transactionId: "698094554315",
      amount: "+20 ViewCoins",
      status: "Completed",
      statusColor: Color(0xFF0DBB57),
      statusBgColor: Color(0xFFCFF1DD),
      date: "28 Sep 2025",
      time: "11:45 AM",
      period: "Last month",
    ),
    Transaction(
      icon: LucideIcons.shoppingCart,
      title: "Trip payment",
      transactionId: "698094554312",
      amount: "Rp 1.800.000",
      status: "Confirmed",
      statusColor: Color(0xFF0DBB57),
      statusBgColor: Color(0xFFCFF1DD),
      date: "20 Sep 2025",
      time: "03:20 PM",
      period: "Last month",
    ),
    Transaction(
      icon: LucideIcons.eye,
      title: "360° View Purchase",
      transactionId: "698094554310",
      amount: "-5 ViewCoins",
      status: "Completed",
      statusColor: Color(0xFF0DBB57),
      statusBgColor: Color(0xFFCFF1DD),
      date: "18 Sep 2025",
      time: "10:00 AM",
      period: "Last month",
    ),
    Transaction(
      icon: LucideIcons.circleX,
      title: "Trip payment",
      transactionId: "698094554308",
      amount: "Rp 3.200.000",
      status: "Cancelled",
      statusColor: Color(0xFFE53935),
      statusBgColor: Color(0xFFFFCDD2),
      date: "15 Sep 2025",
      time: "01:30 PM",
      period: "Last month",
    ),
  ];

  // Get filtered transactions based on selected filter and search query
  List<Transaction> get filteredTransactions {
    var filtered = allTransactions
        .where((transaction) => transaction.period == selectedFilter)
        .toList();

    // Apply search filter if search query is not empty
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((transaction) {
        final titleLower = transaction.title.toLowerCase();
        final idLower = transaction.transactionId.toLowerCase();
        final amountLower = transaction.amount.toLowerCase();
        final queryLower = searchQuery.toLowerCase();

        return titleLower.contains(queryLower) ||
            idLower.contains(queryLower) ||
            amountLower.contains(queryLower);
      }).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final scale = isSmallScreen ? 0.85 : (screenWidth / 375).clamp(0.85, 1.1);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        toolbarHeight: isSmallScreen ? 56 : 70,
        backgroundColor: const Color(0xFFF4F4F4),
        elevation: 0,
        centerTitle: !isSearchMode,
        leading: IconButton(
          icon: Icon(
            isSearchMode ? LucideIcons.x : LucideIcons.arrowLeft,
            color: Colors.black,
            size: (22 * scale).clamp(20.0, 26.0),
          ),
          padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
          onPressed: () {
            if (isSearchMode) {
              setState(() {
                isSearchMode = false;
                searchQuery = "";
                searchController.clear();
              });
            } else {
              context.go('/profile');
            }
          },
        ),
        title: isSearchMode
            ? TextField(
                controller: searchController,
                autofocus: true,
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                style: TextStyle(
                  color: Colors.black,
                  fontSize: (16 * scale).clamp(14.0, 18.0),
                ),
                decoration: InputDecoration(
                  hintText: "Search transactions...",
                  hintStyle: TextStyle(
                    color: Colors.black54,
                    fontSize: (16 * scale).clamp(14.0, 18.0),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
              )
            : Text(
                "Transaction History",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: (16 * scale).clamp(14.0, 18.0),
                  fontWeight: FontWeight.w600,
                ),
              ),
        actions: [
          if (!isSearchMode)
            IconButton(
              onPressed: () {
                setState(() {
                  isSearchMode = true;
                });
              },
              padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
              icon: Icon(
                LucideIcons.search,
                color: Colors.black,
                size: (22 * scale).clamp(20.0, 26.0),
              ),
            ),
          if (isSearchMode && searchQuery.isNotEmpty)
            IconButton(
              onPressed: () {
                setState(() {
                  searchQuery = "";
                  searchController.clear();
                });
              },
              padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
              icon: Icon(
                LucideIcons.x,
                color: Colors.black54,
                size: (20 * scale).clamp(18.0, 24.0),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 20 : 30,
          vertical: isSmallScreen ? 16 : 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter buttons
            Row(
              children: [
                _buildFilterButton(
                  label: "This week",
                  isSelected: selectedFilter == "This week",
                  onTap: () {
                    setState(() {
                      selectedFilter = "This week";
                    });
                  },
                  isSmallScreen: isSmallScreen,
                  scale: scale,
                ),
                SizedBox(width: (12 * scale).clamp(8.0, 16.0)),
                _buildFilterButton(
                  label: "Last month",
                  isSelected: selectedFilter == "Last month",
                  onTap: () {
                    setState(() {
                      selectedFilter = "Last month";
                    });
                  },
                  isSmallScreen: isSmallScreen,
                  scale: scale,
                ),
              ],
            ),
            SizedBox(height: (24 * scale).clamp(18.0, 28.0)),
            // Display transactions based on selected filter using array
            if (filteredTransactions.isEmpty)
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
                        searchQuery.isNotEmpty
                            ? "No transactions found"
                            : "No transactions available",
                        style: TextStyle(
                          fontSize: (16 * scale).clamp(14.0, 18.0),
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (searchQuery.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(
                            top: (8 * scale).clamp(6.0, 10.0),
                          ),
                          child: Text(
                            'Try different keywords',
                            style: TextStyle(
                              fontSize: (14 * scale).clamp(12.0, 16.0),
                              color: Colors.black38,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              )
            else
              ...filteredTransactions.asMap().entries.map((entry) {
                final index = entry.key;
                final transaction = entry.value;

                return Column(
                  children: [
                    _buildTransactionItem(
                      icon: transaction.icon,
                      title: transaction.title,
                      transactionId: transaction.transactionId,
                      amount: transaction.amount,
                      status: transaction.status,
                      statusColor: transaction.statusColor,
                      statusBgColor: transaction.statusBgColor,
                      date: transaction.date,
                      time: transaction.time,
                      isSmallScreen: isSmallScreen,
                      scale: scale,
                    ),
                    // Add spacing between items except for the last one
                    if (index < filteredTransactions.length - 1)
                      SizedBox(height: (16 * scale).clamp(12.0, 20.0)),
                  ],
                );
              }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isSmallScreen,
    required double scale,
  }) {
    return Flexible(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: (16 * scale).clamp(12.0, 20.0),
            vertical: (10 * scale).clamp(8.0, 12.0),
          ),
          decoration: BoxDecoration(
            color: isSelected ? Color(0xFF539DF3) : Color(0xFFD4E3F4),
            borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 10),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: (14 * scale).clamp(12.0, 16.0),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? Colors.white : Color(0xFF539DF3),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionItem({
    required IconData icon,
    required String title,
    required String transactionId,
    required String amount,
    required String status,
    required Color statusColor,
    required Color statusBgColor,
    required String date,
    required String time,
    required bool isSmallScreen,
    required double scale,
  }) {
    return Container(
      padding: EdgeInsets.all((16 * scale).clamp(12.0, 20.0)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 15),
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
                      (12 * scale).clamp(10.0, 14.0),
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: (28 * scale).clamp(22.0, 32.0),
                  ),
                ),
                SizedBox(width: (16 * scale).clamp(12.0, 18.0)),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: (16 * scale).clamp(14.0, 18.0),
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF26273A),
                        ),
                      ),
                      SizedBox(height: (6 * scale).clamp(4.0, 8.0)),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Transaction ID: ",
                            style: TextStyle(
                              fontSize: (11 * scale).clamp(9.0, 13.0),
                              color: Color(0xFF7D7D89),
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Text(
                            transactionId,
                            style: TextStyle(
                              color: Color(0xFF539DF3),
                              fontSize: (11 * scale).clamp(9.0, 13.0),
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
          SizedBox(width: (12 * scale).clamp(8.0, 14.0)),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
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
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(
                    (6 * scale).clamp(5.0, 7.0),
                  ),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: (10 * scale).clamp(8.0, 12.0),
                    color: statusColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: (5 * scale).clamp(4.0, 6.0)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: (11 * scale).clamp(9.0, 13.0),
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF7D848D),
                    ),
                  ),
                  SizedBox(width: (2 * scale).clamp(1.0, 3.0)),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: (11 * scale).clamp(9.0, 13.0),
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
}
