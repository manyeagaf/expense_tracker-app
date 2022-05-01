// ignore_for_file: unused_local_variable

import 'package:expenses_tracker/models/expense.dart';
import 'package:expenses_tracker/services/database_services.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper with ChangeNotifier {
  List<Expense> _expensesList = [];
  int _salary = 0;
  int get salary => _salary;
  List<Expense> get expensesList => _expensesList;
  bool _error = false;
  bool get error => _error;
  String _errorMessage = '';
  String get errorMessage => _errorMessage;
  int _totalExpenses = 0;
  int get totalExpenses => _totalExpenses;
  List<Salary> _salaryList = [];
  int _thisMonth = 0;
  int get thisMonth => _thisMonth;

  int _lastExpenseId = 0;

  int get lastExpenseId => _lastExpenseId;

  double _todayExpenses = 0;

  double get todayExpenses => _todayExpenses;
  //Declare our database instance
  final DatabaseService _dbService = DatabaseService();
  DatabaseService get dbService => _dbService;

  //Fetch the list of expenses from our db and do all the neccessary calculations
  Future<void> getExpenses() async {
    _error = true;
    _expensesList = await _dbService.expenses();

    _salaryList = await _dbService.salrary();
    _salary = _salaryList[0].amount;
    _lastExpenseId = _expensesList[0].id;

    try {
      _totalExpenses = 0;
      _thisMonth = 0;
      _todayExpenses = 0;
      _expensesList.forEach((expense) {
        if (expense.type.toLowerCase() != 'salary') {
          _totalExpenses = _totalExpenses + expense.cost;
          final expenseDate = expense.date;
          final dateNow = DateTime.now().toString();

          if (expense.date.substring(0, 7) == dateNow.substring(0, 7)) {
            _thisMonth = _thisMonth + expense.cost;
          }
          if (expense.date.substring(0, 10) == dateNow.substring(0, 10)) {
            _todayExpenses = _todayExpenses + expense.cost;
          }
        }
      });
    } catch (e) {
      _error = true;
      _errorMessage = e.toString();
    }
    _error = false;
    //Notify all the listeners
    notifyListeners();
  }

  //Perform a create operation to add expense to the database
  Future<void> addExpenses(Expense expense) async {
    try {
      await _dbService.insertExpense(expense);
      _error = false;
    } catch (e) {
      _error = true;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  //Update the salary
  Future<void> updateSalary(Salary salary) async {
    try {
      _dbService.insertSalary(salary);
      _error = false;
    } catch (e) {
      _error = true;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  //Perform an update operation to update an expense
  Future<void> updateExpense(Expense expense) async {
    try {
      await _dbService.updateExpense(expense);
    } catch (e) {
      print(e);
    }
  }

  //Delete an expense
  Future<void> deleteExpense(Expense expense) async {
    try {
      await _dbService.deleteExpense(expense.id);
    } catch (e) {
      print(e);
    }
  }

  //Clear all the data in the database
  Future<void> clearData() async {
    try {
      await _dbService.clearDb();
    } catch (e) {
      _error = true;
      _errorMessage = e.toString();
    }
  }
}
