// ignore_for_file: prefer_const_constructors

import 'package:expenses_tracker/helpers/DBHelper.dart';
import 'package:expenses_tracker/models/expense.dart';
import 'package:expenses_tracker/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SalaryUpdateScreen extends StatefulWidget {
  const SalaryUpdateScreen({Key? key}) : super(key: key);

  @override
  State<SalaryUpdateScreen> createState() => _SalaryUpdateScreenState();
}

class _SalaryUpdateScreenState extends State<SalaryUpdateScreen> {
  final salaryController = TextEditingController();
  final dateController = TextEditingController()
    ..text = DateTime.now().toString();

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    salaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xff57C8FB),
        title: Text("Update Balance"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Enter Salary Amount",
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {},
                controller: salaryController,
              ),
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
                    if (salaryController.text != "") {
                      final expense = Expense(
                        id: value.lastExpenseId + 1,
                        cost: int.parse(salaryController.text),
                        type: "Salary",
                        date: DateTime.now().toString(),
                        balance: int.parse(salaryController.text),
                      );
                      final salary = Salary(
                          id: 0, amount: int.parse(salaryController.text));
                      await value.updateSalary(salary);
                      await value.addExpenses(expense);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => HomeScreen()));
                    } else {
                      final snackBar = SnackBar(
                        content:
                            const Text('Please enter updated salary amount'),
                        action: SnackBarAction(
                          label: 'Close',
                          onPressed: () {
                            // Some code to undo the change.
                          },
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: Text(
                    "Update Salary",
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
