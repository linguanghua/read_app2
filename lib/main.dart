import 'package:flutter/material.dart';
import 'load_data.dart';

void main() {
  runApp(new MaterialApp(
    title: "中国历史",
    theme: new ThemeData(primarySwatch: Colors.blue),
    home: new BookList(),
  ));
}

class BookList extends StatefulWidget {
  BookList({Key key}) : super(key: key);

  @override
  _BookListState createState() {
    return new _BookListState();
  }
}

class _BookListState extends State<BookList> {
  List<Widget> widgets = <Widget>[];
  List<Map<String, String>> bookInfo = [
    {'path': 'txt/zuozhe.txt', 'title': '作者简介'},
    {'path': 'txt/qinhan.txt', 'title': '细说秦汉'},
    {'path': 'txt/sanguo.txt', 'title': '细说三国'},
    {'path': 'txt/nanbeichao.txt', 'title': '细说两晋南北朝'},
    {'path': 'txt/suitang.txt', 'title': '细说隋唐'},
    {'path': 'txt/songchao.txt', 'title': '细说宋朝'},
    {'path': 'txt/mingchao.txt', 'title': '细说明朝'},
    {'path': 'txt/qingchao.txt', 'title': '细说清朝'},
    {'path': 'txt/minguochuchuang.txt', 'title': '细说民国初创'},
    {'path': 'txt/kangzhan.txt', 'title': '细说抗战'},
  ];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('中国历史'),
      ),
      body: new ListView.builder(
//          padding: const EdgeInsets.all(16.0),
          itemBuilder: (context, i) {
            if (i >= 2*bookInfo.length) {
              return null;
            }
            if(i%2 == 0) {  // 偶数行显示书名
              return _buildRow(i~/2);
            }else{          // 奇数行显示分割线
              return new Divider();
            }
          }),
    );
  }

  final _favoriteBooks = new Set<String>();

  _buildRow(int index) {
    Map<String, String> bookMap = bookInfo[index];

    final _isFavorite = _favoriteBooks.contains(bookMap['title']);

    // 跳转函数
    _pushBook() {
      Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
        return new LoadData(bookMap['title'], bookMap['path']);
      }));
    }

    // 按钮点击函数
    _buttonOnPressed() {
      setState(() {
        if (_isFavorite) {
          _favoriteBooks.remove(bookMap['title']);
        } else {
          _favoriteBooks.add(bookMap['title']);
        }
      });
    }

    return new ListTile(
      title: new Row(
        children: <Widget>[
          new Icon(Icons.book),
          new Text(
            bookMap['title'],
            textDirection: TextDirection.ltr,
            style: new TextStyle(fontSize: 16.0),
          )
        ],
      ),
      trailing: new IconButton(
          icon: new Icon(
            _isFavorite ? Icons.favorite : Icons.favorite_border,
            color: _isFavorite ? Colors.red : null,
          ),
          onPressed: _buttonOnPressed
      ),
      onTap: _pushBook,
    );
  }
}
