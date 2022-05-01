// ignore_for_file: prefer_const_constructors, must_be_immutable, use_key_in_widget_constructors

import 'package:expenses_tracker/models/expense.dart';
import 'package:expenses_tracker/screens/expense_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseCard extends StatefulWidget {
  Expense expense;

  ExpenseCard({required this.expense});

  @override
  State<ExpenseCard> createState() => _ExpenseCardState();
}

class _ExpenseCardState extends State<ExpenseCard> {
  final oCcy = NumberFormat("#,##0.00", "en_US");
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => ExpenseDetailScreen(
            expense: widget.expense,
          ),
        );
      },
      child: Card(
        elevation: 3.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    backgroundColor: Color(0xff57C8FB),
                    child: Text(
                      "₵",
                      style: TextStyle(fontSize: 25.0, color: Colors.white),
                    ),
                    radius: 30.0,
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 150,
                        child: Text(
                          widget.expense.type,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 19.0,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff57C8FB),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          widget.expense.date.substring(0, 16),
                          style: TextStyle(
                              fontSize: 12.0, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.expense.type == "Salary"
                      ? Text(
                          '₵${oCcy.format(widget.expense.cost)}',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.greenAccent,
                          ),
                        )
                      : Text(
                          '-₵${oCcy.format(widget.expense.cost)}',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.redAccent,
                          ),
                        ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      '₵${oCcy.format(widget.expense.balance)}',
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 12.0, fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
