import 'dart:math';

import 'package:my_loan_book/helpers/database.dart';
import 'package:my_loan_book/models/loaninfo.dart';

class LoanDetails{
  List<LoanDetail> loanDetails;
  num closingPrinciple = 0;
  LoanDetail currLd;

  LoanDetails(LoanInfo loanInfo){
    loanDetails = new List<LoanDetail>();
    currLd = new LoanDetail(loanInfo);
    closingPrinciple = currLd.ldClosingPrinciple;
    loanDetails.add(currLd);
  }

  calcAllEntries(){
    while(closingPrinciple > 0 ){
      LoanDetail nextLd = LoanDetail.fromLoanDetail(currLd);
      closingPrinciple = nextLd.ldClosingPrinciple;
      loanDetails.add(currLd);
      nextLd = currLd;
    }
  }
}

class LoanDetail{
  num ldId;
  DateTime ldDate;
  num ldDisbursement;
  num ldOpenPrinciple;
  num ldInterest;
  num ldMonth;
  num ldEMI;
  num ldIntComp;
  num ldPrincipleComp;
  num ldClosingPrinciple;
  num ldPartPmt;
  num ldIntPaid;
  num ldPrincipalPaid;
  num ldTotalPaid;

  LoanDetail(LoanInfo loanInfo){
    this.ldId = loanInfo.loanId;
    this.ldDate = getNextDate(loanInfo.startDate,next: false);
    this.ldDisbursement = loanInfo.principal;
    this.ldOpenPrinciple = loanInfo.principal;
    this.ldInterest = loanInfo.interest;
    this.ldMonth = 1;
    this.ldEMI = loanInfo.emi;
    this.ldIntComp = calcInterest(this.ldOpenPrinciple, this.ldInterest);
    this.ldPrincipleComp = calcPrinciple(this.ldEMI, this.ldIntComp);
    this.ldClosingPrinciple = calcClosingPrinciple(this.ldOpenPrinciple, this.ldPrincipleComp);
    this.ldPartPmt = 0;
    this.ldIntPaid = this.ldIntComp;
    this.ldPrincipalPaid = this.ldPrincipleComp;
    this.ldTotalPaid = (this.ldIntPaid + this.ldPrincipalPaid);
  }

  LoanDetail.fromLoanDetail(LoanDetail prevLD){
    this.ldId = prevLD.ldId;
    this.ldDate = getNextDate(prevLD.ldDate);
    this.ldDisbursement = 0;
    this.ldOpenPrinciple = prevLD.ldClosingPrinciple;
    this.ldInterest = prevLD.ldInterest;
    this.ldMonth = prevLD.ldMonth+1;
    this.ldEMI = prevLD.ldEMI;
    this.ldIntComp = calcInterest(ldOpenPrinciple, ldInterest);
    this.ldPrincipleComp = calcPrinciple(ldEMI, ldIntComp);
    this.ldClosingPrinciple = calcClosingPrinciple(ldOpenPrinciple, ldPrincipleComp);
    this.ldPartPmt = 0;
    this.ldIntPaid = prevLD.ldIntPaid+ldIntComp;
    this.ldPrincipalPaid = prevLD.ldPrincipalPaid+ldPrincipleComp;
    this.ldTotalPaid = (ldIntPaid + ldPrincipalPaid);
  }

  DateTime getNextDate(DateTime curr, {bool next=true}){
    DateTime tmp = new DateTime(curr.year, curr.month, 1);
    if(next) {
      tmp = new DateTime(curr.year, curr.month+1, 1);
      return tmp;
    }
    return tmp;
  }

  num calcClosingPrinciple(num openPrinciple, num principleComp){
    return (openPrinciple - principleComp);
  }

  num calcPrinciple(num emi, num intComp){
    return (emi - intComp);
  }

  num calcInterest(num openPrinciple, num interest){
    return (openPrinciple*interest/1200);
  }

  LoanDetail.fromMap(Map<String, dynamic> map){
    this.ldId = map[DatabaseHelper.ldId];
    this.ldDate = map[DatabaseHelper.ldDate];
    this.ldDisbursement = map[DatabaseHelper.ldDisbursement];
    this.ldOpenPrinciple = map[DatabaseHelper.ldOpenPrinciple];
    this.ldInterest = map[DatabaseHelper.ldInterest];
    this.ldMonth = map[DatabaseHelper.ldMonth];
    this.ldEMI = map[DatabaseHelper.ldEMI];
    this.ldIntComp = map[DatabaseHelper.ldIntComp];
    this.ldPrincipleComp = map[DatabaseHelper.ldPrincipleComp];
    this.ldClosingPrinciple = map[DatabaseHelper.ldClosingPrinciple];
    this.ldPartPmt = map[DatabaseHelper.ldPartPmt];
    this.ldIntPaid = map[DatabaseHelper.ldIntPaid];
    this.ldPrincipalPaid = map[DatabaseHelper.ldPrincipalPaid];
    this.ldTotalPaid = map[DatabaseHelper.ldTotalPaid];
  }

  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
      DatabaseHelper.ldId: this.ldId,
      DatabaseHelper.ldDate: this.ldDate.toString(),
      DatabaseHelper.ldDisbursement: this.ldDisbursement,
      DatabaseHelper.ldOpenPrinciple: this.ldOpenPrinciple,
      DatabaseHelper.ldInterest: this.ldInterest,
      DatabaseHelper.ldMonth: this.ldMonth,
      DatabaseHelper.ldEMI: this.ldEMI,
      DatabaseHelper.ldIntComp: this.ldIntComp,
      DatabaseHelper.ldPrincipleComp: this.ldPrincipleComp,
      DatabaseHelper.ldClosingPrinciple: this.ldClosingPrinciple,
      DatabaseHelper.ldPartPmt: this.ldPartPmt,
      DatabaseHelper.ldIntPaid: this.ldIntPaid,
      DatabaseHelper.ldPrincipalPaid: this.ldPrincipalPaid,
      DatabaseHelper.ldTotalPaid: this.ldTotalPaid
    };

    return map;
  }
}