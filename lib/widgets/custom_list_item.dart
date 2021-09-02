import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class CustomListItem extends StatelessWidget {
  final Transaction item;
  final Function _RemoveTransacion;

  CustomListItem(this.item, this._RemoveTransacion);

  @override
  Widget build(BuildContext context) => Card(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 3),
        elevation: 2,
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            child: Padding(
              padding: EdgeInsets.all(7),
              child: FittedBox(
                child: Text('\$${item.amount}'),
              ),
            ),
          ),
          title: Text(item.title),
          subtitle: Text(DateFormat.MMMMEEEEd().format(item.dateTime)),
          trailing: IconButton(
            icon: Icon(Icons.delete_outline_sharp),
            onPressed: () => _RemoveTransacion(item.id),
          ),
        ),
      );
}
