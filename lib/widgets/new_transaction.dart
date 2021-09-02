import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function _AddTransaction;

  NewTransaction(this._AddTransaction);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _TextTitle = TextEditingController();

  final _TextAmount = TextEditingController();

  DateTime _dateTime;

  void _DatePicker() {
    showDatePicker(
            context: this.context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2021),
            lastDate: DateTime.now())
        .then((value) {
      if (value == null) return;
      setState(() {
        _dateTime = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.all(30),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor)),
                  labelText: 'Title',
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).accentColor)),
                  labelStyle: TextStyle(color: Theme.of(context).primaryColor)),
              controller: _TextTitle,
              maxLength: 25,
              maxLines: 1,
              onSubmitted: (_) {},
            ),
            TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor)),
                    labelText: 'Amount',
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(context).accentColor)),
                    labelStyle:
                        TextStyle(color: Theme.of(context).primaryColor)),
                controller: _TextAmount,
                maxLength: 10,
                maxLines: 1,
                keyboardType: TextInputType.number,
                onSubmitted: (_) {}),
            Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _dateTime == null
                          ? 'No Date chosen.'
                          : 'Chosen Date: ${DateFormat.yMMMd().format(_dateTime)}',
                      style: TextStyle(
                          fontSize: 15, color: Theme.of(context).primaryColor),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: _DatePicker, child: Text('Choose Date'))
                ],
              ),
            ),
            OutlinedButton(
                onPressed: () {
                  if (_dateTime == null ||
                      _TextTitle == null ||
                      _TextAmount == null) return;
                  widget._AddTransaction(_TextTitle.text,
                      double.parse(_TextAmount.text), _dateTime);
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'submit',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).accentColor),
                  ),
                ))
          ],
        ));
  }
}
