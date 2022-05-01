import 'dart:io';

import 'package:expenses_tracker/models/expense.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';

class PdfModel {
  static Future<File> generateTable(List<Expense> expenses) async {
    final pdf = Document();

    final headers = ['id', 'type', 'Cost', "date", "Balance"];

    final data = expenses
        .map((expense) => [
              expense.id,
              expense.type,
              expense.type.toLowerCase() == "salary"
                  ? expense.cost.toStringAsFixed(2)
                  : "-${expense.cost.toStringAsFixed(2)}",
              expense.date.substring(0, 16),
              expense.balance.toStringAsFixed(2)
            ])
        .toList();
    pdf.addPage(Page(
      build: (context) => Table.fromTextArray(
        headers: headers,
        data: data,
      ),
    ));

    return saveDocument(name: 'my_expenses.pdf', pdf: pdf);
  }

  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }
}
