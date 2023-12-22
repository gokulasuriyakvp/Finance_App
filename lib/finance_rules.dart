import 'package:flutter/material.dart';
import 'package:fluttter_finance_app/drawer_navigation.dart';
import 'package:share_plus/share_plus.dart';



class FinanceRules extends StatefulWidget {
  const FinanceRules({super.key});

  @override
  State<FinanceRules> createState() => _FinanceRulesState();
}

class _FinanceRulesState extends State<FinanceRules> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerNavigation(),
      appBar: AppBar(
        title: Text(
          'Finance Rules',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.teal,
        actions: [
          Padding(padding: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
            child: IconButton(onPressed: sharePressed,
              iconSize: 25,
              color: Colors.black,
              icon: Icon(Icons.share_outlined),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Empowering Your Finances One Transaction at a Time.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 19,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void sharePressed(){
    String quotes ='Empowering Your Finances One Transaction at a Time.';
    Share.share(quotes);
  }
}
