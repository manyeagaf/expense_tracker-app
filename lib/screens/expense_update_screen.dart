// ignore_for_file: prefer_const_constructors

import 'package:date_time_picker/date_time_picker.dart';
import 'package:expenses_tracker/helpers/DBHelper.dart';
import 'package:expenses_tracker/models/expense.dart';
import 'package:expenses_tracker/screens/expense_detail_screen.dart';
import 'package:expenses_tracker/screens/expenses_history_screen.dart';
import 'package:expenses_tracker/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseUpdateScreen extends StatefulWidget {
  Expense expense;
  ExpenseUpdateScreen({required this.expense});

  @override
  State<ExpenseUpdateScreen> createState() => _ExpenseUpdateScreenState();
}

class _ExpenseUpdateScreenState extends State<ExpenseUpdateScreen> {
  final amountController = TextEditingController();
  final typeController = TextEditingController();
  final dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    context.read<DBHelper>().getExpenses();
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Edit expense',
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
                hintText: widget.expense.cost.toString(),
                border: OutlineInputBorder(),
              ),
              controller: amountController,
              // ..text = widget.expense.cost.toString(),
              onChanged: (value) {},
            ),
            SizedBox(
              height: 10.0,
            ),
            TextField(
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: widget.expense.type,
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {},
              controller: typeController,
              // ..text = widget.expense.type,
            ),
            SizedBox(
              height: 10.0,
            ),
            DateTimePicker(
              type: DateTimePickerType.dateTimeSeparate,
              controller: dateController..text = widget.expense.date,
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
                    final newExpense = Expense(
                      id: widget.expense.id,
                      cost: amountController.text == ''
                          ? widget.expense.cost
                          : int.parse(amountController.text),
                      type: typeController.text == ''
                          ? widget.expense.type
                          : typeController.text,
                      date: dateController.text,
                      balance: value.salary -
                          (value.thisMonth +
                              (amountController.text == ''
                                  ? widget.expense.cost
                                  : int.parse(amountController.text))),
                    );

                    await value.updateExpense(newExpense);

                    await value.getExpenses();

                    final snackBar = SnackBar(
                      content: const Text('Expense updated successfully'),
                      action: SnackBarAction(
                        label: 'Close',
                        onPressed: () {},
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => HomeScreen()));
                  },
                  child: Text(
                    "Save",
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
