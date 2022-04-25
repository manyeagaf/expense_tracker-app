// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:expenses_tracker/helpers/DBHelper.dart';
import 'package:expenses_tracker/models/expense.dart';
import 'package:expenses_tracker/screens/add_expense_screen.dart';
import 'package:expenses_tracker/widgets/expense_card.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ExpenseList extends StatefulWidget {
  // late Future<List<Expense>> futureExpense;
  // ExpenseList({required this.futureExpense});
  @override
  State<ExpenseList> createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> {
  @override
  void initState() {
    super.initState();
  }

  _buildExpenses(List<Expense> expenses) {
    List<ExpenseCard> expensesList = [];
    int len = expenses.length;
    for (int i = 0; i < len; i++) {
      expensesList.add(ExpenseCard(
        expense: expenses[i],
      ));
    }
    return Column(
      children: expensesList,
    );
  }

  final oCcy = NumberFormat("#,##0.00", "en_US");

  @override
  Widget build(BuildContext context) {
    context.read<DBHelper>().getExpenses();
    return ListView(
      children: [
        Consumer<DBHelper>(
          builder: (context, value, child) {
            return value.error == true
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : _buildExpenses(value.expensesList);
          },
        )
      ],
    );
  }
}
