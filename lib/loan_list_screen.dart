import 'package:flutter/material.dart';
import 'package:fluttter_finance_app/loan_database_helper.dart';
import 'package:fluttter_finance_app/drawer_navigation.dart';
import 'package:fluttter_finance_app/loan_model.dart';
import 'package:fluttter_finance_app/main.dart';
import 'package:fluttter_finance_app/optimized_loan_form_screen.dart';

class LoanListScreen extends StatefulWidget {
  const LoanListScreen({super.key});

  @override
  State<LoanListScreen> createState() => _LoanListScreenState();
}

class _LoanListScreenState extends State<LoanListScreen> {
  var _selectedMonth;
  late List<LoanModel> _loanDetailsList = <LoanModel>[];
  @override
  void initState() {
    super.initState();
    getAllLoanDetails();
  }

  getAllLoanDetails() async {
    var loanDetailsRecords =
        await dbHelper.queryAllRows(DatabaseHelper.loanDetailsTable);

    loanDetailsRecords.forEach((loanDetail) {
      setState(() {
        print(loanDetail['_id']);
        print(loanDetail['_selectMonth']);
        print(loanDetail['_enterDate']);
        print(loanDetail['_enterSource']);
        print(loanDetail['_enterAmount']);
        print(loanDetail['_category']);

        var loanModel = LoanModel(
            loanDetail['_id'],
            loanDetail['_selectMonth'],
            loanDetail['_enterDate'],
            loanDetail['_enterSource'],
            loanDetail['_enterAmount'],
            loanDetail['_category']);

        _loanDetailsList.add(loanModel);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerNavigation(),
      appBar: AppBar(
        title: Text(
          'Loan',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => OptimizedLoanFormScreen()));
            },
            icon: Icon(Icons.add),
          ),
        ],
        backgroundColor: Colors.teal,
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
                itemCount: _loanDetailsList.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      print('---------->Edit or Delete Invoked: send Data');

                      print(_loanDetailsList[index].id);
                      print(_loanDetailsList[index].selectMonth);
                      print(_loanDetailsList[index].enterDate);
                      print(_loanDetailsList[index].enterSource);
                      print(_loanDetailsList[index].enterAmount);

                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => OptimizedLoanFormScreen(),
                        settings: RouteSettings(
                          arguments: _loanDetailsList[index],
                        ),
                      ));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: Colors.pink.shade100,
                      child: ListTile(
                        leading: Icon(Icons.arrow_back, color: Colors.black),
                        title: Text(
                          _loanDetailsList[index].enterSource,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          _loanDetailsList[index].enterDate,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        trailing: Text(
                          _loanDetailsList[index].enterAmount,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 25),
                        selectedColor: Colors.blue,
                      ),
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
