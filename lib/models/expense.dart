class Expense {
  final int id;
  final int cost;
  final String type;
  final String date;
  final int balance;

  const Expense(
      {required this.id,
      required this.cost,
      required this.type,
      required this.date,
      required this.balance});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cost': cost,
      'type': type,
      'date': date,
      'balance': balance,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Expense{id: $id, cost: $cost, type: $type,date:$date}';
  }
}

class Salary {
  final int id;
  final int amount;
  const Salary({
    required this.id,
    required this.amount,
  });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Salary{id: $id, amount: $amount}';
  }
}
