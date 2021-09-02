import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'custom_list_item.dart';

@immutable
class CustomList extends StatelessWidget {
  final List<Transaction> _itemList;
  final Function _RemoveTransaction;

  CustomList(this._itemList, this._RemoveTransaction);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      child: ListView.builder(
        itemBuilder: (context, index) {
          return CustomListItem(_itemList[index], _RemoveTransaction);
        },
        itemCount: _itemList.length,
      ),
    );
  }
}
