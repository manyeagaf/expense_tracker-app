// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:expenses_tracker/helpers/DBHelper.dart';
import 'package:expenses_tracker/models/expense.dart';
import 'package:expenses_tracker/models/pdf_model.dart';
import 'package:expenses_tracker/screens/add_expense_screen.dart';
import 'package:expenses_tracker/screens/expenses_history_screen.dart';
import 'package:expenses_tracker/screens/expenses_list_screen.dart';
import 'package:expenses_tracker/screens/salary_update_screen.dart';
import 'package:expenses_tracker/widgets/expense_card.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

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

  _buildLastFiveExpenses(List<Expense> expenses, int len) {
    List<ExpenseCard> expensesList = [];
    int lengthOfExpenses = len <= 5 ? len : 5;
    for (int i = 0; i < lengthOfExpenses; i++) {
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
      drawer: Drawer(
          child: ListView(
        children: [
          ListTile(
            onTap: () {
              Navigator.pop(context);
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (_) => SalaryUpdateScreen()));
            },
            iconColor: Color(0xff57C8FB),
            textColor: Color(0xff57C8FB),
            leading: Icon(Icons.home),
            title: Text(
              "Home",
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => SalaryUpdateScreen()));
            },
            iconColor: Color(0xff57C8FB),
            textColor: Color(0xff57C8FB),
            leading: Icon(Icons.history),
            title: Text(
              "Update Salary Balance",
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          ListTile(
            iconColor: Color(0xff57C8FB),
            textColor: Color(0xff57C8FB),
            leading: Icon(Icons.history),
            title: Text(
              "Spending History",
              style: TextStyle(fontSize: 18.0),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => ExpesnsesHistory()));
            },
          ),
          ListTile(
            iconColor: Color(0xff57C8FB),
            textColor: Color(0xff57C8FB),
            leading: Icon(Icons.add),
            title: Text(
              "Spend Money",
              style: TextStyle(fontSize: 18.0),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => AddExpenseScreen()));
            },
          ),
          Consumer<DBHelper>(
            builder: (context, value, child) {
              return ListTile(
                iconColor: Color(0xff57C8FB),
                textColor: Color(0xff57C8FB),
                leading: Icon(Icons.document_scanner),
                title: Text(
                  "Generate Pdf",
                  style: TextStyle(fontSize: 18.0),
                ),
                onTap: () async {
                  final pdfFile =
                      await PdfModel.generateTable(value.expensesList);
                  PdfModel.openFile(pdfFile);
                },
              );
            },
          ),
          Consumer<DBHelper>(
            builder: (context, value, child) {
              return ListTile(
                iconColor: Color(0xff57C8FB),
                textColor: Color(0xff57C8FB),
                leading: Icon(Icons.delete),
                title: Text(
                  "Clear data",
                  style: TextStyle(fontSize: 18.0),
                ),
                onTap: () async {
                  await value.clearData();
                  await value.dbService.database;

                  SystemNavigator.pop();
                  // Navigator.push(
                  //     context, MaterialPageRoute(builder: (_) => HomeScreen()));
                },
              );
            },
          ),
        ],
      )),
      // backgroundColor: const Color(0xff57C8FB),
      appBar: AppBar(
        centerTitle: true,
        title: const Text("My Expenses"),
        elevation: 0.0,
        backgroundColor: const Color(0xff57C8FB),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: ListView(
          children: [
            SizedBox(
              height: 15.0,
            ),
            Card(
              // color: Color(0xff57C8FB),
              elevation: 7.0,
              child: Consumer<DBHelper>(
                builder: (context, value, child) {
                  return value.error == true
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //crossAxisAlignment: CrossAxisAlignment.baseline,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.ideographic,

                              children: [
                                Center(
                                  child: Text(
                                    "Summary",
                                    style: TextStyle(
                                        fontSize: 30.0,
                                        color: Color(0xff57C8FB),
                                        fontWeight: FontWeight.w800),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  "Balance : ₵${oCcy.format(value.salary - value.thisMonth)}",
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 18.0,
                                    color: Color(0xff57C8FB),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  "This Month : -₵${oCcy.format(value.thisMonth)}",
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 18.0,
                                    color: Color(0xff57C8FB),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  "Total Expenses : -₵${oCcy.format(value.totalExpenses)}",
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 18.0,
                                    color: Color(0xff57C8FB),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  "Initial Amount : ₵${oCcy.format(value.salary)}",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Color(0xff57C8FB),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                },
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
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
                              value.lengthOfExpenses,
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
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => AddExpenseScreen()));
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
