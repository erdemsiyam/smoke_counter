import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smoke_counter/provider/smoke_provider.dart';
import 'package:smoke_counter/widget/page2/chart_line_smoke_widget.dart';
import 'package:smoke_counter/widget/page2/chart_line_stress_widget.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;

class Page2ContainerWidget extends StatefulWidget {
  @override
  _Page2ContainerWidgetState createState() => _Page2ContainerWidgetState();
}

class _Page2ContainerWidgetState extends State<Page2ContainerWidget> {
  SmokeProvider _smokeProvider;

  @override
  void initState() {
    super.initState();

    // build tamamlandıktan sonra, üstteki last,today,total yazılarını getir
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Başlangıçta ilk gösterim için bugünün verileri çağırılır
      DateTime dtNow = DateTime.now();
      _smokeProvider.getChartsData(dtNow, dtNow);
    });
  }

  @override
  Widget build(BuildContext context) {
    _smokeProvider = Provider.of<SmokeProvider>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Flexible(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Material(
                color: Colors.blue,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: 26,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
        // Tarih aralığı seç butonu
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8, left: 20, right: 20),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              child: Text(
                'Select Date Range',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 18,
                ),
              ),
              color: Colors.white,
              highlightColor: Colors.blue[200],
              splashColor: Colors.blue[200],
              onPressed: () async {
                List<DateTime> picked = await DateRangePicker.showDatePicker(
                  // Bunu kullanabilmek için widgetimiz stateful olmalı
                  context: context,
                  initialFirstDate: (new DateTime.now()).add(
                    new Duration(
                      days: -7,
                    ),
                  ),
                  initialLastDate: new DateTime.now(),
                  firstDate: new DateTime(2020),
                  lastDate: new DateTime(2022),
                );
                if (picked != null && picked.length == 2) {
                  print(picked[0]);
                  print(picked[1]);
                  _smokeProvider.getChartsData(picked[0], picked[1]);
                }
              },
            ),
          ),
        ),
        // Grafik 1 : 00-24 arası  stress ve sigara içme ortalaması
        Flexible(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              child: Container(
                color: Colors.white,
                child: ChartLineSmoke(),
              ),
            ),
          ),
        ),
        // Grafik 3 : Stresslere göre sigara içme oranı
        Flexible(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              child: ChartLineStress(),
            ),
          ),
        ),
      ],
    );
  }
}
