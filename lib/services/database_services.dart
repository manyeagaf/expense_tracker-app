// ignore_for_file: prefer_const_constructors

import 'package:expenses_tracker/models/expense.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  // Singleton pattern
  static final DatabaseService _databaseService = DatabaseService._internal();
  factory DatabaseService() => _databaseService;
  DatabaseService._internal();
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // Initialize the DB first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();

    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    final path = join(databasePath, 'expense_database.db');

    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    return await openDatabase(path, onCreate: _onCreate, version: 1);
  }

  // When the database is first created, create a table to store breeds
// and a table to store dogs.
  Future<void> _onCreate(Database db, int version) async {
    // Run the CREATE {breeds} TABLE statement on the database.
    await db.execute(
      'CREATE TABLE expenses(id INTEGER PRIMARY KEY, type TEXT, cost INTEGER,date TEXT,balance INTEGER)',
    );
    // Run the CREATE {dogs} TABLE statement on the database.
    await db.execute(
      'CREATE TABLE salary(id INTEGER PRIMARY KEY,amount INTEGER)',
    );

    await db.execute(
      'CREATE TABLE user(id INTEGER PRIMARY KEY,name TEXT)',
    );

    final expense = Expense(
        id: 0,
        cost: 0,
        type: "Nothing",
        date: DateTime.now().toString(),
        balance: 0);
    db.insert("expenses", expense.toMap());

    final salary = Salary(id: 0, amount: 100000);
    db.insert("salary", salary.toMap());
  }

  // Define a function that inserts breeds into the database
  Future<void> insertExpense(Expense expense) async {
    // Get a reference to the database.
    final db = await _databaseService.database;

    // Insert the Breed into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same breed is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'expenses',
      expense.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertSalary(Salary salary) async {
    // Get a reference to the database.
    final db = await _databaseService.database;

    // Insert the Breed into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same breed is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'salary',
      salary.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Expense>> expenses() async {
    // Get a reference to the database.
    final db = await _databaseService.database;

    // Query the table for all the Breeds.
    final List<Map<String, dynamic>> maps =
        await db.query('expenses', orderBy: "id DESC");

    // Convert the List<Map<String, dynamic> into a List<Expenses>.
    return List.generate(maps.length, (i) {
      return Expense(
          id: maps[i]['id'],
          type: maps[i]['type'],
          cost: maps[i]['cost'],
          date: maps[i]['date'],
          balance: maps[i]['balance']);
    });
  }

  Future<List<Salary>> salrary() async {
    // Get a reference to the database.
    final db = await _databaseService.database;

    // Query the table for all the Breeds.
    final List<Map<String, dynamic>> maps = await db.query('salary');

    // Convert the List<Map<String, dynamic> into a List<Breed>.
    return List.generate(maps.length, (i) {
      return Salary(
        id: maps[i]['id'],
        amount: maps[i]['amount'],
      );
    });
  }

  Future<void> updateExpense(Expense expense) async {
    // Get a reference to the database.
    final db = await _databaseService.database;

    // Update the given breed
    await db.update(
      'expenses',
      expense.toMap(),
      // Ensure that the Breed has a matching id.
      where: 'id = ?',
      // Pass the Breed's id as a whereArg to prevent SQL injection.
      whereArgs: [expense.id],
    );
  }

  Future<void> updateSalary(Salary salary) async {
    // Get a reference to the database.
    final db = await _databaseService.database;

    // Update the given breed
    await db.update(
      'salary',
      salary.toMap(),
      // Ensure that the Breed has a matching id.
      where: 'id = ?',
      // Pass the Breed's id as a whereArg to prevent SQL injection.
      whereArgs: [salary.id],
    );
  }

  Future<void> deleteExpense(int id) async {
    // Get a reference to the database.
    final db = await _databaseService.database;

    // Remove the Breed from the database.
    await db.delete(
      'expenses',
      // Use a `where` clause to delete a specific breed.
      where: 'id = ?',
      // Pass the Breed's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  Future<void> clearDb() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'expense_database.db');
    await deleteDatabase(path);
  }
}
