import 'package:flutter/material.dart';
import 'widgets/chart.dart';
import 'widgets/custom_list.dart';
import 'widgets/new_transaction.dart';
import 'models/transaction.dart';
import 'helpers/db_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        fontFamily: 'SF',
        primarySwatch: Colors.blueGrey,
        accentColor: Colors.redAccent,
      ),
      home: MyHomePage(title: 'Personal Expenses'),
    );
  }
}

@immutable
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Transaction> _itemList = [
    Transaction(
        id: '1',
        title: 'first',
        amount: 27,
        dateTime: DateTime.utc(2021, 8, 20)),
    Transaction(id: '2', title: 'sec', amount: 45, dateTime: DateTime.now()),
    Transaction(
        id: '3',
        title: 'third',
        amount: 6,
        dateTime: DateTime.utc(2021, 8, 19)),
    Transaction(
        id: '5', title: 'third', amount: 6, dateTime: DateTime.utc(2021, 8, 17))
  ];

  List<Transaction> get _recentTransactions {
    return _itemList.where((element) {
      return element.dateTime
          .isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  Future<List<Transaction>> FetchAndSetTransactions() async {
    final dataList = await DBHelper.getData('transactions');
    return dataList.map((e) {
      List<String> dateSplitted = e['date'].toString().split('/');
      return Transaction(
          id: e['id'],
          title: e['title'],
          amount: double.parse(e['amount']),
          dateTime: DateTime(int.parse(dateSplitted[2]),
              int.parse(dateSplitted[1]), int.parse(dateSplitted[0])));
    }).toList();
  }

  void _AddTransaction(String Title, double Amount, DateTime date) {
    var newTras = Transaction(
        id: '${date.month.toInt().toString()}${date.day.toInt().toString()}${date.hour.toInt().toString()}',
        title: Title,
        amount: Amount,
        dateTime: date);
    setState(() {
      _itemList.add(newTras);
    });
    print(newTras.id);
    Navigator.of(context).pop();
    DBHelper.insert('transactions', {
      'id': newTras.id,
      'title': newTras.title,
      'amount': newTras.amount.toString(),
      'date':
          '${newTras.dateTime.day}/${newTras.dateTime.month}/${newTras.dateTime.year}'
    });
    print('added');
  }

  void _RemoveTransaction(String id) {
    print('remove id: $id');
    setState(() {
      _itemList.removeWhere((element) => element.id == id);
    });
    DBHelper.delete('transactions', id);
  }

  void StartAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (bCtx) {
          return GestureDetector(
            onTap: () {},
            child: NewTransaction(_AddTransaction),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(this.widget.title),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                StartAddNewTransaction(context);
              },
            )
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          backgroundColor: Colors.redAccent,
          onPressed: () {
            StartAddNewTransaction(context);
          },
        ),
        body: FutureBuilder(
          future: FetchAndSetTransactions(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              _itemList = snapshot.data;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Card(
                      child: Chart(_recentTransactions),
                    ),
                    CustomList(_itemList, _RemoveTransaction),
                  ],
                ),
              );
            }
            print('readed');
            return Center(child: CircularProgressIndicator());
          },
        ));
  }
}
