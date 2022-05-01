// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:expenses_tracker/helpers/DBHelper.dart';
import 'package:expenses_tracker/models/expense.dart';
import 'package:expenses_tracker/models/pdf_model.dart';
import 'package:expenses_tracker/screens/add_expense_screen.dart';
import 'package:expenses_tracker/screens/expenses_history_screen.dart';
import 'package:expenses_tracker/screens/salary_update_screen.dart';
import 'package:expenses_tracker/widgets/expense_card.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

enum MenuItem { updateBalance, generatePDF, expesnseHistory, clearData }

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  _buildLastFiveExpenses(List<Expense> expenses) {
    List<ExpenseCard> expensesList = [];

    int len = expenses.length >= 5 ? 5 : expenses.length;
    for (int i = 0; i < len; i++) {
      expensesList.add(ExpenseCard(
        expense: expenses[i],
      ));
    }
    return Column(
      children: expensesList,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  final oCcy = NumberFormat("#,##0.00", "en_US");

  @override
  Widget build(BuildContext context) {
    // Provider.of<DBHelper>(context, listen: false).init();
    // context.read<DBHelper>().getExpenses();
    context.read<DBHelper>().getExpenses();
    return Scaffold(
      appBar: AppBar(
        leading: PopupMenuButton(
            onSelected: (value) async {
              if (value == MenuItem.updateBalance) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SalaryUpdateScreen(),
                  ),
                );
              } else if (value == MenuItem.expesnseHistory) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ExpesnsesHistory(),
                  ),
                );
              } else if (value == MenuItem.generatePDF) {
                final pdfFile = await PdfModel.generateTable(
                    Provider.of<DBHelper>(context, listen: false).expensesList);
                PdfModel.openFile(pdfFile);
              } else {
                await Provider.of<DBHelper>(context, listen: false).clearData();

                SystemNavigator.pop();
              }
            },
            icon: Icon(Icons.menu),
            itemBuilder: (context) => <PopupMenuEntry<MenuItem>>[
                  const PopupMenuItem<MenuItem>(
                    value: MenuItem.updateBalance,
                    child: Text('Update Balance'),
                  ),
                  const PopupMenuItem<MenuItem>(
                    value: MenuItem.expesnseHistory,
                    child: Text('Spending History'),
                  ),
                  const PopupMenuItem<MenuItem>(
                    value: MenuItem.generatePDF,
                    child: Text('Generate pdf'),
                  ),
                  const PopupMenuItem<MenuItem>(
                    value: MenuItem.clearData,
                    child: Text('Clear Data'),
                  ),
                ]),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: const Color(0xff57C8FB),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.25,
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 10.0, left: 15.0),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.16,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15.0),
                        bottomRight: Radius.circular(15.0),
                      ),
                      color: Color(0xff57C8FB),
                    ),
                    child: Text(
                      "My Expenses",
                      style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 10),
                            color: Color(0xff57C8FB).withOpacity(0.23),
                            blurRadius: 50,
                          )
                        ],
                      ),
                      height: 125.0,
                      margin: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Consumer<DBHelper>(
                        builder: (context, value, child) {
                          return value.error == true
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 10.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            textBaseline:
                                                TextBaseline.alphabetic,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.baseline,
                                            children: [
                                              Text(
                                                "₵${oCcy.format(value.salary - value.thisMonth)}",
                                                style: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontSize: 35.0,
                                                  color: Color(0xff57C8FB),
                                                ),
                                              ),
                                              Text(
                                                "-₵${oCcy.format(value.todayExpenses)} today",
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.redAccent,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "-₵${oCcy.format(value.thisMonth)}",
                                                  style: TextStyle(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    fontSize: 18.0,
                                                    color: Color(0xff57C8FB),
                                                  ),
                                                ),
                                                Text(
                                                  "Current month",
                                                  style: TextStyle(
                                                    fontSize: 13.0,
                                                    color: Color(0xff57C8FB),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "₵${oCcy.format(value.salary)}",
                                                  style: TextStyle(
                                                    fontSize: 18.0,
                                                    color: Color(0xff57C8FB),
                                                  ),
                                                ),
                                                Text(
                                                  "Initial amount",
                                                  style: TextStyle(
                                                    fontSize: 13.0,
                                                    color: Color(0xff57C8FB),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "-₵${oCcy.format(value.totalExpenses)}",
                                                  style: TextStyle(
                                                    fontSize: 18.0,
                                                    color: Color(0xff57C8FB),
                                                  ),
                                                ),
                                                Text(
                                                  "Total spending",
                                                  style: TextStyle(
                                                    fontSize: 13.0,
                                                    color: Color(0xff57C8FB),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            SizedBox(
              height: 8.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 13.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recent Spending",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ExpesnsesHistory(),
                        ),
                      );
                    },
                    child: Text(
                      "See More...",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Color(0xff57C8FB),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 15.0),
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Column(
                children: [
                  Consumer<DBHelper>(
                    builder: (context, value, child) {
                      return value.error == true
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : _buildLastFiveExpenses(
                              value.expensesList,
                            );
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff57C8FB),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => AddExpenseScreen(),
          );
        },
        child: Icon(
          Icons.add,
          size: 40.0,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
