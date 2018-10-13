import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(new MaterialApp(
    title: 'load data',
    theme: new ThemeData(primarySwatch: Colors.blue),
    home: new LoadData("",""),
  ));
}

class LoadData extends StatefulWidget {
//  LoadData({Key key}) : super(key: key);
  String _path;
  String _title;
  LoadData(this._title,this._path);
  @override
  _LoadDataState createState() {
    return new _LoadDataState(_title,_path);
  }
}

class _LoadDataState extends State<LoadData> {
  List<Widget> widgets = <Widget>[];
  String _path;
  String _title;
  _LoadDataState(this._title,this._path);
  @override
  void initState() {
    super.initState();
    _loadString().then((String contents) {
      setState(() {
        List<String> list = contents.split('*****');

        list.forEach((String content) {
          widgets.add(_getTextView(content));
          widgets.add(new Divider());
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text(_title)),
        body: new ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemBuilder: (context, i) {
              if(i>=0 && i< widgets.length) {
                return widgets[i];
              }
            }));
  }

  Future<String> _loadString() async {
    return await rootBundle.loadString(_path);
  }

  _getTextView(String content) {
    return new Center(
      child: new Text(
        content,
        textDirection: TextDirection.ltr,
        style: new TextStyle(fontSize: 12.0),
      ),
    );
  }
}
