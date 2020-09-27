import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smoke_counter/provider/smoke_provider.dart';
import '../../locator.dart';
import 'page2_container_widget.dart';

class Page2Widget extends StatefulWidget {
  @override
  _Page2WidgetState createState() => _Page2WidgetState();
}

class _Page2WidgetState extends State<Page2Widget> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SmokeProvider>(
      create: (context) =>
          locator<SmokeProvider>(), // dependency injectiondan nesne alırız
      child: SafeArea(
        child: Container(
          color: Colors.blue,
          child: Page2ContainerWidget(),
        ),
      ),
    );
  }
}
