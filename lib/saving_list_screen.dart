import 'package:flutter/material.dart';
import 'package:fluttter_finance_app/drawer_navigation.dart';
import 'package:fluttter_finance_app/main.dart';
import 'package:fluttter_finance_app/optimized_saving_form_screen.dart';
import 'package:fluttter_finance_app/saving_data_base_helper.dart';
import 'package:fluttter_finance_app/saving_model.dart';

class SavingListScreen extends StatefulWidget {
  const SavingListScreen({super.key});

  @override
  State<SavingListScreen> createState() => _SavingListScreenState();
}

class _SavingListScreenState extends State<SavingListScreen> {
  var _selectedMonth;
  late List<SavingModel> _savingDetailsList = <SavingModel>[];
  @override
  void initState() {
    super.initState();
    getAllSavingDetails();
  }

  getAllSavingDetails() async {
    var savingDetailsRecords =
    await dbHelperSaving.queryAllRows(SavingDatabaseHelper.savingDetialsTable);

    savingDetailsRecords.forEach((savingDetail) {
      setState(() {
        print(savingDetail['_id']);
        print(savingDetail['_enterDate']);
        print(savingDetail['_enterSource']);
        print(savingDetail['_enterAmount']);
        print(savingDetail['_category']);

        var savingModel = SavingModel(
            savingDetail['_id'],
            savingDetail['_enterDate'],
            savingDetail['_enterSource'],
            savingDetail['_enterAmount'],
            savingDetail['_category']);

        _savingDetailsList.add(savingModel);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerNavigation(),
      appBar: AppBar(
        title: Text(
          'Saving',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => OptimizedSavingFormScreen()));
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
                itemCount: _savingDetailsList.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      print('---------->Edit or Delete Invoked: send Data');

                      print(_savingDetailsList[index].id);
                      print(_savingDetailsList[index].enterDate);
                      print(_savingDetailsList[index].enterSource);
                      print(_savingDetailsList[index].enterAmount);

                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => OptimizedSavingFormScreen(),
                        settings: RouteSettings(
                          arguments: _savingDetailsList[index],
                        ),
                      ));
                    },
                    child: ListTile(
                      title: Text(_savingDetailsList[index].enterDate),
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
