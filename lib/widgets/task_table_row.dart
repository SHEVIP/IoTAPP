import 'package:flutter/material.dart';

class TaskTableRow extends StatelessWidget {
  const TaskTableRow({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}

TableRow createCustomTableRow(
  String header1,
  String header2,
  String header3,
  String header4,
  String header5,
  String header6,
  String header7,
  String header8, {
  FontWeight fontWeight = FontWeight.normal,
}) {
  return TableRow(
    children: [
      TableCell(
        child: Center(
          child: Text(
            header1,
            style: TextStyle(
              fontWeight: fontWeight,
            ),
          ),
        ),
      ),
      TableCell(
        child: Center(
          child: Text(
            header2,
            style: TextStyle(
              fontWeight: fontWeight,
            ),
          ),
        ),
      ),
      TableCell(
        child: Center(
          child: Text(
            header3,
            style: TextStyle(
              fontWeight: fontWeight,
            ),
          ),
        ),
      ),
      TableCell(
        child: Center(
          child: Text(
            header4,
            style: TextStyle(
              fontWeight: fontWeight,
            ),
          ),
        ),
      ),
      TableCell(
        child: Center(
          child: Text(
            header5,
            style: TextStyle(
              fontWeight: fontWeight,
            ),
          ),
        ),
      ),
      TableCell(
        child: Center(
          child: Text(
            header6,
            style: TextStyle(
              fontWeight: fontWeight,
            ),
          ),
        ),
      ),
      TableCell(
        child: Center(
          child: Text(
            header7,
            style: TextStyle(
              fontWeight: fontWeight,
            ),
          ),
        ),
      ),
      TableCell(
        child: Center(
          child: Text(
            header8,
            style: TextStyle(
              fontWeight: fontWeight,
            ),
          ),
        ),
      ),
    ],
  );
}

TableRow createCustomTable4Row(
    String header1,
    String header2,
    String header3,
    String header4,
    {
      FontWeight fontWeight = FontWeight.normal,
    }) {
  return TableRow(
    children: [
      TableCell(
        child: Center(
          child: Text(
            header1,
            style: TextStyle(
              fontWeight: fontWeight,
            ),
          ),
        ),
      ),
      TableCell(
        child: Center(
          child: Text(
            header2,
            style: TextStyle(
              fontWeight: fontWeight,
            ),
          ),
        ),
      ),
      TableCell(
        child: Center(
          child: Text(
            header3,
            style: TextStyle(
              fontWeight: fontWeight,
            ),
          ),
        ),
      ),
      TableCell(
        child: Center(
          child: Text(
            header4,
            style: TextStyle(
              fontWeight: fontWeight,
            ),
          ),
        ),
      ),

    ],
  );
}
