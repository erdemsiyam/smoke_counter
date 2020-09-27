import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:smoke_counter/provider/smoke_provider.dart';

class ChartLineStress extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ChartLineStressState();
}

class ChartLineStressState extends State<ChartLineStress> {
  SmokeProvider _smokeProvider;
  List<FlSpot> flSpotsFine;
  List<FlSpot> flSpotsNormal;
  List<FlSpot> flSpotsStress;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _smokeProvider = Provider.of<SmokeProvider>(context);
    flSpotsFine = new List<FlSpot>();
    flSpotsNormal = new List<FlSpot>();
    flSpotsStress = new List<FlSpot>();
    if (_smokeProvider.listStressDataHourly != null) {
      _smokeProvider.listStressDataHourly.forEach(
        (element) => {
          flSpotsFine.add(FlSpot(flSpotsFine.length.toDouble(), element[0])),
          flSpotsNormal
              .add(FlSpot(flSpotsNormal.length.toDouble(), element[1])),
          flSpotsStress
              .add(FlSpot(flSpotsStress.length.toDouble(), element[2])),
        },
      );
    } else {
      flSpotsFine = [
        FlSpot(0, 0)
      ]; // state notify olana kadar, bu boş olduğu vakit null hatası vermesin diye 1 tane koyarız içine
      flSpotsNormal = [
        FlSpot(0, 0)
      ]; // state notify olana kadar, bu boş olduğu vakit null hatası vermesin diye 1 tane koyarız içine
      flSpotsStress = [
        FlSpot(0, 0)
      ]; // state notify olana kadar, bu boş olduğu vakit null hatası vermesin diye 1 tane koyarız içine
    }

    return Container(
      alignment: Alignment.center,
      color: Colors.blue,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(18)),
          color: Colors.white,
        ),
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Stress Chart',
                  style: Theme.of(context).textTheme.bodyText2,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    SizedBox(width: 30),
                    Text('Stress',
                        style: TextStyle(fontSize: 14, color: Colors.red)),
                    SizedBox(width: 20),
                    Text('Normal',
                        style: TextStyle(fontSize: 14, color: Colors.blue)),
                    SizedBox(width: 20),
                    Text('Fine',
                        style: TextStyle(fontSize: 14, color: Colors.green)),
                  ],
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0, left: 6.0),
                    child: LineChart(
                      sampleData1(),
                      swapAnimationDuration: const Duration(milliseconds: 250),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }

  LineChartData sampleData1() {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: const TextStyle(
            color: Color(0xff72719b),
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
          margin: 10,
          getTitles: (value) {
            return value.toInt().toString();
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: const TextStyle(
            color: Color(0xff75729e),
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
          getTitles: (value) {
            return value.toString();
          },
          margin: 8,
          reservedSize: 30,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(
            color: Color(0xff4e4965),
            width: 4,
          ),
          left: BorderSide(
            color: Colors.transparent,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      minX: 0,
      maxX: 24, // 14
      maxY: 10, // 4
      minY: 0,
      lineBarsData: linesBarData1(),
    );
  }

  List<LineChartBarData> linesBarData1() {
    final LineChartBarData lineChartBarData1 = LineChartBarData(
      spots: flSpotsFine,
      isCurved: true,
      colors: [
        Colors.green,
      ],
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    final LineChartBarData lineChartBarData2 = LineChartBarData(
      spots: flSpotsNormal,
      isCurved: true,
      colors: [
        Colors.blue,
      ],
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    final LineChartBarData lineChartBarData3 = LineChartBarData(
      spots: flSpotsStress,
      isCurved: true,
      colors: [
        Colors.red,
      ],
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    return [
      lineChartBarData1,
      lineChartBarData2,
      lineChartBarData3,
    ];
  }
}
