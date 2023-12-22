import 'package:flutter/material.dart';
import 'package:fluttter_finance_app/loan_database_helper.dart';
import 'package:fluttter_finance_app/loan_list_screen.dart';
import 'package:fluttter_finance_app/main.dart';
import 'package:intl/intl.dart';

class LoanFormScreen extends StatefulWidget {
  const LoanFormScreen({super.key});

  @override
  State<LoanFormScreen> createState() => _LoanFormScreenState();
}

class _LoanFormScreenState extends State<LoanFormScreen> {

  var _enterDateController = TextEditingController();
  var _enterSourcerController = TextEditingController();
  var _enterAmountController = TextEditingController();

  String selectedCategory = 'Fixed';
  var _selectedMonth;



  DateTime _dateTime = DateTime.now();

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
                  print('---------> Add Button Clicked');
                  _Add();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.deepPurple,
                ),
                child: const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 60.0, vertical: 20.0),
                  child: Text('Add'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _Add() async {
    print('--------------> _Add');
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

    final result = await dbHelper.insertloanDetails(
        row, DatabaseHelper.loanDetailsTable);

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

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(new SnackBar(content: new Text(message)));
  }
}
