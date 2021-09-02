import 'package:intl/intl.dart';
import 'package:personal_expenses/models/transaction.dart';

import '../models/sales_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';

@immutable
class Chart extends StatefulWidget {
  @override
  _ChartState createState() => _ChartState();
  final List<Transaction> _recentTransactions;

  Chart(this._recentTransactions);

  LineSeries<SalesData, String> get getSeries {
    return LineSeries<SalesData, String>(
      dataSource: List.generate(7, (index) {
        var weekDay = DateTime.now().subtract(Duration(days: index));

        var x = _recentTransactions.where((element) {
          return (element.dateTime.day == weekDay.day &&
              element.dateTime.month == weekDay.month &&
              element.dateTime.year == weekDay.year);
        }).toList();
        double amount = 0;
        for (int i = 0; i < x.length; i++) {
          amount += x[i].amount;
        }

        return SalesData(DateFormat.E().format(weekDay), amount);
      }),
      xValueMapper: (SalesData sales, _) => sales.day,
      yValueMapper: (SalesData sales, _) => sales.totalAmount,
    );
  }
}

class _ChartState extends State<Chart> {
  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      title: ChartTitle(
          text: 'Weekly Expenses Chart',
          textStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).accentColor)),
      primaryXAxis: CategoryAxis(),
      primaryYAxis: NumericAxis(labelFormat: '\${value}'),
      series: <ChartSeries>[widget.getSeries],
    );
  }
}
