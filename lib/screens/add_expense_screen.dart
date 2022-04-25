// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:expenses_tracker/helpers/DBHelper.dart';
import 'package:expenses_tracker/models/expense.dart';
import 'package:expenses_tracker/screens/home_screen.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:provider/provider.dart';

class AddExpenseScreen extends StatefulWidget {
  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final amountController = TextEditingController();
  final typeController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    amountController.dispose();
    typeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff57C8FB),
        title: Text("Add Expenses"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Add expense',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30.0,
                color: Color(0xff57C8FB),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Cost",
                border: OutlineInputBorder(),
              ),
              controller: amountController,
            ),
            SizedBox(
              height: 10.0,
            ),
            TextField(
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: "What did you spend on?",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {},
              controller: typeController,
            ),
            SizedBox(
              height: 10.0,
            ),
            Consumer<DBHelper>(
              builder: (context, value, child) {
                return TextButton(
                  style:
                      TextButton.styleFrom(backgroundColor: Color(0xff57C8FB)),
                  onPressed: () async {
                    if (amountController.text != '' &&
                        typeController.text != '') {
                      final expense = Expense(
                          id: value.lengthOfExpenses + 1,
                          cost: int.parse(amountController.text),
                          type: typeController.text,
                          date: DateTime.now().toIso8601String(),
                          balance: value.salary -
                              (value.thisMonth +
                                  int.parse(amountController.text)));
                      await value.addExpenses(expense);

                      await value.getExpenses();
                      Navigator.pop(context);
                    } else {
                      final snackBar = SnackBar(
                        content: const Text(
                            'Please enter cost amount and what you spent on'),
                        action: SnackBarAction(
                          label: 'Close',
                          onPressed: () {},
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: Text(
                    "Add",
                    style: TextStyle(fontSize: 25.0, color: Colors.white),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
