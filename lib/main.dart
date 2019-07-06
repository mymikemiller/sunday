import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:photo_view/photo_view.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart'; // Contains HTML parsers to generate a Document object
import 'package:html/dom.dart'; // Contains DOM related classes for extracting data from elements

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
  final _pageLoadController = PagewiseLoadController<PageModel>(
      pageSize: 6, pageFuture: BackendService.getPage);
  @override
  Widget build(BuildContext context) {
    return PagewiseListView(
      itemBuilder: this._itemBuilder,
      pageLoadController: this._pageLoadController,
    );

    //   return RefreshIndicator(
    //     onRefresh: () async {
    //       this._pageLoadController.reset();
    //       await Future.value({});
    //     },
    //     child: PagewiseListView(
    //       itemBuilder: this._itemBuilder,
    //       pageLoadController: this._pageLoadController,
    //     ),
    //   );
    // }

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
  }

  Widget _itemBuilder(context, PageModel entry, _) {
    return SizedBox(
      width: 200.0,
      height: 300.0,
      child: Card(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey[200],
              image: DecorationImage(
                  image: NetworkImage(entry.imageUrl), fit: BoxFit.fill)),
        ),
      ),
    );

    //Container(
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
  // Returns the page at [pageNumber] plus the next 2.
  static Future<List<PageModel>> getPage(pageNumber) async {
    final archiveHtml =
        (await http.get('http://www.trippingoveryou.com/comic/archive')).body;

    final archiveDocument = parse(archiveHtml);
    // todo: cache the whole list
    const totalPages = 3;
    final options = archiveDocument
        .querySelectorAll('select[name="comic"]>option')
        .sublist(
            pageNumber +
                1, // Add one to offset for the leading "select a comic" entry
            pageNumber + 1 + totalPages);
    final pages = List<PageModel>();
    for (var option in options) {
      // Get the page image url by visiting the page
      final pageUrl =
          'http://www.trippingoveryou.com/' + option.attributes['value'];
      final pageHtml = (await http.get(pageUrl)).body;
      final pageDocument = parse(pageHtml);
      final img = pageDocument.querySelector('#cc-comic');
      final imageUrl = img.attributes['src'];
      final hoverText = img.attributes['title'];

      pages.add(PageModel(option.text, pageUrl, imageUrl));
    }
    return pages;
  }
}

class PageModel {
  String title;
  String id;
  String pageUrl;
  String imageUrl;

  PageModel(title, pageUrl, imageUrl) {
    this.title = title;
    this.pageUrl = pageUrl;
    this.imageUrl = imageUrl;
  }
}
