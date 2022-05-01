// ignore_for_file: prefer_const_constructors

import 'package:expenses_tracker/helpers/DBHelper.dart';
import 'package:expenses_tracker/models/expense.dart';
import 'package:expenses_tracker/screens/add_expense_screen.dart';
import 'package:expenses_tracker/screens/expense_update_screen.dart';
import 'package:expenses_tracker/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ExpenseDetailScreen extends StatefulWidget {
  Expense expense;
  ExpenseDetailScreen({required this.expense});

  @override
  State<ExpenseDetailScreen> createState() => _ExpenseDetailScreenState();
}

class _ExpenseDetailScreenState extends State<ExpenseDetailScreen> {
  final oCcy = NumberFormat("#,##0.00", "en_US");

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.4,
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Cost : ₵${oCcy.format(this.widget.expense.cost)}",
              style: TextStyle(
                overflow: TextOverflow.ellipsis,
                fontSize: 20.0,
                color: Colors.black45,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              "Spent on : ${this.widget.expense.type}",
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.black45,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              "Date : ${this.widget.expense.date.substring(0, 16)}",
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.black45,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Consumer<DBHelper>(
              builder: (context, value, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      color: Colors.grey.shade200,
                      child: IconButton(
                        iconSize: 30.0,
                        color: Colors.black,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                ExpenseUpdateScreen(
                              expense: widget.expense,
                            ),
                          );
                        },
                        icon: Icon(Icons.edit_outlined),
                      ),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Container(
                      color: Colors.grey.shade200,
                      child: IconButton(
                          iconSize: 30.0,
                          color: Colors.redAccent,
                          onPressed: () {
                            if (Provider.of<DBHelper>(context, listen: false)
                                    .expensesList
                                    .length >
                                1) {
                              Provider.of<DBHelper>(context, listen: false)
                                  .deleteExpense(widget.expense);
                              final snackBar = SnackBar(
                                content:
                                    const Text('Expense deleted successfully'),
                                action: SnackBarAction(
                                  label: 'Close',
                                  onPressed: () {},
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => HomeScreen(),
                                ),
                              );
                            } else {
                              final snackBar = SnackBar(
                                content:
                                    const Text('Expenses list cannot be empty'),
                                action: SnackBarAction(
                                  label: 'Close',
                                  onPressed: () {},
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          },
                          icon: Icon(Icons.delete)),
                    )
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
