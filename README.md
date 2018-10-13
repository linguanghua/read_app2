# read_app2
一个用flutter写的阅读器。***文末有效果图***

&emsp;&emsp;为啥写这个应用，源于国庆去西安玩了一趟，深感那边大唐文化氛围的浓郁。回来之后想要了解一些唐朝过去的一些历史。然后在网上找到了 
黎东方先生的 细说历史系列丛书，但是都是txt格式的，不能方便的在手机上看，所以想着写一个读书工具。于是有了这个应用工具，起了个名字
叫：阅简阁。希望以后有更多的书能放上去。现在上面可以看的有：

  1.细说秦汉 <br />
  2.细说三国 <br />
  3.细说两晋南北朝 <br />
  4.细说隋唐 <br />
  5.细说宋朝 <br />
  6.细说明朝 <br />
  7.细说清朝 <br />
  8.细说民国初创 <br />
  9.细说抗战  <br />
 
 
 # 技术
 
 技术网站：<br />
 &emsp;&emsp;1.[Flutter中文网](https://flutterchina.club)<br />
 &emsp;&emsp;2.[Flutter官网](https://flutter.io/get-started/install/)<br />


 下面简单说说技术点。
 
 &emsp;&emsp;学习Flutter也有段时间了，但是一直没有想到用它来写个什么，这次有机会就直接用它来写了一个阅读工具。
 
 #### 一、文件加载
 
 &emsp;&emsp;这个阅读应用读取的是txt文件，本来按照写Android的思路是直接在res目录下创建资源目录，然后用Java的文件读写去读取文件内容的。
 但是在Flutter当中，按照Flutter存放资源位置规则，我在根目录下新建txt目录，把文件放进去，却是没办法拿到这个资源目录。
 Flutter在代码中获取文件目录现在仅支持使用**PathProvider** 插件的两个目录：
 >临时目录: 系统可随时清除的临时目录（缓存）。在iOS上，这对应于NSTemporaryDirectory() 返回的值。在Android上，这是getCacheDir()返回的值。<br />
 >文档目录: 应用程序的目录，用于存储只有自己可以访问的文件。只有当应用程序被卸载时，系统才会清除该目录。在iOS上，这对应于NSDocumentDirectory。在Android上，这是AppData目录。
 
 一直没找到方法通过代码找到资源文件的目录。所以文件内容的加载只能采用assets静态资源加载。这种加载方式很简单：
 
 第一步、在*pubspec.yaml*文件声明好资源位置：<br />
 ```
 assets:
        - txt/qinhan.txt
 ```
 
 第二步、在代码中使用```rootBundle.loadString(path)```加载即可。[详情](https://flutterchina.club/assets-and-images/)
 
 
 #### 二、ListView
 
 &emsp;&emsp;因为文章是一次性加载出来，所以显示的话，需要上下滑动，这里我将文件分割成了多个段落，切割之后，放到ListView里面，可以方便的上下滑动。Flutter创建
 可以无限滑动的ListView的方法：
 ```
   new ListView.builder(
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
 ```
 
 &emsp;&emsp;这里还不太懂具体的构建原理。大概看意思是**padding**是内边距，**itemBuilder**应该ListView的每个item创建了，Flutter中分割线很好使用，新建一个
 **Divider** 的实例就可以了。 <br />
 
 下面看_buildRow 方法：<br />
 
  ```
    new ListTile(
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
  ```
 ***title*** 用了一个Row用于在左边显示一个书本的**Icon** 和一个书名。
 
 ***trailing*** 是右边显示一个*IconButton* 是一个爱心图标，它的样式根据用户的点击行为而改变。**onPressed** 是这个IconButton的点击事件。
 
 ***onTap*** 是ListView的item的点击响应事件。
 <br />
 
下面看_buttonOnPressed方法：
```
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
```

这里主要看***setState***方法，这个方法调用会为State对象触发build()方法，从而导致对UI的更新。 

应用还比较简单，后续再慢慢更新。<br />

#####iPhone
 ![iPhone效果](https://github.com/linguanghua/read_app2/blob/master/app_file/iphone-1.png "Android效果")
 ![iPhone效果](https://github.com/linguanghua/read_app2/blob/master/app_file/iphone-2.png "Android效果")
 <br />
 #####Android
 ![Android效果](https://github.com/linguanghua/read_app2/blob/master/app_file/android-1.png "Android效果")
 
 
