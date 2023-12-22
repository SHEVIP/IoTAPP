import 'package:flutter/material.dart';
// import 'package:charts_flutter/flutter.dart' as charts;

class DeviceEfficiency extends StatefulWidget {
  const DeviceEfficiency({super.key});

  @override
  State<DeviceEfficiency> createState() => _DeviceEfficiencyState();
}

class _DeviceEfficiencyState extends State<DeviceEfficiency> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [Text("近7日"), Text("全部班次"), Text("设备比较"), Text("效率趋势")],
        ),
        Expanded(child: StackedFillColorBarChart(),)
      ],
    );
  }
}

class StackedFillColorBarChart extends StatelessWidget {
  // var seriesList = [
  //   // Blue bars with a lighter center color.
  //   new charts.Series<OrdinalSales, String>(
  //     id: 'Desktop',
  //     domainFn: (OrdinalSales sales, _) => sales.year,
  //     measureFn: (OrdinalSales sales, _) => sales.sales,
  //     data: [
  //       new OrdinalSales('C017', 5),
  //       new OrdinalSales('C018', 25),
  //       new OrdinalSales('C019', 50),
  //       new OrdinalSales('C020', 60),
  //     ],
  //     colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
  //     fillColorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault.lighter,
  //   ),
  //   // Solid red bars. Fill color will default to the series color if no
  //   // fillColorFn is configured.
  //   new charts.Series<OrdinalSales, String>(
  //     id: 'Tablet',
  //     measureFn: (OrdinalSales sales, _) => sales.sales,
  //     data: [
  //       new OrdinalSales('C017', 25),
  //       new OrdinalSales('C018', 50),
  //       new OrdinalSales('C019', 10),
  //       new OrdinalSales('C020', 20),
  //     ],
  //     colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
  //     domainFn: (OrdinalSales sales, _) => sales.year,
  //   ),
  //   // Hollow green bars.
  //   new charts.Series<OrdinalSales, String>(
  //     id: 'Mobile',
  //     domainFn: (OrdinalSales sales, _) => sales.year,
  //     measureFn: (OrdinalSales sales, _) => sales.sales,
  //     data: [
  //       new OrdinalSales('C017', 10),
  //       new OrdinalSales('C018', 20),
  //       new OrdinalSales('C019', 20),
  //       new OrdinalSales('C020', 20),
  //     ],
  //     colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
  //     fillColorFn: (_, __) => charts.MaterialPalette.transparent,
  //   ),
  // ];

  @override
  Widget build(BuildContext context) {
    return Text("data");
    // return charts.BarChart(
    //   seriesList,
    //   animate: false,
    //   defaultRenderer: charts.BarRendererConfig(
    //       groupingType: charts.BarGroupingType.stacked, strokeWidthPx: 2.0),
    // );
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}
