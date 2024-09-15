import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'home.dart';
import 'login_page.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(PayReminder());
}

class PayReminder extends StatefulWidget {
  @override
  State<PayReminder> createState() => _PayReminderAppState();
}

class _PayReminderAppState extends State<PayReminder> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pay Reminder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(), // Start with the Dashboard screen
    );
  }
}
