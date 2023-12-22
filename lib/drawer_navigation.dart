import 'package:flutter/material.dart';
import 'package:fluttter_finance_app/expense_list_screeen.dart';
import 'package:fluttter_finance_app/finance_rules.dart';
import 'package:fluttter_finance_app/loan_list_screen.dart';
import 'package:fluttter_finance_app/saving_list_screen.dart';

class DrawerNavigation extends StatefulWidget {
  const DrawerNavigation({Key? key}) : super(key: key);

  @override
  State<DrawerNavigation> createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: ListView(
          children: <Widget>[
            const UserAccountsDrawerHeader(
              accountName: Text('Finance',
              style: TextStyle(
                fontSize: 20,
              ),),
              accountEmail: Text('Version 1.0',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                radius: 50.0,
                backgroundImage: AssetImage('images/icon.jpeg'
                    ''),
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/backgroundimage.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            ListTile(
              title: const Text('Finance Rules',
                style:TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => FinanceRules()));
              },
            ),
           ListTile(
              title: const Text('Loan',
                style:TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoanListScreen()));
              },
            ),
            ListTile(
                title: const Text('Saving',
                  style:TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => SavingListScreen()));
                }
            ),
            ListTile(
              title: Text(
                'Expense',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => ExpenseListScreen()));
              },
            ),

          ],
        ),
      ),
    );
  }
}
