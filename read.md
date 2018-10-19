# 一个用Flutter写的阅读器
&emsp;&emsp;项目代码我放到了GitHub上，[项目地址](https://github.com/linguanghua/read_app2)
&emsp;&emsp;***文末有效果图***

&emsp;&emsp;学习Flutter也有段时间了，但是一直没有想到用它来写个什么，这次有机会就直接用它来写了一个阅读工具。Flutter的学习建议大家花点时间，先了解一下[Dart语言](https://www.dartlang.org/guides/get-started)，浏览它的语法、风格，这样不至于在学习Flutter的过程中出现代码语法或风格的一些不理解的地方。

&emsp;&emsp;关于Flutter的安装，我之前写过一个记录：[Flutter之安装与体验](https://linguanghua.github.io/blog/2018/04/10/Flutter之安装与体验/)，Windows环境的，希望能对大家有所帮助。

&emsp;&emsp;为啥写这个应用，源于国庆去西安玩了一趟，深感那边大唐文化氛围的浓郁。回来之后想要了解一些唐朝过去的历史。然后在网上找到了黎东方先生的 细说历史系列丛书，但是都是txt格式的，不能方便的在手机上看，所以想着写一个读书工具。于是有了这个应用工具，我起了个名字叫：阅简阁。希望以后有更多的书能放上去。现在上面可以看的有：

  1.细说秦汉 <br />
  2.细说三国 <br />
  3.细说两晋南北朝 <br />
  4.细说隋唐 <br />
  5.细说宋朝 <br />
  6.细说明朝 <br />
  7.细说清朝 <br />
  8.细说民国初创 <br />
  9.细说抗战  <br />
 
 
#技术
 相关技术网站：<br />
 &emsp;&emsp;1.[Flutter中文网](https://flutterchina.club)<br />
 &emsp;&emsp;2.[Flutter官网](https://flutter.io/get-started/install/)<br />


####一、文件加载
 
&emsp;&emsp;这个阅读应用读取的是txt文件，本来按照写Android的思路是直接在res目录下创建资源目录，然后用Java的文件读写操作去读取文件内容的。但是在Flutter当中，按照Flutter存放资源位置规则，我在根目录下新建txt目录，把文件放进去，却是没办法拿到这个资源目录。查看官网文档发现Flutter在代码中获取文件目录现在支持使用**PathProvider** 插件的两个目录：
 >临时目录: 系统可随时清除的临时目录（缓存）。在iOS上，这对应于NSTemporaryDirectory() 返回的值。在Android上，这是getCacheDir()返回的值。 
 >文档目录: 应用程序的目录，用于存储只有自己可以访问的文件。只有当应用程序被卸载时，系统才会清除该目录。在iOS上，这对应于NSDocumentDirectory。在Android上，这是AppData目录。
 
&emsp;&emsp;一直没找到方法通过代码找到资源文件的目录，然后以文件读取的方式读取文件。所以文件内容的加载只能采用assets静态资源加载。这种加载方式很简单：
 
 第一步、在*pubspec.yaml*文件声明好资源位置：<br />
 ```
 assets:
        - txt/qinhan.txt
 ```
 
 第二步、在代码中使用```rootBundle.loadString(path)```加载文件即可。[assets静态资源加载详情](https://flutterchina.club/assets-and-images/)

代码如下：
```
  Future<String> _loadString() async {
    //异步加载文件数据，返回一个String
    return await rootBundle.loadString(_path);
  }

   @override
  void initState() {
    super.initState();
    _loadString().then((String contents) {
      setState(() {
        List<String> list = contents.split('*****');

        list.forEach((String content) {
          widgets.add(_getTextView(content));//段落内容
          widgets.add(new Divider());//添加分割线
        });
      });
    });
  }
```
&emsp;&emsp;获取到文章内容之后，我将文章切割成几个段落，然后放到ListView中，方便滑动显示。**then**方法是异步操作Future的一个方法，它在等待**await**操作返回之后执行。
 
####二、ListView
&emsp;&emsp;这个项目由两个地方使用到了ListView：第一处：显示文章名字；第二处，显示文章内容；
&emsp;&emsp;因为文章是一次性加载出来，为了能够更好的滑动，这里需要使用到ListView。这里我将文件分割成了多个段落，切割之后，放到再ListView里面。
&emsp;&emsp;**以第一处为例，Flutter创建可以无限滑动的ListView的方法：**
```
   new ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: 2*bookInfo.length,
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
&emsp;&emsp;**padding**是ListView的内边距，**itemBuilder**是创建ListView的每个item。**itemCount**指明了这个ListView有多少个item，这里使用**2*bookInfo.length**的原因是我想在每个item之间添加分割线。ListView的item之间的分割线很好实现，新建一个**Divider** 的实例就可以了。 <br />
 
&emsp;&emsp;下面看ListView的item创建方法：<br />
```
 final _isFavorite = _favoriteBooks.contains(bookMap['title']);
    new ListTile(
      title: new Row(
        children: <Widget>[
          new Icon(Icons.book),//这是书名左边icon
          new Text(//书名
            bookMap['title'],
            textDirection: TextDirection.ltr,
            style: new TextStyle(fontSize: 16.0),
          )
        ],
      ),
      trailing: new IconButton(//右边的IconButton
          icon: new Icon(
            _isFavorite ? Icons.favorite : Icons.favorite_border,
            color: _isFavorite ? Colors.red : null,
          ),
          onPressed: _buttonOnPressed
      ),
      onTap: _pushBook,
    );
```
&emsp;&emsp;**ListTile**是专门用于创建ListView的item的类，它的属性有：
&emsp;&emsp;***title*** 用了一个Row用于在左边显示一个书本的**Icon** 和一个书名。
&emsp;&emsp;***trailing*** 是右边显示一个*IconButton* 是一个爱心图标，它的样式根据用户的点击行为而改变（点击之后会把这本书书名加入到_favoriteBooks中）。**onPressed** 是这个IconButton的点击事件。
&emsp;&emsp;***onTap*** 是ListView的item的点击响应事件。
 
&emsp;&emsp;下面看_buttonOnPressed函数，它由IconButton点击事件触发：
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
&emsp;&emsp;这个函数根据用户点击行为，将特定的书加入到_favoriteBooks，而在现实样式的时候，根据这个IconButton对应的书本是否在_favoriteBooks中，作出相应动作。再看 ***setState*** 方法，这个方法调用会为State对象触发build()方法，从而对UI进行更新。 

&emsp;&emsp;再看item的点击函数_pushBook：
```
// 跳转函数
    _pushBook() {
      Navigator.of(context)
          .push(new MaterialPageRoute(builder: (context) {
        return new LoadData(bookMap['title'], bookMap['path']);
      }));
    }
```
&emsp;&emsp;这个函数是响应item的点击事件，点击item的时候，跳转到另一个页面，在这个新的页面显示书本的内容。这个跳转就对应于Android的activity跳转。下面是[Flutter中文网](https://flutterchina.club/routing-and-navigation/)对页面跳转的介绍。这里return的时候直接new了一个另一个页面的实例，传递参数在构造函数中传递，比Intent方便一些。

>Route和 Navigator。 一个route是一个屏幕或页面的抽象，Navigator是管理route的Widget。Navigator可以通过route入栈和出栈来实现页面之间的跳转。

##最后的效果
#### iPhone
 ![iPhone效果](https://github.com/linguanghua/read_app2/blob/master/app_file/iphone-1.png "Android效果")
 &emsp;&emsp;&emsp;&emsp;
 ![iPhone效果](https://github.com/linguanghua/read_app2/blob/master/app_file/iphone-2.png "Android效果")
 <br />
#### Android
 ![Android效果](https://github.com/linguanghua/read_app2/blob/master/app_file/android-1.png "Android效果")
 
 


 