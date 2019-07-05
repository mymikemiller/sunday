import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:photo_view/photo_view.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sunday',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Tripping Over You'),
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ComicViewer(),
    );
  }
}

class ComicViewer extends StatelessWidget {
  final _pageLoadController = PagewiseLoadController<ImageModel>(
      pageSize: 6, pageFuture: BackendService.getPage);
  @override
  Widget build(BuildContext context) {
    // return Container(
    //   color: Colors.red,
    // );
    return PagewiseListView(
      itemBuilder: this._itemBuilder,
      pageLoadController: this._pageLoadController,
    );

    return RefreshIndicator(
      onRefresh: () async {
        this._pageLoadController.reset();
        await Future.value({});
      },
      child: PagewiseListView(
        itemBuilder: this._itemBuilder,
        pageLoadController: this._pageLoadController,
      ),
    );
  }

  // return Container(
  //   child: ClipRect(
  //     // child: PhotoView.customChild(
  //     child: ListView(
  //       children: <Widget>[
  //         Image.network(
  //             'http://www.trippingoveryou.com/comics/1555002384-tripping17_09.png'),
  //         Image.network(
  //             'http://www.trippingoveryou.com/comics/1555992572-tripping17_11.png'),
  //         Image.network(
  //             'http://www.trippingoveryou.com/comics/1556420041-tripping17_12.png'),
  //         Image.network(
  //             'http://www.trippingoveryou.com/comics/1556678034-tripping17_13.png'),
  //       ],
  //     ),
  //     //   childSize: const Size(820.0, 850.0),
  //     //   initialScale: 1.0,
  //     // ),
  //   ),
  // );
  // }

  Widget _itemBuilder(context, ImageModel entry, _) {
    return Container(color: Colors.red); //Container(
    // decoration: BoxDecoration(
    //   border: Border.all(color: Colors.grey[600]),
    // ),
    // child: Column(
    // mainAxisAlignment: MainAxisAlignment.start,
    // crossAxisAlignment: CrossAxisAlignment.start,
    // children: [
    // Expanded(
    //   child: Container(
    //     decoration: BoxDecoration(
    //         color: Colors.grey[200],
    //         image: DecorationImage(
    //             image: NetworkImage(entry.thumbnailUrl),
    //             fit: BoxFit.fill)),
    //   ),
    // ),
    // SizedBox(height: 8.0),
    // Expanded(
    //   child: Padding(
    //       padding: EdgeInsets.symmetric(horizontal: 8.0),
    //       child: SizedBox(
    //           height: 30.0,
    //           child: SingleChildScrollView(
    //               child: Text(entry.title,
    //                   style: TextStyle(fontSize: 12.0))))),
    // ),
    // SizedBox(height: 8.0),
    // Padding(
    //   padding: EdgeInsets.symmetric(horizontal: 8.0),
    //   child: Text(
    //     entry.id,
    //     style: TextStyle(fontWeight: FontWeight.bold),
    //   ),
    // ),
    // SizedBox(height: 8.0)
    // ])
    // );
  }
}

class BackendService {
  // static get http => null;

  // static Future<List<PostModel>> getPosts(offset, limit) async {
  //   final responseBody = (await http.get(
  //           'http://jsonplaceholder.typicode.com/posts?_start=$offset&_limit=$limit'))
  //       .body;

  //   // The response body is an array of items
  //   return PostModel.fromJsonList(json.decode(responseBody));
  // }

  // Returns the page at [pageNumber] plus the next 2.
  static Future<List<ImageModel>> getPage(pageNumber) async {
    var fut = http.get(
        'http://jsonplaceholder.typicode.com/photos?_start=$pageNumber&_limit=3');
    var resp = await fut;
    final responseBody = resp.body;

    // final responseBody = (await http.get(
    //         'http://jsonplaceholder.typicode.com/photos?_start=$pageNumber&_limit=3'))
    //     .body;

    // The response body is an array of items.
    return ImageModel.fromJsonList(json.decode(responseBody));
  }

  static Future<List<ImageModel>> getImages(offset, limit) async {
    final responseBody = (await http.get(
            'http://jsonplaceholder.typicode.com/photos?_start=$offset&_limit=3'))
        .body;

    // The response body is an array of items.
    return ImageModel.fromJsonList(json.decode(responseBody));
  }
}

class PostModel {
  String title;
  String body;

  PostModel.fromJson(obj) {
    this.title = obj['title'];
    this.body = obj['body'];
  }

  static List<PostModel> fromJsonList(jsonList) {
    return jsonList.map<PostModel>((obj) => PostModel.fromJson(obj)).toList();
  }
}

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

class PageModel {
  String title;
  String url;
  String imageUrl;

  PageModel.fromJson(obj) {
    this.title = obj['title'];
    this.url = obj['url'].toString();
    this.imageUrl = obj['imageUrl'];
  }

  static List<PageModel> fromJsonList(jsonList) {
    return jsonList.map<PageModel>((obj) => PageModel.fromJson(obj)).toList();
  }
}
