import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smoke_counter/provider/smoke_provider.dart';
import 'package:smoke_counter/repository/smoke_repository.dart';
import 'package:smoke_counter/widget/page2/page2_widget.dart';
import 'package:toggle_switch/toggle_switch.dart';

class TopPartWidget extends StatefulWidget {
  @override
  _TopPartWidgetState createState() => _TopPartWidgetState();
}

class _TopPartWidgetState extends State<TopPartWidget> {
  SmokeProvider _smokeProvider;
  int _selectedStressIndex = 1;

  @override
  void initState() {
    super.initState();

    // build tamamlandıktan sonra, üstteki last,today,total yazılarını getir
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Başlangıç için gereken veriler çağırılır
      SmokeRepository.getInitialDatas().then(
        // dbden veriler alınınca üstteki total yazıları için o alan güncellenir
        (value) => _smokeProvider.getCountRefresh(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    _smokeProvider = Provider.of<SmokeProvider>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 2. sayfa geçişi için ikonlu buton
        Flexible(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Material(
                  color: Colors.white,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      size: 26,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Page2Widget()),
                      ).then((value) => {
                            // ikinci sayfadan geri gelişte, son sigara içme zamanı yenilenir
                            _smokeProvider.getCountRefresh()
                          });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        // Last,Today,Total ve değerleri kısmı
        Flexible(
          flex: 8,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Soldaki sabit yazılar
              Flexible(
                flex: 20,
                // child: Container(color: Colors.amber),
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      AnimatedOpacity(
                        opacity: (!_smokeProvider.isCountsAvaible) ? 0 : 1,
                        duration: Duration(seconds: 1),
                        child: Text(
                          'Last',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      AnimatedOpacity(
                        opacity: (!_smokeProvider.isCountsAvaible) ? 0 : 1,
                        duration: Duration(seconds: 2),
                        child: Text(
                          'Today',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      AnimatedOpacity(
                        opacity: (!_smokeProvider.isCountsAvaible) ? 0 : 1,
                        duration: Duration(seconds: 3),
                        child: Text(
                          'Total',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 3,
                child: SizedBox(
                  width: 20,
                ),
              ),
              Flexible(
                flex: 1,
                child: SizedBox(
                  child: Container(
                    color: Colors.blue,
                    width: 3,
                  ),
                ),
              ),
              Flexible(
                flex: 3,
                child: SizedBox(
                  width: 20,
                ),
              ),
              // Sağdaki dinamik sayı değerleri
              Flexible(
                flex: 20,
                // child: Container(color: Colors.amber),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedOpacity(
                        opacity: (!_smokeProvider.isCountsAvaible) ? 0 : 1,
                        duration: Duration(seconds: 1),
                        child: Text(
                          (!_smokeProvider.isCountsAvaible)
                              ? ''
                              : _smokeProvider.lastSmokeTimeLong,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                      AnimatedOpacity(
                        opacity: (!_smokeProvider.isCountsAvaible) ? 0 : 1,
                        duration: Duration(seconds: 2),
                        child: Text(
                          (!_smokeProvider.isCountsAvaible)
                              ? ''
                              : _smokeProvider.todaySmokeCount,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                      AnimatedOpacity(
                        opacity: (!_smokeProvider.isCountsAvaible) ? 0 : 1,
                        duration: Duration(seconds: 3),
                        child: Text(
                          (!_smokeProvider.isCountsAvaible)
                              ? ''
                              : _smokeProvider.totalSmokeCount,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // Boşluk
        SizedBox(
          height: 10,
        ),
        // Stres seçimi ToggleButton
        Flexible(
          flex: 4,
          child: ToggleSwitch(
            minWidth: 100.0,
            minHeight: 60.0,
            fontSize: 16.0,
            cornerRadius: 20,
            initialLabelIndex: 1,
            activeBgColor: Colors.blue,
            activeFgColor: Colors.white,
            inactiveBgColor: Colors.white,
            inactiveFgColor: Colors.blue,
            labels: ['Stress', 'Normal', 'Fine'],
            activeBgColors: [Colors.red, Colors.blue, Colors.green],
            onToggle: (index) {
              _selectedStressIndex = index = (index - 2).abs();
              print('switched to: $index');
            },
          ),
        ),
        SizedBox(),
        Flexible(
          flex: 4,
          child: SizedBox(
            width: 80,
            height: 80,
            child: FloatingActionButton(
              child: Icon(Icons.add, size: 50),
              onPressed: () {
                _smokeProvider.addSmoke(_selectedStressIndex);
              },
            ),
          ),
        ),
      ],
    );
  }
}
