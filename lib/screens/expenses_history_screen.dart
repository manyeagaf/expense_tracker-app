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
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Expenses"),
          actions: [
            IconButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AddExpenseScreen(),
                );
              },
              icon: const Icon(Icons.add),
              iconSize: 40.0,
            ),
          ],
          elevation: 0.0,
          backgroundColor: const Color(0xff57C8FB),
          bottom: TabBar(tabs: [
            Tab(
              text: "List View",
            ),
            Tab(
              text: "Table View",
            )
          ]),
        ),
        body: TabBarView(
          children: [
            ExpenseList(),
            Gerd(),
          ],
        ),
      ),
    );
  }
}


// Consumer<DBHelper>(builder: (context, value, child) {
//             return Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               // crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "This Month : -₵${oCcy.format(value.thisMonth)}",
//                   style: TextStyle(
//                       overflow: TextOverflow.ellipsis,
//                       fontSize: 15.0,
//                       color: Colors.redAccent,
//                       fontWeight: FontWeight.w700),
//                 ),
//                 SizedBox(
//                   height: 10.0,
//                 ),
//                 Text(
//                   "Total Expenses : -₵${oCcy.format(value.totalExpenses)}",
//                   style: TextStyle(
//                       overflow: TextOverflow.ellipsis,
//                       fontSize: 15.0,
//                       color: Colors.redAccent,
//                       fontWeight: FontWeight.w700),
//                 ),
//                 SizedBox(
//                   height: 10.0,
//                 ),
//               ],
//             );
//           }),
