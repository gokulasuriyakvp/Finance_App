import 'package:flutter/material.dart';
import 'package:fluttter_finance_app/loan_database_helper.dart';
import 'package:fluttter_finance_app/loan_list_screen.dart';
import 'package:fluttter_finance_app/loan_model.dart';
import 'package:fluttter_finance_app/main.dart';
import 'package:intl/intl.dart';

class OptimizedLoanFormScreen extends StatefulWidget {
  const OptimizedLoanFormScreen({super.key});

  @override
  State<OptimizedLoanFormScreen> createState() =>
      _OptimizedLoanFormScreenState();
}

class _OptimizedLoanFormScreenState extends State<OptimizedLoanFormScreen> {
  var _enterDateController = TextEditingController();
  var _enterSourcerController = TextEditingController();
  var _enterAmountController = TextEditingController();

  String selectedCategory = 'Fixed';

  var _selectedMonth;

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

      final loanDetail = ModalRoute.of(context)!.settings.arguments;
      if (loanDetail == null) {
        print('------------>FAB: Insert/Add:');
      } else {
        print('----------->ListView: Received:Edit/Delete');
        loanDetail as LoanModel;

        print('------------>Received Data');
        print(loanDetail.id);
        print(loanDetail.selectMonth);
        print(loanDetail.enterDate);
        print(loanDetail.enterSource);
        print(loanDetail.enterAmount);
        print(loanDetail.Category);

        _selectedId = loanDetail.id!;
        buttonText = 'Update';

        _enterDateController.text = loanDetail.enterDate;
        _enterSourcerController.text = loanDetail.enterSource;
        _enterAmountController.text = loanDetail.enterAmount;

        //Radio button - Priority
        if (loanDetail.Category == 'Fixed') {
          selectedCategory = 'Fixed';
        } else {
          selectedCategory = 'Variable';
        }
      }
    }
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'New Loan',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.teal,
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
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: DropdownButton(
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
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
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
                padding: EdgeInsets.symmetric(horizontal:25, vertical:20),
                child: TextFormField(
                  controller: _enterSourcerController,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter Source',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal:25, vertical: 20),
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
                  Expanded(
                    child: RadioListTile(
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
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.pink.shade200,
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
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
    print('----------------> Select Month: $_selectedMonth');
    print('----------------> Enter Date: ${_enterDateController.text}');
    print('---------------> Enter Source: ${_enterSourcerController.text}');
    print('-------------> Enter Amount: ${_enterAmountController.text}');
    print('-------------> Category: $selectedCategory');

    Map<String, dynamic> row = {
      DatabaseHelper.colSelectMonth: _selectedMonth,
      DatabaseHelper.colEnterDate: _enterDateController.text,
      DatabaseHelper.colEnterSource: _enterSourcerController.text,
      DatabaseHelper.colEnterAmount: _enterAmountController.text,
      DatabaseHelper.colCategory: selectedCategory,
    };

    final result =
        await dbHelper.insertloanDetails(row, DatabaseHelper.loanDetailsTable);

    debugPrint('--------> Inserted Row Id: $result');

    if (result > 0) {
      Navigator.pop(context);
      _showSuccessSnackBar(context, 'Saved');
    }
    setState(() {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoanListScreen()));
    });
  }

  void _update() async {
    print('--------------> _update');

    print('----------------------> Selected Id:$_selectedId');
    print('----------------------> Select Month:$_selectedMonth');
    print('----------------> Enter Date: ${_enterDateController.text}');
    print('--------------->  Enter Source: ${_enterSourcerController.text}');
    print('-------------> Enter Amount: ${_enterAmountController.text}');
    print('-------------> Category: $selectedCategory');

    Map<String, dynamic> row = {
      DatabaseHelper.colId: _selectedId,
      DatabaseHelper.colSelectMonth: _selectedMonth,
      DatabaseHelper.colEnterDate: _enterDateController.text,
      DatabaseHelper.colEnterSource: _enterSourcerController.text,
      DatabaseHelper.colEnterAmount: _enterAmountController.text,
      DatabaseHelper.colCategory: selectedCategory,
    };

    final result =
        await dbHelper.updateloanDetails(row, DatabaseHelper.loanDetailsTable);

    debugPrint('--------> update Row Id: $result');

    if (result > 0) {
      Navigator.pop(context);
      _showSuccessSnackBar(context, 'update');
    }

    setState(() {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoanListScreen()));
    });
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(new SnackBar(content: new Text(message)));
  }

  void _delete() async {
    print('--------------> _delete');

    final result = await dbHelper.deleteloanDetails(
        _selectedId, DatabaseHelper.loanDetailsTable);

    debugPrint('-----------------> Deleted Row Id: $result');

    if (result > 0) {
      _showSuccessSnackBar(context, 'Deleted.');
      Navigator.pop(context);
    }

    setState(() {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoanListScreen()));
    });
  }
}
