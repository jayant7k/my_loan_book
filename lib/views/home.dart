import 'package:flutter/material.dart';

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
    );
  }
}

class HomePainter extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size){
    final paint = Paint();
    paint.color = Colors.deepOrange;

    var center = Offset(size.width/2, size.height/2);
    Rect rect = Rect.fromCenter(center: center, width: 10.0, height: 10.0);
    canvas.drawOval(rect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}