import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_reader/file_reader.dart';

import 'enum_view_status.dart';

///
/// Describe: File View component
///
/// @Author: LiWeNHuI
/// @Date: 2021/9/10
///

class FileReaderView extends StatefulWidget {
  const FileReaderView({
    Key? key,
    required this.filePath,
    this.unSupportPlatformTip,
    this.nonExistentFileTip,
    this.fileFailTip,
    this.loadingWidget,
    this.unSupportFileWidget,
  })  : assert(filePath != null),
        super(key: key);

  ///
  /// local file path
  ///
  final String filePath;

  ///
  /// Platform prompts are not supported
  ///
  final String? unSupportPlatformTip;

  ///
  /// Prompt that the file does not exist
  ///
  final String? nonExistentFileTip;

  ///
  /// File open failed tip
  ///
  final String? fileFailTip;

  ///
  /// Loading Widget
  ///
  final Widget? loadingWidget;

  ///
  /// Unsupported file widget
  ///
  final Widget? unSupportFileWidget;

  @override
  _FileReaderViewState createState() => _FileReaderViewState();
}

class _FileReaderViewState extends State<FileReaderView> {
  EViewStatus eViewStatus = EViewStatus.LOADING;

  @override
  void initState() {
    super.initState();

    changeStatus();
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid || Platform.isIOS) {
      if (eViewStatus == EViewStatus.LOADING) {
        return _buildLoadWidget();
      } else if (eViewStatus == EViewStatus.NON_EXIST_FILE) {
        // Check whether the file exists first
        return _buildUnExistentFileWidget();
      } else if (eViewStatus == EViewStatus.UNSUPPORT_FILE_TYPE) {
        return _buildUnSupportFileWidget();
      } else if (eViewStatus == EViewStatus.ENGINE_FAIL) {
        return _buildEngineFailWidget();
      } else if (eViewStatus == EViewStatus.FAIL) {
        return _buildFileFailWidget();
      } else if (eViewStatus == EViewStatus.SUCCESS) {
        if (Platform.isAndroid) {
          return _createAndroidView();
        } else {
          return _createIosView();
        }
      } else {
        // Default display load widget
        return _buildLoadWidget();
      }
    }

    return Center(
      child: Text(widget.unSupportPlatformTip ?? '当前仅支持Android、iOS平台'),
    );
  }

  ///
  /// Loading Widget
  ///
  Widget _buildLoadWidget() {
    return widget.loadingWidget ??
        Center(
          child: CupertinoActivityIndicator(radius: 14.0),
        );
  }

  ///
  /// non-existent file widget
  ///
  Widget _buildUnExistentFileWidget() {
    return Center(
      child: Text(widget.nonExistentFileTip ?? '文件不存在'),
    );
  }

  ///
  /// Unsupported file type widget
  ///
  Widget _buildUnSupportFileWidget() {
    return widget.unSupportFileWidget ??
        Center(
          child: Text('不支持打开$fileType类型的文件'),
        );
  }

  ///
  /// Engine load fail widget
  ///
  Widget _buildEngineFailWidget() {
    return Center(
      child: Text("引擎加载失败，请重启App后，重试"),
    );
  }

  ///
  /// File fail widget
  ///
  Widget _buildFileFailWidget() {
    return Center(
      child: Text(widget.fileFailTip ?? "文件打开失败"),
    );
  }

  ///
  /// Android Widget
  ///
  Widget _createAndroidView() {
    return AndroidView(
      viewType: "plugins.file_reader/view",
      onPlatformViewCreated: _onPlatformViewCreated,
      creationParams: {
        'filePath': widget.filePath,
        'fileName': fileName,
        'fileType': fileType,
      },
      creationParamsCodec: const StandardMessageCodec(),
    );
  }

  ///
  /// iOS Widget
  ///
  Widget _createIosView() {
    return UiKitView(
      viewType: "plugins.file_reader/view",
      onPlatformViewCreated: _onPlatformViewCreated,
      creationParams: {
        'filePath': widget.filePath,
        'fileName': fileName,
        'fileType': fileType,
      },
      creationParamsCodec: const StandardMessageCodec(),
    );
  }

  _onPlatformViewCreated(int id) async {
    MethodChannel _channel = MethodChannel('${channelName}_$id');

    bool flag = await _channel.invokeMethod('openFile');
    if (!flag) {
      _setStatus(EViewStatus.UNSUPPORT_FILE_TYPE);
    }
  }

  ///
  /// Whether the file exists
  ///
  Future<bool> isExistsFile() async {
    return await File(widget.filePath).exists();
  }

  ///
  /// File name describe
  ///
  String get fileName {
    String path = widget.filePath;

    if (path.isEmpty) {
      return '';
    }

    int i = path.lastIndexOf('/');
    if (i <= -1) {
      return '';
    }
    String fileName = path.substring(i + 1);

    int j = fileName.lastIndexOf('.');
    if (j <= -1) {
      return '';
    }

    return fileName.substring(j + 1);
  }

  ///
  /// File type describe
  ///
  String get fileType {
    String path = widget.filePath;

    if (path.isEmpty) {
      return '';
    }

    int i = path.lastIndexOf('.');
    if (i <= -1) {
      return '';
    }

    return path.substring(i + 1);
  }

  ///
  /// Display different layouts by changing status
  ///
  Future<void> changeStatus() async {
    bool isExists = await isExistsFile();

    if (isExists) {
      if (Platform.isAndroid) {
        EX5Status? eX5status = await FlutterFileReader.getX5Status();
        if (eX5status == EX5Status.success) {
          _setStatus(EViewStatus.SUCCESS);
        } else {
          _setStatus(EViewStatus.ENGINE_FAIL);
        }
      } else {
        _setStatus(EViewStatus.SUCCESS);
      }
    } else {
      _setStatus(EViewStatus.NON_EXIST_FILE);
    }
  }

  _setStatus(EViewStatus e) {
    setState(() {
      if (mounted) eViewStatus = e;
    });
  }
}
