import 'package:flutter/material.dart';
import 'package:fluttter_finance_app/expense_data_base_helper.dart';
import 'package:fluttter_finance_app/loan_database_helper.dart';
import 'package:fluttter_finance_app/saving_data_base_helper.dart';
import 'package:fluttter_finance_app/splash_screen.dart';


final dbHelper = DatabaseHelper();
final dbHelperSaving = SavingDatabaseHelper();
final dbHelperExpense = ExpenseDatabaseHelper();



Future <void> main() async {
 WidgetsFlutterBinding.ensureInitialized();
  await dbHelper.initialization();
 await dbHelperSaving.initialization();
 await dbHelperExpense.initialization();

 runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}
