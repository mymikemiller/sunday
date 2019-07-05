import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:http/http.dart' as http;
import 'package:photo_view/photo_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: ComicViewer(),
    );
  }
}

// from PagewiseListViewExample here:
//https://github.com/AbdulRahmanAlHamali/flutter_pagewise/blob/master/example/lib/main.dart
class ComicViewer extends StatelessWidget {
  static const int PAGE_SIZE = 3;

  @override
  Widget build(BuildContext context) {
    return PagewiseListView(
        pageSize: PAGE_SIZE,
        itemBuilder: this._itemBuilder,
        pageFuture: (pageIndex) =>
            BackendService.getImages(pageIndex * PAGE_SIZE, PAGE_SIZE));
  }

  // Widget _itemBuilder(context, PostModel entry, _) {
  //   return Column(
  //     children: <Widget>[
  //       ListTile(
  //         leading: Icon(
  //           Icons.person,
  //           color: Colors.brown[200],
  //         ),
  //         title: Text(entry.title),
  //         subtitle: Text(entry.body),
  //       ),
  //       Divider()
  //     ],
  //   );
  // }

  Widget _itemBuilder(context, ImageModel entry, _) {
    print('building item ' + entry.id + ': ' + entry.thumbnailUrl);

    return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[600]),
        ),
        child: Column(
          children: <Widget>[
            // Image.network(
            //     'https://images.pexels.com/photos/67636/rose-blue-flower-rose-blooms-67636.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500'),
            Container(
              child: PhotoView.customChild(
                child: Container(
                    decoration:
                        const BoxDecoration(color: Colors.lightGreenAccent),
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          "Hello there, this is a text, that is a svg:",
                          style: const TextStyle(fontSize: 10.0),
                          textAlign: TextAlign.center,
                        ),
                        Image.network(
                          'https://images.pexels.com/photos/67636/rose-blue-flower-rose-blooms-67636.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500',
                          height: 100.0,
                        )
                      ],
                    )),
                childSize: const Size(220.0, 250.0),
                initialScale: 1.0,
              ),

              // PhotoView(
              //   imageProvider: NetworkImage(
              //       "https://images.pexels.com/photos/67636/rose-blue-flower-rose-blooms-67636.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500"),
              // ),
            ),
            Text(entry.id),
          ],
        ));
    // return Container(
    //   child: PhotoView(
    //     imageProvider: const NetworkImage(
    //         "https://source.unsplash.com/900x1600/?camera,paper"),
    //   ),
    // );

//NetworkImage(entry.thumbnailUrl),);
  }

// Container(
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.grey[600]),
//         ),
//         child: Image.network(entry.thumbnailUrl));
  // return Container(
  //     decoration: BoxDecoration(
  //       border: Border.all(color: Colors.grey[600]),
  //     ),
  //     child: Column(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Expanded(
  //             child: Container(
  //               decoration: BoxDecoration(
  //                   color: Colors.grey[200],
  //                   image: DecorationImage(
  //                       image: NetworkImage(entry.thumbnailUrl),
  //                       fit: BoxFit.fill)),
  //             ),
  //           ),
  //           SizedBox(height: 8.0),
  //           Expanded(
  //             child: Padding(
  //                 padding: EdgeInsets.symmetric(horizontal: 8.0),
  //                 child: SizedBox(
  //                     height: 30.0,
  //                     child: SingleChildScrollView(
  //                         child: Text(entry.title,
  //                             style: TextStyle(fontSize: 12.0))))),
  //           ),
  //           SizedBox(height: 8.0),
  //           Padding(
  //             padding: EdgeInsets.symmetric(horizontal: 8.0),
  //             child: Text(
  //               entry.id,
  //               style: TextStyle(fontWeight: FontWeight.bold),
  //             ),
  //           ),
  //           SizedBox(height: 8.0)
  //         ]));
}

class BackendService {
  // static Future<List<PostModel>> getPosts(offset, limit) async {
  //   final responseBody = (await http.get(
  //           'http://jsonplaceholder.typicode.com/posts?_start=$offset&_limit=$limit'))
  //       .body;

  //   // The response body is an array of items
  //   return PostModel.fromJsonList(json.decode(responseBody));
  // }

  static Future<List<ImageModel>> getImages(offset, limit) async {
    final responseBody = (await http.get(
            'http://jsonplaceholder.typicode.com/photos?_start=$offset&_limit=$limit'))
        .body;

    // The response body is an array of items.
    return ImageModel.fromJsonList(json.decode(responseBody));
  }
}

// class PostModel {
//   String title;
//   String body;

//   PostModel.fromJson(obj) {
//     this.title = obj['title'];
//     this.body = obj['body'];
//   }

//   static List<PostModel> fromJsonList(jsonList) {
//     return jsonList.map<PostModel>((obj) => PostModel.fromJson(obj)).toList();
//   }
// }

class ImageModel {
  String title;
  String id;
  String thumbnailUrl;

  ImageModel.fromJson(obj) {
    this.title = obj['title'];
    this.id = obj['id'].toString();
    this.thumbnailUrl = obj['thumbnailUrl'];
  }

  static List<ImageModel> fromJsonList(jsonList) {
    return jsonList.map<ImageModel>((obj) => ImageModel.fromJson(obj)).toList();
  }
}
