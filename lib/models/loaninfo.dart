import 'dart:math';

import 'package:my_loan_book/helpers/database.dart';

class LoanInfo{
  num loanId = 1;
  String loanName = 'home loan';
  num principal = 1000000;
  num interest = 8.5;
  DateTime startDate = DateTime.now();
  num tenure = 10;
  num emi = 0;

  static final shortColumns = [DatabaseHelper.loanInfoLoanId, DatabaseHelper.loanInfoLoanName, DatabaseHelper.loanInfoLoanEMI, DatabaseHelper.loanInfoLoanPrincipal];

  LoanInfo(){
    this.loanId = 1;
    this.loanName = 'car loan';
    this.principal = 800000;
    this.interest = 9.7;
    this.startDate = DateTime.now();
    this.tenure = 10;
    this.emi = calculateEmi(this.principal, this.interest, this.tenure);
  }
  num calculateEmi(num p, num r, num t){
    num emi;
    num r1 = r / (12*100);
    num t1 = t*12;
    emi = (p * r1 * pow(1+r1, t1)) /(pow(1+r1,t1)-1);
    return emi;
  }

  String paidPercent(){
    // TODO get paid percent from loanDetails
    print(this.toString());
    num paid = 500000;
    num paidPer = paid*100/this.principal;
    return paidPer.toString()+"%";
  }

  @override
  String toString(){
    return "["+this.loanId.toString()+":"+this.loanName+"]"+"Loan amount :"+this.principal.toString()+", interest: "
        +this.interest.toString()+"%, tenure:"+this.tenure.toString()+" Yrs, EMI:"
        +this.emi.toStringAsFixed(2)+", Start:"+this.startDate.toString();
  }

  save() async {
    print(this.toString());
    DatabaseHelper helper = DatabaseHelper.instance;
    int id = await helper.insertLoan(this);
    print('inserted row: $id');
    print('Saving loan information');
  }

  LoanInfo.fromMap(Map<String, dynamic> map){
    this.loanId = map[DatabaseHelper.loanInfoLoanId];
    this.loanName = map[DatabaseHelper.loanInfoLoanName];
    this.principal = map[DatabaseHelper.loanInfoLoanPrincipal];
    this.interest = map[DatabaseHelper.loanInfoLoanInterest];
    this.tenure = map[DatabaseHelper.loanInfoLoanTenure];
    this.startDate = map[DatabaseHelper.loanInfoLoanStartDt];
    this.emi = map[DatabaseHelper.loanInfoLoanEMI];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseHelper.loanInfoLoanId: loanId,
      DatabaseHelper.loanInfoLoanName: loanName,
      DatabaseHelper.loanInfoLoanPrincipal: principal,
      DatabaseHelper.loanInfoLoanInterest: interest,
      DatabaseHelper.loanInfoLoanTenure: tenure,
      DatabaseHelper.loanInfoLoanStartDt: startDate.toString(),
      DatabaseHelper.loanInfoLoanEMI: emi
    };
    return map;
  }
}