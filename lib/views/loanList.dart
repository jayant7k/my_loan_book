import 'package:flutter/material.dart';
import '../models/loaninfo.dart';
import './loanDetails.dart';
import 'package:my_loan_book/helpers/database.dart';

class MyLoanList extends StatefulWidget{
  @override
  _MyLoanListState createState(){
    return _MyLoanListState();
  }
}
class _MyLoanListState extends State<MyLoanList>{
  List<LoanInfo> myLoans;

  @override
  void initState(){
    super.initState();

  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: topAppBar,
      body: makeBody(context),
      bottomNavigationBar: bottomAppBar,
    );
  }

  /*final makeBody = Container(
    child: ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: 5,
      itemBuilder: (BuildContext context, int index){
        return makeCard();
      },
    ),
  );
  */

  Widget makeBody(BuildContext context) => FutureBuilder<List<LoanInfo>>(
    future: DatabaseHelper.instance.getAllLoans(),
    builder: (BuildContext context, AsyncSnapshot<List<LoanInfo>> snapshot){
      if(snapshot.hasData){
        return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index){
              return makeCard(snapshot.data[index]);
            }
        );
      } else {
        return Center(child: CircularProgressIndicator(),);
      }
    },
  );

  Card makeCard(LoanInfo loanData) => Card(
    elevation: 8.0,
    margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
    child: Container(
      decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
      child: makeListTile(loanData),
    ),
  );

  ListTile makeListTile(LoanInfo loanData) => ListTile(
    contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    leading: Container(
      padding: EdgeInsets.only(right: 12.0),
      decoration: new BoxDecoration(
        border: new Border(
          right: new BorderSide(width: 1.0),
        ),
      ),
      child: Icon(Icons.autorenew),
    ),
    title: Text(
      loanData.loanName,
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
    subtitle: Row(
      children: <Widget>[
        Icon(Icons.linear_scale, color: Colors.yellowAccent),
        Text(loanData.paidPercent())
      ],
    ),
    trailing: Icon(Icons.keyboard_arrow_right,size: 30.0,),
    onTap: (){
      Navigator.push(
        context, MaterialPageRoute(builder: (context)=>LoanDetailPage())
      );
    },
  );

  final topAppBar = AppBar(
    elevation: 0.1,
    title: Text("My Loans"),
  );

  final bottomAppBar = Container(
    height: 55,
    child: BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.home),
            onPressed: (){},
          ),
          IconButton(
            icon: Icon(Icons.add_circle_outline),
            onPressed: (){},
          ),
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: (){},
          ),
        ],
      ),
    ),
  );
}

