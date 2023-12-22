import 'package:flutter/material.dart';
import 'package:fluttter_finance_app/loan_database_helper.dart';
import 'package:fluttter_finance_app/loan_list_screen.dart';
import 'package:fluttter_finance_app/loan_model.dart';
import 'package:fluttter_finance_app/main.dart';
import 'package:intl/intl.dart';

class EditLoanFormScreen extends StatefulWidget {
  const EditLoanFormScreen({super.key});

  @override
  State<EditLoanFormScreen> createState() => _EditLoanFormScreenState();
}

class _EditLoanFormScreenState extends State<EditLoanFormScreen> {
  var _enterDateController = TextEditingController();
  var _enterSourcerController = TextEditingController();
  var _enterAmountController = TextEditingController();

  String selectedCategory = 'Fixed';
  var _selectedMonth;


  DateTime _dateTime = DateTime.now();
  bool firstTimeFlag = false;
  int _selectedId = 0;

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

      final loanDetail =
          ModalRoute.of(context)!.settings.arguments as LoanModel;

      print('------------>Received Data');
      print(loanDetail.id);
      print(loanDetail.selectMonth);
      print(loanDetail.enterDate);
      print(loanDetail.enterSource);
      print(loanDetail.enterAmount);

      _selectedId = loanDetail.id!;

      _enterDateController.text = loanDetail.enterDate;
      _enterSourcerController.text = loanDetail.enterSource;
      _enterAmountController.text = loanDetail.enterAmount;
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
        ],
      ),
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
                  RadioListTile(
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
                  RadioListTile(
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
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  print('---------> Update Button Clicked');
                  _Update();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.deepPurple,
                ),
                child: const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 60.0, vertical: 20.0),
                  child: Text('Update'),
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

  void _Update() async {
    print('--------------> _Update');

    print('------------> Select ID:$_selectedId');
    print('----------------> Select Month: $_selectedMonth');
    print('----------------> Enter Date: ${_enterDateController.text}');
    print('---------------> Enter Source: ${_enterSourcerController.text}');
    print('-------------> Enter Amount: ${_enterAmountController.text}');
    print('-------------> Category: $selectedCategory');


    Map<String, dynamic> row = {
      DatabaseHelper.colId: _selectedId,
      DatabaseHelper.colSelectMonth: _selectedMonth,
      DatabaseHelper.colEnterDate: _enterSourcerController.text,
      DatabaseHelper.colEnterSource: _enterSourcerController.text,
      DatabaseHelper.colEnterAmount: _enterAmountController.text,
      DatabaseHelper.colCategory: selectedCategory,

    };

    final result =
        await dbHelper.updateloanDetails(row, DatabaseHelper.loanDetailsTable);

    debugPrint('--------> Updated Row Id: $result');

    if (result > 0) {
      Navigator.pop(context);
      _showSuccessSnackBar(context, 'Updated');
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
    print('---------> delete');
    final result = await dbHelper.deleteloanDetails(
        _selectedId, DatabaseHelper.loanDetailsTable);

    debugPrint('---------------> Deleted Row Id:$result');

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
