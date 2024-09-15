import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'payment.dart';
import 'expense_tracking_screen.dart'; // Assuming you have this file

class PaymentReminderApp extends StatefulWidget {
  @override
  State<PaymentReminderApp> createState() => _PaymentReminderAppState();
}

class _PaymentReminderAppState extends State<PaymentReminderApp> {
  List<Payment> payments = [];

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
      });
    }
  }

  _savePayments() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(payments.map((p) => p.toJson()).toList());
    await prefs.setString('payments', encodedData);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Trigger a refresh when popping back to the DashboardScreen
        Navigator.pop(context, true); // Pass 'true' to signal the need for a refresh
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Payment Reminder'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, true); // Pass 'true' to signal the need for a refresh
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: payments.isEmpty
              ? Center(
            child: Text(
              'No payments added yet!',
              style: TextStyle(fontSize: 18.0, color: Colors.grey),
            ),
          )
              : ListView.builder(
            itemCount: payments.length,
            itemBuilder: (context, index) {
              final payment = payments[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              payment.name,
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Due Date: ${payment.dueDate}',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Amount: ${payment.amount.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () async {
                              final updatedPayment = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddPaymentScreen(payment: payment)),
                              );
                              if (updatedPayment != null) {
                                setState(() {
                                  payments[index] = updatedPayment;
                                  _savePayments();
                                });
                              }
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                payments.removeAt(index);
                                _savePayments();
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final newPayment = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddPaymentScreen()),
            );
            if (newPayment != null) {
              setState(() {
                payments.add(newPayment);
                _savePayments();
              });
            }
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.blue,
        ),
      ),
    );
  }
}
