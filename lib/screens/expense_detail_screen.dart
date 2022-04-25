// ignore_for_file: prefer_const_constructors

import 'package:expenses_tracker/helpers/DBHelper.dart';
import 'package:expenses_tracker/models/expense.dart';
import 'package:expenses_tracker/screens/add_expense_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ExpenseDetailScreen extends StatelessWidget {
  Expense expense;
  ExpenseDetailScreen({required this.expense});
  final oCcy = NumberFormat("#,##0.00", "en_US");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expenses"),
        actions: [
          IconButton(
            onPressed: () async {
              // var databasesPath = await getDatabasesPath();
              // String path = join(databasesPath, 'expense_database.db');

              // await deleteDatabase(path);
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => AddExpenseScreen()));
            },
            icon: const Icon(Icons.add),
            iconSize: 40.0,
          ),
        ],
        elevation: 0.0,
        backgroundColor: const Color(0xff57C8FB),
      ),
      body: Material(
        elevation: 20.0,
        child: Container(
          height: 250.0,
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  "Cost : ₵${oCcy.format(this.expense.cost)}",
                  style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontSize: 20.0,
                    color: Color(0xff57C8FB),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  "Spent on : ${this.expense.type}",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Color(0xff57C8FB),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  "Date : ${this.expense.date.split('T')[0] + ' ' + this.expense.date.split("T")[1].substring(0, 8)}",
                  style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontSize: 20.0,
                    color: Color(0xff57C8FB),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
