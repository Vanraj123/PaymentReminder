import 'package:flutter/material.dart';
import 'payment.dart';
import 'package:intl/intl.dart';

class AddPaymentScreen extends StatefulWidget {
  final Payment? payment;

  AddPaymentScreen({this.payment});

  @override
  _AddPaymentScreenState createState() => _AddPaymentScreenState();
}

class _AddPaymentScreenState extends State<AddPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String dueDate = '';
  double amount = 0.0;

  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.payment != null) {
      name = widget.payment!.name;
      dueDate = widget.payment!.dueDate;
      amount = widget.payment!.amount;
      _dateController.text = dueDate;
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: dueDate.isNotEmpty ? DateFormat.yMMMd().parse(dueDate) : DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        dueDate = DateFormat.yMMMd().format(pickedDate);
        _dateController.text = dueDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.payment == null ? 'Add Payment' : 'Edit Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: name,
                decoration: InputDecoration(labelText: 'Payment Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name for the payment';
                  }
                  return null;
                },
                onSaved: (value) {
                  name = value!;
                },
              ),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Due Date',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () {
                  _selectDate(context);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please choose a due date';
                  }
                  return null;
                },
                onSaved: (value) {
                  dueDate = value!;
                },
              ),
              TextFormField(
                initialValue: amount != 0.0 ? amount.toString() : '',
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the amount';
                  }
                  return null;
                },
                onSaved: (value) {
                  amount = double.parse(value!);
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final newPayment = Payment(name: name, dueDate: dueDate, amount: amount);
                    Navigator.pop(context, newPayment);
                  }
                },
                child: Text(widget.payment == null ? 'Save Payment' : 'Update Payment'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




