import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GetDate extends StatelessWidget {
  const GetDate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      child: Text(
        DateFormat('EEEE, d MMMM y', 'en_US').format(DateTime.now()),
        style: const TextStyle(
            color: Colors.deepOrange, fontWeight: FontWeight.w700),
      ),
    );
  }
}
