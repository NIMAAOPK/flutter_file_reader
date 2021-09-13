package com.example.file.reader;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;

import com.tencent.smtt.sdk.TbsReaderView;

import java.io.File;
import java.util.Map;

import io.flutter.Log;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.platform.PlatformView;

/**
 * @Author: LiWeNHuI
 * @Date: 2021/9/12
 * @Describe: File Reader View
 */
public class FileReaderView implements PlatformView, MethodCallHandler, TbsReaderView.ReaderCallback {
  static final String TAG = FileReaderView.class.getName();

  private TbsReaderView mTbsReaderView;

  private MethodChannel channel;

  private final String tempPrefixPath;

  private String filePath = "";
  private String fileName = "";
  private String fileType = "";

  FileReaderView(Context context, int viewId, Map<String, Object> args, BinaryMessenger messenger) {
    Log.e(TAG, "FileReaderView start");

    tempPrefixPath = context.getCacheDir() + File.separator + "TbsFileReaderTmp";

    if (args.containsKey("filePath")) {
      filePath = (String) args.get("filePath");
    }

    if (args.containsKey("fileName")) {
      fileName = (String) args.get("fileName");
    }

    if (args.containsKey("fileType")) {
      fileType = (String) args.get("fileType");
    }

    channel = new MethodChannel(messenger, FlutterFileReaderPlugin.channelName + "_" + viewId);
    channel.setMethodCallHandler(this);

    mTbsReaderView = new TbsReaderView(context, this);
    mTbsReaderView.setLayoutParams(new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
    switch (call.method) {
      case "openFile":
        if (isSupportFile()) {
          openFile();
          result.success(true);
        } else {
          result.success(false);
        }
        break;
    }
  }

  /**
   * Open File
   */
  private void openFile() {
    File tempFile = new File(tempPrefixPath);
    if (!tempFile.exists() || !tempFile.isDirectory()) {
      tempFile.mkdir();
    }

    // 加载文件
    Bundle bundle = new Bundle();
    bundle.putString("filePath", filePath);
    bundle.putBoolean("is_bar_show", false);
    bundle.putBoolean("menu_show", false);
    bundle.putBoolean("is_bar_animating", false);
    bundle.putString("tempPath", tempPrefixPath);
    mTbsReaderView.openFile(bundle);
  }

  /**
   * Determine whether the file can be opened
   *
   * @return
   */
  boolean isSupportFile() {
    return mTbsReaderView.preOpen(fileType, false);
  }

  @Override
  public void onCallBackAction(Integer integer, Object o, Object o1) {

  }

  @Override
  public View getView() {
    return mTbsReaderView;
  }

  @Override
  public void dispose() {
    Log.e(TAG, "FileReaderView dispose");
    mTbsReaderView.onStop();
    mTbsReaderView = null;

    channel.setMethodCallHandler(null);
    channel = null;
  }
}
