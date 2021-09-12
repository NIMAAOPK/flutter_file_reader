import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_reader/file_reader.dart';

///
/// Describe:
///
/// @Author: LiWeNHuI
/// @Date: 2021/9/12
///

class FileReaderPage extends StatefulWidget {
  final String filePath;

  FileReaderPage({Key? key, required this.filePath}) : super(key: key);

  @override
  _FileReaderPageState createState() => _FileReaderPageState();
}

class _FileReaderPageState extends State<FileReaderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("文档"),
      ),
      body: FileReaderView(
        filePath: widget.filePath,
      ),
    );
  }
}
