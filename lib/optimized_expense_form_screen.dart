import 'package:flutter/material.dart';
import 'package:fluttter_finance_app/expense_data_base_helper.dart';
import 'package:fluttter_finance_app/expense_list_screeen.dart';
import 'package:fluttter_finance_app/expense_model.dart';
import 'package:fluttter_finance_app/main.dart';
import 'package:intl/intl.dart';

class OptimizedExpenseFormScreen extends StatefulWidget {
  const OptimizedExpenseFormScreen({super.key});

  @override
  State<OptimizedExpenseFormScreen> createState() => _OptimizedExpenseFormScreenState();
}

class _OptimizedExpenseFormScreenState extends State<OptimizedExpenseFormScreen> {

  var _enterDateController = TextEditingController();
  var _enterSourcerController = TextEditingController();
  var _enterAmountController = TextEditingController();

  String selectedCategory = 'Fixed';


  DateTime _dateTime = DateTime.now();
  bool firstTimeFlag = false;
  int _selectedId = 0;
  String buttonText = 'Add';

  _selectTodoDate(BuildContext context) async {
    var _pickedDate = await showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (_pickedDate != null) {
      setState(() {
        _dateTime = _pickedDate;
        _enterDateController.text = DateFormat("dd-MM-yyyy").format(_dateTime);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (firstTimeFlag == false) {
      print('------------->once execute');

      firstTimeFlag = true;

      final expenseDetail = ModalRoute.of(context)!.settings.arguments;
      if (expenseDetail == null) {
        print('------------>FAB: Insert/Add:');
      } else {
        print('----------->ListView: Received:Edit/Delete');
        expenseDetail as ExpenseModel;

        print('------------>Received Data');
        print(expenseDetail.id);
        print(expenseDetail.enterDate);
        print(expenseDetail.enterSource);
        print(expenseDetail.enterAmount);
        print(expenseDetail.Category);

        _selectedId = expenseDetail.id!;
        buttonText = 'Update';

        _enterDateController.text = expenseDetail.enterDate;
        _enterSourcerController.text = expenseDetail.enterSource;
        _enterAmountController.text = expenseDetail.enterAmount;

        //Radio button - Priority
        if (expenseDetail.Category == 'Fixed') {
          selectedCategory = 'Fixed';
        } else {
          selectedCategory = 'Variable';
        }
      }
    }
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'New Expense',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.red,
          actions: [
            PopupMenuButton<int>(
              itemBuilder: (context) => [
                PopupMenuItem(value: 1, child: Text("Delete")),
              ],
              elevation: 2,
              onSelected: (value) {
                if (value == 1) {
                  print('Delete option clicked');
                  _deleteFormDialog(context);
                }
              },
            ),
          ]),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextField(
                  controller: _enterDateController,
                  decoration: InputDecoration(
                    labelText: 'Select Date',
                    prefixIcon: InkWell(
                      onTap: () {
                        _selectTodoDate(context);
                      },
                      child: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  controller: _enterSourcerController,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter Source',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  controller: _enterAmountController,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter Amount',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: Text(
                  'Category',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile(
                        title: Text(
                          'Fixed',
                          style: TextStyle(fontSize: 18),
                        ),
                        value: 'Fixed',
                        groupValue: selectedCategory,
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value as String;
                            print('------> Category: $value');
                          });
                        }),
                  ),
                  Expanded(child:RadioListTile(
                      title: Text(
                        'Variable',
                        style: TextStyle(fontSize: 18),
                      ),
                      value: 'Variable',
                      groupValue: selectedCategory,
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value as String;
                          print('------> Category: $value');
                        });
                      }),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  print('--------->Button Clicked');
                  if (_selectedId == 0) {
                    print('-------------> Add');
                    _add();
                  } else {
                    print('----------> update');
                    _update();
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.deepPurple,
                ),
                child: Padding(
                  padding:
                  EdgeInsets.symmetric(horizontal: 60.0, vertical: 20.0),
                  child: Text(buttonText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _deleteFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  print('----------> Cancel Button Clicked');
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  print('-------------> Delete Button Clicked');
                  _delete();
                },
                child: const Text('Delete'),
              )
            ],
            title: const Text('Are you sure you want to delete this'),
          );
        });
  }

  void _add() async {
    print('--------------> _add');
    print('----------------> Enter Date: ${_enterDateController.text}');
    print('---------------> Enter Source: ${_enterSourcerController.text}');
    print('-------------> Enter Amount: ${_enterAmountController.text}');
    print('-------------> Category: $selectedCategory');


    Map<String, dynamic> row = {
      ExpenseDatabaseHelper.colEnterDate: _enterDateController.text,
      ExpenseDatabaseHelper.colEnterSource: _enterSourcerController.text,
      ExpenseDatabaseHelper.colEnterAmount: _enterAmountController.text,
      ExpenseDatabaseHelper.colCategory: selectedCategory,

    };

    final result =
    await dbHelperExpense.insertexpenseDetails(row, ExpenseDatabaseHelper.expenseDetialsTable);

    debugPrint('--------> Inserted Row Id: $result');

    if (result > 0) {
      Navigator.pop(context);
      _showSuccessSnackBar(context, 'Saved');
    }
    setState(() {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ExpenseListScreen()));
    });
  }

  void _update() async {
    print('--------------> _update');

    print('----------------------> Selected Id:$_selectedId');
    print('----------------> Enter Date: ${_enterDateController.text}');
    print('--------------->  Enter Source: ${_enterSourcerController.text}');
    print('-------------> Enter Amount: ${_enterAmountController.text}');
    print('-------------> Category: $selectedCategory');


    Map<String, dynamic> row = {
      ExpenseDatabaseHelper.colId: _selectedId,
      ExpenseDatabaseHelper.colEnterDate: _enterDateController.text,
      ExpenseDatabaseHelper.colEnterSource: _enterSourcerController.text,
      ExpenseDatabaseHelper.colEnterAmount: _enterAmountController.text,
      ExpenseDatabaseHelper.colCategory: selectedCategory,

    };

    final result =
    await dbHelperExpense.updateexpenseDetails(row, ExpenseDatabaseHelper.expenseDetialsTable);

    debugPrint('--------> update Row Id: $result');

    if (result > 0) {
      Navigator.pop(context);
      _showSuccessSnackBar(context, 'update');
    }

    setState(() {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ExpenseListScreen()));
    });
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(new SnackBar(content: new Text(message)));
  }

  void _delete() async {
    print('--------------> _delete');

    final result = await dbHelperExpense.deleteexpenseDetails(
        _selectedId, ExpenseDatabaseHelper.expenseDetialsTable);

    debugPrint('-----------------> Deleted Row Id: $result');

    if (result > 0) {
      _showSuccessSnackBar(context, 'Deleted.');
      Navigator.pop(context);
    }

    setState(() {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ExpenseListScreen()));
    });
  }
}
