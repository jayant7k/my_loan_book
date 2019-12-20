import 'package:flutter/material.dart';
import '../models/loaninfo.dart';
import 'package:my_loan_book/helpers/database.dart';

class LoanDetailPage extends StatelessWidget {
  final LoanInfo loanInfo;
  LoanDetailPage({Key key, LoanInfo this.loanInfo}) : super(key : key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Column(
        children: <Widget>[
          Text('Month'),
          Text('Interest component'),
          Text('Principle component'),
          Text('Remaining principle'),
        ],
      ),
    );
  }
}