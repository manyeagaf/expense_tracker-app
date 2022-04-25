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
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ExpenseDetailScreen(expense: widget.expense)));
      },
      child: Card(
        elevation: 3.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Color(0xff57C8FB),
                child: Text(
                  "₵",
                  style: TextStyle(fontSize: 25.0, color: Colors.white),
                ),
                radius: 25.0,
              ),
              SizedBox(
                width: 8.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    height: 10.0,
                  ),
                  Text(
                    widget.expense.date.split("T")[0] +
                        " " +
                        widget.expense.date.split("T")[1].substring(0, 8),
                    style:
                        TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
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
                    height: 10.0,
                  ),
                  SizedBox(
                    child: Text(
                      '₵${oCcy.format(widget.expense.balance)}',
                      overflow: TextOverflow.ellipsis,
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
