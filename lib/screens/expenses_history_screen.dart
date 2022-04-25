import 'package:expenses_tracker/helpers/DBHelper.dart';
import 'package:expenses_tracker/screens/add_expense_screen.dart';
import 'package:expenses_tracker/screens/expenses_list_screen.dart';
import 'package:expenses_tracker/screens/gerd.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ExpesnsesHistory extends StatefulWidget {
  const ExpesnsesHistory({Key? key}) : super(key: key);

  @override
  State<ExpesnsesHistory> createState() => _ExpesnsesHistoryState();
}

class _ExpesnsesHistoryState extends State<ExpesnsesHistory> {
  int view = 1;
  final oCcy = NumberFormat("#,##0.00", "en_US");
  @override
  Widget build(BuildContext context) {
    context.read<DBHelper>().getExpenses();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expenses"),
        actions: [
          IconButton(
            onPressed: () async {
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
      body: Column(
        children: [
          SizedBox(
            height: 8.0,
          ),
          Consumer<DBHelper>(builder: (context, value, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "This Month : -₵${oCcy.format(value.thisMonth)}",
                  style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: 15.0,
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  "Total Expenses : -₵${oCcy.format(value.totalExpenses)}",
                  style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: 15.0,
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 10.0,
                ),
              ],
            );
          }),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor:
                      view == 1 ? Color(0xff57C8FB) : Colors.transparent,
                ),
                onPressed: () {
                  setState(() {
                    view = 1;
                  });
                },
                child: Text(
                  "List View",
                  style: TextStyle(
                    color: view == 1 ? Colors.white : Color(0xff57C8FB),
                  ),
                ),
              ),
              TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor:
                        view == 2 ? Color(0xff57C8FB) : Colors.transparent,
                  ),
                  onPressed: () {
                    setState(() {
                      view = 2;
                    });
                  },
                  child: Text(
                    "Table View",
                    style: TextStyle(
                      color: view == 2 ? Colors.white : Color(0xff57C8FB),
                    ),
                  )),
            ],
          ),
          view == 1 ? Flexible(child: ExpenseList()) : Flexible(child: Gerd()),
        ],
      ),
    );
  }
}
