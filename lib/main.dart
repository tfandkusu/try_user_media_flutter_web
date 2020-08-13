import 'package:flutter/material.dart';
import 'dart:ui' as ui;
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // platformViewRegistryはAndroid Studioで赤くなるがビルドはできる
    ui.platformViewRegistry.registerViewFactory('videoView', (int viewId) {
      // ここはWebのJavaScriptの世界
      // videoタグとエラー表示のためのspanタグを重ねて表示するためのdiv要素
      final div = DivElement();
      div.style.position = 'relative';
      // エラーメッセージ表示spanタグ
      final span = SpanElement();
      span.style.position = 'absolute';
      span.style.color = '#ff1744';
      span.style.fontSize = '20px';
      span.style.left = '16px';
      span.style.top = '16px';
      // HTMLのvideoタグ
      final video = VideoElement();
      video.width = 1920;
      video.height = 1080;
      video.style.backgroundColor = '#000';
      video.style.width = '100%';
      video.style.height = '100%';
      // ソースが設定されたら自動再生
      video.autoplay = true;
      // Webカメラを要求する
      window.navigator.getUserMedia(video: true).then((stream) {
        // Webカメラへの接続が成功
        video.srcObject = stream;
      }).catchError((error) {
        // Webカメラに接続出来ないケース
        if(error is DomException) {
          if(error.name == 'NotFoundError')
            span.innerText = 'カメラがありません';
          else if(error.name == 'NotAllowedError')
            span.innerText = 'カメラが許可されていません';
          else
            span.innerText = '未知のエラーです';
        }
      });
      div.append(video);
      div.append(span);
      return div;
    });
    return MaterialApp(
      title: 'Web Camera Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Web Camera Test'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      // ui.platformViewRegistry.registerViewFactoryメソッド呼び出しの
      // viewType引数と合わせる
      body: HtmlElementView(viewType: 'videoView'),
    );
  }
}
