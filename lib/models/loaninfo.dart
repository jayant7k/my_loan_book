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

  num intPaid=0;
  num principlePaid=0;
  num intLeft=0;
  num principleLeft=0;
  num totalPaid=0;
  num totalLeft=0;
  num totalCost=0;
  num monthsPaid;
  num monthsLeft;
  DateTime lastEMIDate;

  static final shortColumns = [DatabaseHelper.loanInfoLoanId, DatabaseHelper.loanInfoLoanName, DatabaseHelper.loanInfoLoanEMI,
    DatabaseHelper.loanInfoLoanPrincipal, DatabaseHelper.loanInfoLoanInterest, DatabaseHelper.loanInfoLoanTenure, DatabaseHelper.loanInfoLoanStartDt];

  LoanInfo(){
    this.loanId = 1;
    this.loanName = 'car loan';
    this.principal = 800000;
    this.interest = 9.7;
    this.startDate = new DateTime(DateTime.now().year-5, DateTime.now().month-5);
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

  calcLoanDetails(){
    DateTime currDate = DateTime.now();
    num years = currDate.year - startDate.year;
    num months = currDate.month - startDate.month;

    this.monthsPaid = years*12 + months.abs();
    this.monthsLeft = this.tenure*12 - this.monthsPaid;

    num paymentNo = 0;
    num loanAmt = this.principal;

    for(int x=0; x<tenure*12; x++){
      paymentNo++;
      num intComp = (loanAmt*this.interest)/1200;
      num pComp = this.emi - intComp;
      if(x<this.monthsPaid) {
        this.intPaid += intComp;
        this.principlePaid += pComp;
      } else {
        this.intLeft += intComp;
        this.principleLeft += pComp;
      }
      loanAmt -= pComp;
      if(loanAmt <=0 )
        break;
    }

    this.totalPaid = this.intPaid + this.principlePaid;
    this.totalLeft = this.intLeft + this.principleLeft;
    this.totalCost = this.totalPaid + this.totalLeft;

    this.lastEMIDate = new DateTime(this.startDate.year+this.tenure, this.startDate.month, this.startDate.day-1);

    print("Calculated [paid/left] : Month ["+monthsPaid.toString()+"/"+monthsLeft.toString()+
        "] Interest => " +intPaid.toString()+"/"+intLeft.toString()+
        "  Principle => "+principlePaid.toString()+"/"+principleLeft.toString()+
        "  Total => "+totalPaid.toString()+"/"+totalLeft.toString()+
        "  Cost => "+totalCost.toString()+" LastDate "+lastEMIDate.toString());
  }

  /*
  num getInterestPaid(){

  }

  num getPrinciplePaid(){

  }

  num getInterestLeft(){

  }

  num getPrincipleLeft(){

  }

  num getTotalPaid(){

  }

  num getTotalLeft(){

  }

  num getTotalCost(){

  }

  num getMonthsLeft(){

  }

  String getLastEMIDate(){

  }
 */

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

  deleteMe() async {
    print('Deleting '+this.loanName);
  }

  LoanInfo.fromMap(Map<String, dynamic> map){
    this.loanId = map[DatabaseHelper.loanInfoLoanId];
    this.loanName = map[DatabaseHelper.loanInfoLoanName];
    this.principal = map[DatabaseHelper.loanInfoLoanPrincipal];
    this.interest = map[DatabaseHelper.loanInfoLoanInterest];
    this.tenure = map[DatabaseHelper.loanInfoLoanTenure];
    this.startDate = DateTime.parse(map[DatabaseHelper.loanInfoLoanStartDt]);
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