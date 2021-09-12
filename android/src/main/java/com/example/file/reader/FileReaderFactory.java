package com.example.file.reader;

import android.content.Context;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

/**
 * @Author: LiWeNHuI
 * @Date: 2021/9/12
 * @Describe: File Reader View Factory
 */
public class FileReaderFactory extends PlatformViewFactory {
  private final BinaryMessenger mBinaryMessenger;
  private Context mContext;

  public FileReaderFactory(BinaryMessenger messenger, Context context) {
    super(StandardMessageCodec.INSTANCE);
    this.mBinaryMessenger = messenger;
    this.mContext = context;
  }

  @Override
  public PlatformView create(Context context, int viewId, Object args) {
    Map<String, Object> params = (Map<String, Object>) args;

    return new FileReaderView(mContext, viewId, params, mBinaryMessenger);
  }
}
