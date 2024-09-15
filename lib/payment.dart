class Payment {
  String name;
  String dueDate;
  double amount;

  Payment({required this.name, required this.dueDate, required this.amount});

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      name: json['name'],
      dueDate: json['dueDate'],
      amount: json['amount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dueDate': dueDate,
      'amount': amount,
    };
  }
}
