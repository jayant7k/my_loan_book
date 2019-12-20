import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:my_loan_book/models/loandetail.dart';
import 'package:my_loan_book/models/loaninfo.dart';
import 'package:my_loan_book/models/profile.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper{
  static final _databaseName = "myLoanBook.db";
  static final _databaseVersion = 1;

  // profile info table *****************************************
  static final _profileInfoTable = "profile_info";
  static final profileId = "Pid";
  static final profileName = "Pname";
  static final profileEmail = "Pemail";

  String getProfileId(){
    return profileId;
  }

  String getProfileName(){
    return profileName;
  }

  String getProfileEmail(){
    return profileEmail;
  }

  Future<int> insertProfile(User profile) async {
    Database db = await database;
    int id = await db.insert(_profileInfoTable, profile.toMap());
    return id;
  }

  // end profile info table *****************************

  // loan details table ******************************
  static final _loanDetailTable = "loan_details";
  static final ldId = "loan_id";
  static final ldDate = "loan_date";
  static final ldDisbursement = "loan_disbursement";
  static final ldOpenPrinciple = "loan_openprinciple";
  static final ldInterest = "loan_interest";
  static final ldMonth = "loan_month";
  static final ldEMI = "loan_emi";
  static final ldIntComp = "loan_emi_interest_component";
  static final ldPrincipleComp = "loan_emi_principle_component";
  static final ldClosingPrinciple = "loan_closing_principle";
  static final ldPartPmt = "loan_part_payment";
  static final ldIntPaid = "loan_interest_paid_total";
  static final ldPrincipalPaid = "loan_principal_paid_total";
  static final ldTotalPaid = "loan_total_paid";

  Future<int> populateLoanDetails(LoanInfo loanInfo) async{
    print('Populating loan details');
    LoanDetails lds = new LoanDetails(loanInfo);
    Database db = await database;
    lds.calcAllEntries();

    print('All entries calculated');

    List<LoanDetail> loanDetails = lds.loanDetails;
    loanDetails.forEach((ld) =>
      insertToLoanDetailTable(db, ld)
    );

    print(loanDetails.length.toString()+" entries added to db");

    return loanDetails.length;
  }

  insertToLoanDetailTable(Database db, LoanDetail ld) async {
    await db.insert(_loanDetailTable, ld.toMap());
  }

  // end loan details table **********************************

  // loan info table **********************************
  static final _loanInfoTable = "loan_info";
  static final loanInfoLoanId = "id";
  static final loanInfoLoanName = "name";
  static final loanInfoLoanPrincipal = "principal";
  static final loanInfoLoanInterest = "interest";
  static final loanInfoLoanStartDt = "start_date";
  static final loanInfoLoanTenure = "tenure";
  static final loanInfoLoanEMI = "emi";

  String getLoanInfoLoanId(){
    return loanInfoLoanId;
  }

  String getLoanInfoLoanName(){
    return loanInfoLoanName;
  }

  String getLoanInfoLoanPrincipal(){
    return loanInfoLoanPrincipal;
  }

  String getLoanInfoLoanInterest(){
    return loanInfoLoanInterest;
  }

  String getLoanInfoLoanStartDt(){
    return loanInfoLoanStartDt;
  }

  String getLoanInfoLoanTenure(){
    return loanInfoLoanTenure;
  }

  String getLoanInfoLoanEMI(){
    return loanInfoLoanEMI;
  }

  Future<int> insertLoan(LoanInfo loanInfo) async {
    Database db = await database;
    var maxId = await db.rawQuery("SELECT MAX($loanInfoLoanId)+1 AS nextId FROM $_loanInfoTable");
    //print(maxId);
    loanInfo.loanId = maxId.first["nextId"];
    int id = await db.insert(_loanInfoTable, loanInfo.toMap());
    //await populateLoanDetails(loanInfo);
    return id;
  }
  
  Future<LoanInfo> getLoanInfoById(num loanId) async{
    Database db = await database;
    List<Map> result = await db.query("$_loanInfoTable", where: "$loanInfoLoanId = ?", whereArgs: [loanId]);
    return result.isNotEmpty ? LoanInfo.fromMap(result.first) : Null;
  }

  Future<List<LoanInfo>> getAllLoans() async{
    Database db = await database;
    List<Map> results = await db.query("$_loanInfoTable", columns: LoanInfo.shortColumns, orderBy: "id ASC" );
    List<LoanInfo> myLoans = new List();
    results.forEach((result){
      LoanInfo loanInfo = LoanInfo.fromMap(result);
      myLoans.add(loanInfo);
    });
    return myLoans;
  }
  //=== end  loan info table ====

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;
  Future<Database> get database async{
    if(_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async{
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
        CREATE TABLE $_loanInfoTable ( $loanInfoLoanId INTEGER PRIMARY KEY,
        $loanInfoLoanName TEXT NOT NULL, $loanInfoLoanPrincipal INTEGER NOT NULL,
        $loanInfoLoanInterest REAL NOT NULL, $loanInfoLoanTenure INTEGER NOT NULL,
        $loanInfoLoanStartDt TEXT NOT NULL, $loanInfoLoanEMI REAL NOT NULL) 
      ''');
    await db.execute('''
        CREATE TABLE $_profileInfoTable ( $profileId INTEGER PRIMARY KEY,
        $profileName TEXT NOT NULL, $profileEmail TEXT NOT NULL)
      ''');
    await db.execute('''
        CREATE TABLE $_loanDetailTable ( $ldId INTEGER NOT NULL, $ldMonth INTEGER NOT NULL, 
        $ldDate TEXT NOT NULL, $ldDisbursement INTEGER NOT NULL, $ldOpenPrinciple REAL NOT NULL,
        $ldInterest REAL NOT NULL, $ldEMI REAL NOT NULL, $ldIntComp REAL NOT NULL, 
        $ldPrincipleComp REAL NOT NULL, $ldClosingPrinciple REAL NOT NULL, $ldPartPmt INTEGER NOT NULL,
        $ldIntPaid REAL NOT NULL, $ldPrincipalPaid REAL NOT NULL, $ldTotalPaid REAL NOT NULL )
    ''');
  }

}