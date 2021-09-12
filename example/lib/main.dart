import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_reader_example/page_file_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> iosFiles = [
    'docx.docx',
    'doc.doc',
    'xlsx.xlsx',
    'xls.xls',
    'pptx.pptx',
    'ppt.ppt',
    'pdf.pdf',
    'txt.txt',
    'jpg.jpg',
    'jpeg.jpeg',
    'png.png',
  ];

  List<String> androidFiles = [
    'docx.docx',
    'doc.doc',
    'xlsx.xlsx',
    'xls.xls',
    'pptx.pptx',
    'ppt.ppt',
    'pdf.pdf',
    'txt.txt',
  ];

  List<String> files = [];

  @override
  void initState() {
    if (Platform.isAndroid) {
      files = androidFiles;
    } else if (Platform.isIOS) {
      files = iosFiles;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('File Reader'),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          String filePath = files[index];
          List<String> testFiles = filePath.split('.');
          String title = testFiles[0];
          String type = testFiles[1];

          return GestureDetector(
            onTap: () {
              onTap(type, 'assets/files/$filePath');
            },
            child: Container(
              height: 50,
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 8.0),
              color: Theme.of(context).primaryColor,
              child: Text(title, style: TextStyle(color: Colors.white)),
            ),
          );
        },
        itemCount: files.length,
      ),
    );
  }

  onTap(String type, String assetPath) async {
    bool isGranted = await Permission.storage.isGranted;
    if (!isGranted) {
      isGranted = (await Permission.storage.request()).isGranted;
      if (!isGranted) {
        print("NO Storage Permission");
        return;
      }
    }

    String filePath = await setFilePath(type, assetPath);
    if (!await asset2Local(type, assetPath)) {
      return;
    }

    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
      return FileReaderPage(filePath: filePath);
    }));
  }

  setFilePath(String type, String assetPath) async {
    final Directory _directory = await getTemporaryDirectory();
    String dic = "${_directory.path}/filereader/";
    return dic + base64.encode(utf8.encode(assetPath)) + "." + type;
  }

  fileExists(String filePath) async {
    if (await File(filePath).exists()) {
      return true;
    }
    return false;
  }

  asset2Local(String type, String assetPath) async {
    String filePath = await setFilePath(type, assetPath);

    File file = File(filePath);
    if (await fileExists(filePath)) {
      await file.delete();
    }

    await file.create(recursive: true);
    debugPrint("文件路径 -> " + file.path);
    ByteData bd = await rootBundle.load(assetPath);
    await file.writeAsBytes(bd.buffer.asUint8List(), flush: true);
    return true;
  }
}
