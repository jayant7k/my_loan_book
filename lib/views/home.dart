import 'package:flutter/material.dart';
import 'package:my_loan_book/views/loanForm.dart';
import 'package:my_loan_book/views/loanList.dart';
import 'package:my_loan_book/views/profileForm.dart';
import '../models/loaninfo.dart';
import 'package:my_loan_book/helpers/database.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:intl/intl.dart';

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
      body: makeBody(context),
      bottomNavigationBar: bottomNavBar(context),
    );
  }

  Widget makeBody(BuildContext context) =>  FutureBuilder<List<LoanInfo>>(
    future: DatabaseHelper.instance.getAllLoans(),
    builder: (BuildContext context, AsyncSnapshot<List<LoanInfo>> loanData){
      if(loanData.hasData){
        num totalInterest = 0;
        num totalPrinciple = 0;
        num totalLoans = loanData.data.length;
        for(int i=0; i<loanData.data.length; i++){
          LoanInfo loanInfo = loanData.data[i];
          loanInfo.calcLoanDetails();
          totalInterest += loanInfo.getTotalInterest();
          totalPrinciple += loanInfo.getTotalPrinciple();
        }

        num totalCost = totalPrinciple+totalInterest;
        final oCcy = new NumberFormat("#,##0.00", "en_IN");

        Map<String, double> dataMap = Map();
        List<Color> colorMap = [
          Colors.green,
          Colors.red,
        ];

        dataMap.putIfAbsent("Total Interest: "+totalInterest.toString()+"/-",
                () => totalInterest.toDouble() );
        dataMap.putIfAbsent("Total Principle: "+totalPrinciple.toString()+"/-",
                () => totalPrinciple.toDouble() );

        var pie = makePie(dataMap, colorMap);

        var top = makeTxt("$totalLoans Loans", 30);
        var bottom = makeTxt("Total Cost: ${oCcy.format(totalCost)}/-", 20);

        return new Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    top,
                    pie,
                    bottom
                  ]
              )
            )
        );
      } else {
        return Center(child: CircularProgressIndicator(),);
      }
    },
  );

  Widget makeTxt(String s, int size){
    TextStyle style = TextStyle(fontSize: size.toDouble(), color: Colors.cyanAccent);
    var rt = RichText(
        text: TextSpan(
          style: style,
          text: "$s",
        )
    );

    var w = Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: rt
    );

    return w;
  }

  Widget makePie(Map<String, double> dataMap, List<Color> colorMap){
    var widget = Padding(
        padding: EdgeInsets.all(8.0),
        child: PieChart(
          dataMap: dataMap,
          animationDuration: Duration(milliseconds: 800),
          chartLegendSpacing: 16.0,
          chartRadius: MediaQuery.of(context).size.width / 2.5,
          showChartValuesInPercentage: true,
          showChartValues: true,
          showChartValuesOutside: false,
          chartValueBackgroundColor: Colors.grey[200],
          colorList: colorMap,
          showLegends: true,
          legendPosition: LegendPosition.bottom,
          decimalPlaces: 1,
          showChartValueLabel: true,
          initialAngle: 0,
          chartValueStyle: defaultChartValueStyle.copyWith(
            color: Colors.blueGrey[900].withOpacity(0.9),
          ),
          chartType: ChartType.ring,
        )
    );
    return widget;
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