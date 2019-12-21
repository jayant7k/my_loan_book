import 'package:flutter/material.dart';
import 'package:my_loan_book/views/loanForm.dart';
import 'package:my_loan_book/views/loanList.dart';
import 'package:my_loan_book/views/profileForm.dart';

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState(){
    return _MyHomeState();
  }
}

class _MyHomeState extends State<MyHome>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('My Loan Book'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: CustomPaint(
          painter: HomePainter(),
          child: Container(height: 700,),
        ),
      ),
      bottomNavigationBar: bottomNavBar(context),
    );
  }

  Widget bottomNavBar(BuildContext context) => Container(
    height: 55,
    child: BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>MyProfile()));
            },
          ),
          IconButton(
            icon: Icon(Icons.add_circle_outline),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>MyLoanInfo()));
            },
          ),
          IconButton(
            icon: Icon(Icons.view_list),
            onPressed: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyLoanList()));
            },
          ),
        ],
      ),
    ),
  );
}

class HomePainter extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size){
    final paint = Paint();
    paint.color = Colors.green;

    var center = Offset(size.width/2, size.height/2);
    Rect rect = Rect.fromCenter(center: center, width: size.width/2, height: size.height/4);
    canvas.drawOval(rect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}