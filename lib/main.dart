import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey _globalKey = new GlobalKey();

  bool inside = false;
  late Uint8List imageInMemory;

  Future<Uint8List> _capturePng() async {
    try {
      print('inside');
      inside = true;
      RenderRepaintBoundary boundary = _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List? pngBytes = byteData?.buffer.asUint8List();
//      String bs64 = base64Encode(pngBytes);
//      print(pngBytes);
//      print(bs64);
      print('png done');
      setState(() {
        imageInMemory = pngBytes!;
        inside = false;
      });
      return pngBytes!;
    } catch (e) {
      print(e);
    }
    return imageInMemory;
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _globalKey,
      child: new Scaffold(
          appBar: new AppBar(
            title: new Text('Widget To Image demo'),
          ),
          body: SingleChildScrollView(
            child: Center(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text(
                    'click the button below to capture image',
                  ),
                  new ElevatedButton(
                    child: Text('capture Image'),
                    onPressed: _capturePng,
                  ),
                  inside ? CircularProgressIndicator()
                  :
                  imageInMemory != null
                      ? Container(
                          child: Image.memory(imageInMemory),
                          margin: EdgeInsets.all(10))
                      : Container(),
                ],
              ),
            ),
          )),
    );
  }
}
