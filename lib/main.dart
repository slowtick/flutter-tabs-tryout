import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Tabs Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Whazzup tabs'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {

  List<int> _pageCounters = [0, 0, 0];
  TabController _tabController;

  /// Increment counter for current tab
  void _incrementCounter() {
    setState(() {
      _pageCounters[_tabController.index]++;
    });
  }

  /// Handle tab navigation via arrow buttons
  void _handleArrowButtonPress(BuildContext context, int delta) {
    if (!_tabController.indexIsChanging)
      _tabController.animateTo((_tabController.index + delta).clamp(0, _pageCounters.length - 1));
  }

  /// Insert a tab (by adding item to tab counter)
  void _addTab() {
    setState(() {
      _pageCounters.insert(_tabController.index, 0);
    });
  }

  /// Remove a tab (by removing item in tab counter)
  void _removeTab() {
    if (_pageCounters.length <= 2)
      return; // tab bar must have at least 2 tabs! not sure why 🤔
    setState(() {
      _pageCounters.removeAt(_tabController.index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).accentColor;
    final TextTheme textTheme = Theme.of(context).textTheme;

    // create tab controller if needed
    if (_tabController == null)
      _tabController = new TabController(length: _pageCounters.length, vsync: this);
    else if (_tabController.length != _pageCounters.length) {
      // happens when a tab is added/removed, recreate tab controller with new length
      // while having tab bar view & tab page selector retain current selection
      _tabController = new TabController(
          initialIndex: min(_tabController.index, _pageCounters.length-1),
          length: _pageCounters.length,
          vsync: this);
    }

    // build UI
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
        actions: <Widget>[
          new IconButton(
              icon: const Icon(Icons.tab),
              onPressed: () {_addTab();},
              tooltip: 'Add tab'),
          new IconButton(
              icon: const Icon(Icons.tab_unselected),
              onPressed: () {_removeTab();},
              tooltip: 'Remove tab')
        ]
      ),
      body: new Center(
        child: new Column(
          children: <Widget>[
            new Container(
                margin: const EdgeInsets.only(top: 16.0),
                child: new Row(
                    children: <Widget>[
                      new IconButton(
                          icon: const Icon(Icons.chevron_left),
                          color: color,
                          onPressed: () { _handleArrowButtonPress(context, -1); },
                          tooltip: 'Previous tab'
                      ),
                      new TabPageSelector(controller: _tabController),
                      new IconButton(
                          icon: const Icon(Icons.chevron_right),
                          color: color,
                          onPressed: () { _handleArrowButtonPress(context, 1); },
                          tooltip: 'Next tab'
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween
                )
            ),
            new Expanded(
              child: new TabBarView(
                controller: _tabController,
                children: _pageCounters.map((int counter) {
                  return new Container(
                    padding: const EdgeInsets.all(14.0),
                    child: new Card(
                      child: new Center(child: new Text(
                          'Button tapped $counter time${ counter == 1 ? '' : 's' } in this tab.',
                          style: textTheme.headline
                        ),
                      )
                    ),
                  );
                }).toList()
              ),
            ),
          ]
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
  }
}
