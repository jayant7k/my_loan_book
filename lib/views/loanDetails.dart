import 'package:flutter/material.dart';
import '../models/loaninfo.dart';
//import 'package:charts_flutter/flutter.dart' as charts;
import 'package:pie_chart/pie_chart.dart';
import 'package:my_loan_book/views/loanList.dart';

class LoanDetailPage extends StatefulWidget{
  final LoanInfo loanInfo;

  LoanDetailPage({Key key, @required this.loanInfo}) : super(key: key);

  @override
  _LoanDetailPageState createState(){
    return _LoanDetailPageState();
  }
}

/*
// Use charts_flutter package

class _LoanDetailPageState extends State<LoanDetailPage> {
  List<charts.Series> chartData;

  @override
  void initState() {
    widget.loanInfo.calcLoanDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var data = [
      new ChartData("Interest Paid ", widget.loanInfo.intPaid.toInt(), Colors.green),
      new ChartData("Interest Left ", widget.loanInfo.intLeft.toInt(), Colors.red),
      new ChartData(
          "Principle paid", widget.loanInfo.principlePaid.toInt(), Colors.blue),
      new ChartData(
          "Principle Left", widget.loanInfo.principleLeft.toInt(), Colors.yellow)
    ];

    var series = [
      new charts.Series(
          id: widget.loanInfo.loanName,
          data: data,
          domainFn: (ChartData row, _) => row.label,
          measureFn: (ChartData row, _) => row.value,
          colorFn: (ChartData row, _) => row.color,
          labelAccessorFn: (ChartData row, _) => '${row.value}',
      ),
    ];

    var chart = new charts.PieChart(
      series,
      animate: true,
      defaultRenderer: charts.ArcRendererConfig(
        arcWidth: 60,
        arcRendererDecorators: [charts.ArcLabelDecorator(
          labelPosition: charts.ArcLabelPosition.inside,
        )],
      ),
    );

    var chartWidget = new Padding(
      padding: EdgeInsets.all(16.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.width / 1.5,
        child: chart,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.loanInfo.loanName),
      ),
      body: Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                chartWidget,
              ],
            ),
          )
      ),
    );
  }
}
class ChartData {
  final String label;
  final int value;
  final charts.Color color;

  ChartData(this.label, this.value, Color color)
    : this.color = new charts.Color(
      r: color.red, g: color.green, b: color.blue, a: color.alpha
    );
}
*/


class _LoanDetailPageState extends State<LoanDetailPage>{

  Map<String, double> dataMap = Map();
  List<Color> colorList = [
    Colors.green,
    Colors.red,
    Colors.blue,
    Colors.yellow
  ];

  Map<String, double> totalMap = Map();
  List<Color> totalList = [
    Colors.green,
    Colors.red
  ];

  @override
  void initState(){
    widget.loanInfo.calcLoanDetails();
    dataMap.putIfAbsent("Interest Paid: "+widget.loanInfo.intPaid.round().toString()+"/-",
            () => widget.loanInfo.intPaid.toDouble() );
    dataMap.putIfAbsent("Interest Left: "+widget.loanInfo.intLeft.round().toString()+"/-",
            () => widget.loanInfo.intLeft.toDouble() );
    dataMap.putIfAbsent("Principle Paid: "+widget.loanInfo.principlePaid.round().toString()+"/-",
            () => widget.loanInfo.principlePaid.toDouble() );
    dataMap.putIfAbsent("Principle Left: "+widget.loanInfo.principleLeft.round().toString()+"/-",
            () => widget.loanInfo.principleLeft.toDouble() );

    totalMap.putIfAbsent("Paid till date: "+widget.loanInfo.totalPaid.round().toString()+"/-",
            () => widget.loanInfo.totalPaid.toDouble());
    totalMap.putIfAbsent("To be paid: "+widget.loanInfo.totalLeft.round().toString()+"/-",
            () => widget.loanInfo.totalLeft.toDouble());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    var chart = Padding(
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
        colorList: colorList,
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

    var totalchart = Padding(
      padding: EdgeInsets.all(8.0),
      child: PieChart(
        dataMap: totalMap,
        animationDuration: Duration(milliseconds: 800),
        chartLegendSpacing: 16.0,
        chartRadius: MediaQuery.of(context).size.width / 2.5,
        showChartValuesInPercentage: true,
        showChartValues: true,
        showChartValuesOutside: false,
        chartValueBackgroundColor: Colors.grey[200],
        colorList: totalList,
        showLegends: true,
        legendPosition: LegendPosition.right,
        decimalPlaces: 1,
        showChartValueLabel: true,
        initialAngle: 0,
        chartValueStyle: defaultChartValueStyle.copyWith(
          color: Colors.blueGrey[900].withOpacity(0.9),
        ),
        chartType: ChartType.ring,
      )
    );

    var delButton =  new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton(
          padding: const EdgeInsets.all(8.0),
          textColor: Colors.white,
          color: Colors.red,
          child: Text("Delete"),
          onPressed: (){
            widget.loanInfo.deleteMe();

            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyLoanList()));
          },
        )
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.loanInfo.loanName),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              chart,
              totalchart,
              delButton,
            ],
          ),
        ),
      ),
    );
  }
}

