import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting dates
import 'payment.dart';
import 'home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Payment> payments = [];
  double totalDue = 0.0;
  double upcomingPayments = 0.0;

  @override
  void initState() {
    super.initState();
    _loadPayments();
  }

  _loadPayments() async {
    final prefs = await SharedPreferences.getInstance();
    final String? paymentsData = prefs.getString('payments');
    if (paymentsData != null) {
      final List<dynamic> decodedData = jsonDecode(paymentsData);
      setState(() {
        payments = decodedData.map((item) => Payment.fromJson(item)).toList();
        _calculateTotals();
      });
    }
  }

  _calculateTotals() {
    DateTime now = DateTime.now();
    double total = 0.0;
    double upcoming = 0.0;

    for (var payment in payments) {
      if (DateFormat.yMMMd().parse(payment.dueDate).isBefore(now)) {
        total += payment.amount;
      } else {
        upcoming += payment.amount;
      }
    }

    setState(() {
      totalDue = total;
      upcomingPayments = upcoming;
    });
  }

  // This function will handle navigation and refresh the page upon return
  Future<void> _navigateToHome() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PaymentReminderApp()),
    );
    if (result != null) {
      // If there's a result or the user returns, refresh the page
      setState(() {
        _loadPayments();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Overview',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            OverviewCard(
              title: 'Total Due',
              amount: '\$${totalDue.toStringAsFixed(2)}',
              icon: Icons.account_balance_wallet,
              color: Colors.red,
            ),
            OverviewCard(
              title: 'Upcoming Payments',
              amount: '\$${upcomingPayments.toStringAsFixed(2)}',
              icon: Icons.schedule,
              color: Colors.orange,
            ),

            ExpenseTrackingCard(
              totalSpent: '\$950.00', // Placeholder value, update as needed
              onTap: _navigateToHome, // Navigate to Home with a potential result
            ),
            SizedBox(height: 20),

            Text(
              'Recent Transactions',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            RecentTransactionTile(
              title: 'Electricity Bill',
              date: 'Aug 20, 2024',
              amount: '-\$120.00', // Placeholder value
            ),
            RecentTransactionTile(
              title: 'Netflix Subscription',
              date: 'Aug 18, 2024',
              amount: '-\$15.00', // Placeholder value
            ),
            RecentTransactionTile(
              title: 'Grocery Shopping',
              date: 'Aug 17, 2024',
              amount: '-\$85.00', // Placeholder value
            ),
          ],
        ),
      ),
    );
  }
}

class OverviewCard extends StatelessWidget {
  final String title;
  final String amount;
  final IconData icon;
  final Color color;

  OverviewCard({
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      elevation: 5.0,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 40, color: color),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  amount,
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ExpenseTrackingCard extends StatelessWidget {
  final String totalSpent;
  final VoidCallback onTap;

  ExpenseTrackingCard({
    required this.totalSpent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      elevation: 5.0,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(Icons.trending_up, size: 40, color: Colors.blue),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Spent',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    totalSpent,
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RecentTransactionTile extends StatelessWidget {
  final String title;
  final String date;
  final String amount;

  RecentTransactionTile({
    required this.title,
    required this.date,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      elevation: 3.0,
      child: ListTile(
        leading: Icon(Icons.monetization_on, color: Colors.green),
        title: Text(title),
        subtitle: Text(date),
        trailing: Text(
          amount,
          style: TextStyle(fontSize: 16, color: Colors.redAccent),
        ),
      ),
    );
  }
}
