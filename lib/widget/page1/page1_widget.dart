import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smoke_counter/provider/smoke_provider.dart';
import 'package:smoke_counter/widget/page1/top_part_widget.dart';
import '../../locator.dart';

class Page1Widget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SmokeProvider>(
      create: (context) => locator<SmokeProvider>(),
      child: SafeArea(
        child: Container(
          color: Colors.blue,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // üst beyaz bölüm
              Flexible(
                flex: 10,
                child: Container(
                  alignment: Alignment.center,
                  child: TopPartWidget(),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(120),
                    ),
                  ),
                ),
              ),
              // alt mavi bölüm
              Flexible(
                flex: 2,
                child: Container(
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
