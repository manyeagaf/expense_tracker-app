import 'package:expenses_tracker/helpers/DBHelper.dart';
import 'package:expenses_tracker/models/expense.dart';
import 'package:expenses_tracker/screens/expenses_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:provider/provider.dart';

class Gerd extends StatefulWidget {
  const Gerd({Key? key}) : super(key: key);

  @override
  State<Gerd> createState() => _GerdState();
}

class _GerdState extends State<Gerd> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.read<DBHelper>().getExpenses();
    return Consumer<DBHelper>(
      builder: (context, value, child) {
        final employeeDataSource =
            ExpenseDataSource(expenseData: value.expensesList);
        return value.error == true
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                child: SfDataGrid(
                  source: employeeDataSource,
                  columnWidthMode: ColumnWidthMode.fill,
                  columns: <GridColumn>[
                    GridColumn(
                        columnName: 'id',
                        label: Container(
                            padding: EdgeInsets.all(16.0),
                            alignment: Alignment.center,
                            child: Text(
                              'ID',
                            ))),
                    GridColumn(
                        columnName: 'type',
                        label: Container(
                            padding: EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text('Type'))),
                    GridColumn(
                        columnName: 'cost',
                        label: Container(
                            padding: EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text(
                              'Cost',
                              overflow: TextOverflow.ellipsis,
                            ))),
                    GridColumn(
                        columnName: 'date',
                        label: Container(
                            padding: EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text('Date'))),
                    GridColumn(
                        columnName: 'balance',
                        label: Container(
                            padding: EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text('Balance'))),
                  ],
                ),
              );
      },
    );
  }
}

class Employee {
  /// Creates the employee class with required details.
  Employee(this.id, this.name, this.designation, this.salary);

  /// Id of an employee.
  final int id;

  /// Name of an employee.
  final String name;

  /// Designation of an employee.
  final String designation;

  /// Salary of an employee.
  final int salary;
}

class ExpenseDataSource extends DataGridSource {
  /// Creates the Expense data source class with required details.
  ExpenseDataSource({required List<Expense> expenseData}) {
    _expenseData = expenseData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'id', value: e.id),
              DataGridCell<String>(columnName: 'type', value: e.type),
              DataGridCell<String>(
                  columnName: 'cost',
                  value: e.type.toLowerCase() == 'salary'
                      ? e.cost.toStringAsFixed(2)
                      : '-' + e.cost.toStringAsFixed(2)),
              DataGridCell<String>(
                  columnName: 'type', value: e.date.split("T")[0]),
              DataGridCell<String>(
                  columnName: 'salary', value: e.balance.toStringAsFixed(2)),
            ]))
        .toList();
  }

  List<DataGridRow> _expenseData = [];

  @override
  List<DataGridRow> get rows => _expenseData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        child: Text(
          e.value.toString(),
        ),
      );
    }).toList());
  }
}
