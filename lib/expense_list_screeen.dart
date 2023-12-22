import 'package:flutter/material.dart';
import 'package:fluttter_finance_app/expense_data_base_helper.dart';
import 'package:fluttter_finance_app/drawer_navigation.dart';
import 'package:fluttter_finance_app/expense_model.dart';
import 'package:fluttter_finance_app/main.dart';
import 'package:fluttter_finance_app/optimized_expense_form_screen.dart';

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  State<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  var _selectedMonth;
  late List<ExpenseModel> _expenseDetailsList = <ExpenseModel>[];
  @override
  void initState() {
    super.initState();
    getAllExpenseDetails();
  }

  getAllExpenseDetails() async {
    var expenseDetailsRecords =
    await dbHelperExpense.queryAllRows(ExpenseDatabaseHelper.expenseDetialsTable);

    expenseDetailsRecords.forEach((expenseDetail) {
      setState(() {
        print(expenseDetail['_id']);
        print(expenseDetail['_enterDate']);
        print(expenseDetail['_enterSource']);
        print(expenseDetail['_enterAmount']);
        print(expenseDetail['_category']);

        var expenseModel = ExpenseModel(
            expenseDetail['_id'],
            expenseDetail['_enterDate'],
            expenseDetail['_enterSource'],
            expenseDetail['_enterAmount'],
            expenseDetail['_category']);

        _expenseDetailsList.add(expenseModel);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerNavigation(),
      appBar: AppBar(
        title: Text(
          'Expense',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => OptimizedExpenseFormScreen()));
            },
            icon: Icon(Icons.add),
          ),
        ],
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DropdownButton(
                value: _selectedMonth,
                hint: Text('Select Month'),
                items: <String>[
                  'January',
                  'February',
                  'March',
                  'April',
                  'May',
                  'June',
                  'July',
                  'August',
                  'September',
                  'October',
                  'November',
                  'December'
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(
                        () {
                      _selectedMonth = value;
                    },
                  );
                },
              ),
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: _expenseDetailsList.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      print('---------->Edit or Delete Invoked: send Data');

                      print(_expenseDetailsList[index].id);
                      print(_expenseDetailsList[index].enterDate);
                      print(_expenseDetailsList[index].enterSource);
                      print(_expenseDetailsList[index].enterAmount);

                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => OptimizedExpenseFormScreen(),
                        settings: RouteSettings(
                          arguments: _expenseDetailsList[index],
                        ),
                      ));
                    },
                    child: ListTile(
                      title: Text(_expenseDetailsList[index].enterDate),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
