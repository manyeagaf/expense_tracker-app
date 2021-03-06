// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:convert';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:expenses_tracker/helpers/DBHelper.dart';
import 'package:expenses_tracker/models/expense.dart';
import 'package:expenses_tracker/screens/home_screen.dart';

class AddExpenseScreen extends StatefulWidget {
  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final amountController = TextEditingController();
  final typeController = TextEditingController();
  final dateController = TextEditingController()
    ..text = DateTime.now().toString();

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
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.5,
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
            DateTimePicker(
              type: DateTimePickerType.dateTimeSeparate,
              controller: dateController,
              dateMask: 'd MMMM, yyyy',
              // initialValue: DateTime.now().toString(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              icon: Icon(Icons.event),
              dateLabelText: 'Date',
              timeLabelText: "Hour",
              selectableDayPredicate: (date) {
                // Disable weekend days to select from the calendar
                // if (date.weekday == 6 || date.weekday == 7) {
                //   return false;
                // }

                return true;
              },
              onChanged: (val) {
                // print(val);
                print("date ${dateController.text}");
              },
              validator: (val) {
                print(val);
                return null;
              },
              onSaved: (val) => print(val),
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
                          id: value.lastExpenseId + 1,
                          cost: int.parse(amountController.text),
                          type: typeController.text,
                          date: dateController.text,
                          balance: value.salary -
                              (value.thisMonth +
                                  int.parse(amountController.text)));
                      await value.addExpenses(expense);
                      await value.getExpenses();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HomeScreen(),
                        ),
                      );
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
