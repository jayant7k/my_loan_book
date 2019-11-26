import 'dart:io';
import 'package:my_loan_book/models/loaninfo.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper{
  static final _databaseName = "myLoanBook.db";
  static final _databaseVersion = 1;

  // loan info table
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
  }

  Future<int> insert(LoanInfo loanInfo) async {
    Database db = await database;
    int id = await db.insert(_loanInfoTable, loanInfo.toMap());
    return id;
  }
}