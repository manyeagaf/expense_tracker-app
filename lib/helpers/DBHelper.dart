// ignore_for_file: unused_local_variable

import 'package:expenses_tracker/models/expense.dart';
import 'package:expenses_tracker/services/database_services.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper with ChangeNotifier {
  // bool _fetching = false;
  // bool get fetching => _fetching;
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
  final DatabaseService _dbService = DatabaseService();
  DatabaseService get dbService => _dbService;

  int _lengthOfExpenses = 0;
  int get lengthOfExpenses => _lengthOfExpenses;

  Future<void> getExpenses() async {
    _error = true;
    _expensesList = await _dbService.expenses();

    _salaryList = await _dbService.salrary();
    _salary = _salaryList[0].amount;

    try {
      _totalExpenses = 0;
      _thisMonth = 0;
      _expensesList.forEach((expense) {
        if (expense.type.toLowerCase() != 'salary') {
          _totalExpenses = _totalExpenses + expense.cost;
          final expenseDate = expense.date.split('-');
          final dateNow = DateTime.now().toIso8601String().split("-");
          if (expenseDate[0] == dateNow[0] && expenseDate[1] == dateNow[1]) {
            _thisMonth = _thisMonth + expense.cost;
          }
        }
        _lengthOfExpenses = _expensesList.length;
      });
    } catch (e) {
      _error = true;
      _errorMessage = e.toString();
      print(_errorMessage);
    }
    _error = false;
    notifyListeners();
  }

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

  Future<void> clearData() async {
    try {
      await _dbService.clearDb();
    } catch (e) {
      _error = true;
      _errorMessage = e.toString();
    }
  }
}
