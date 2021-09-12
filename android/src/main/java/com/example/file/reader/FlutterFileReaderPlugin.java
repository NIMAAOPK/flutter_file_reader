package com.example.file.reader;

import android.app.Activity;
import android.content.Context;
import android.util.Log;

import androidx.annotation.NonNull;

import com.tencent.smtt.export.external.TbsCoreSettings;
import com.tencent.smtt.sdk.QbSdk;
import com.tencent.smtt.sdk.TbsDownloader;
import com.tencent.smtt.sdk.TbsListener;

import java.util.HashMap;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;

/**
 * FlutterFileReaderPlugin
 */
public class FlutterFileReaderPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
  static final String TAG = FlutterFileReaderPlugin.class.getName();

  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;

  // 状态值
  // 0 尚未初始化
  // 1 正在初始化
  // 10 初始化成功
  // 11 初始化失败
  // 20 下载成功
  // 21 下载失败
  // 22 正在下载
  // 30 安装成功
  // 31 安装未成功
  public int initX5Status = 0;

  public static final String channelName = "flutter_file_reader.io.method";
  private FlutterPluginBinding mFlutterPluginBinding;
  private Context mContext;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), channelName);
    channel.setMethodCallHandler(this);

    this.mFlutterPluginBinding = flutterPluginBinding;
    this.mContext = mFlutterPluginBinding.getApplicationContext();
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    switch (call.method) {
      case "getPlatformVersion":
        result.success("Android " + android.os.Build.VERSION.RELEASE);
        break;
      case "initX5Status":
        result.success(getInitX5Status());
        break;
      case "flutterUse":
        initX5ByFlutter(result);
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  /**
   * 初始化 X5
   */
  public void initX5() {
    if (mContext == null) {
      return;
    }

    // 内核加载成功后，无须重复加载
    if (initX5Status == 10) {
      return;
    }

    Log.e(TAG, "初始化X5");

    // 更改初始化状态
    initX5Status = 1;

    /// 不获取 AndroidID
    QbSdk.canGetAndroidId(false);
    /// 不获取 IMEI（设备识别码）
    QbSdk.canGetDeviceId(false);
    /// 不获取 IMSI（用户识别码）
    QbSdk.canGetSubscriberId(false);

    resetQbSdk();

    // 在调用TBS初始化、创建WebView之前进行如下配置，以开启优化方案
    HashMap<String, Object> map = new HashMap<>();
    map.put(TbsCoreSettings.TBS_SETTINGS_USE_SPEEDY_CLASSLOADER, true);
    map.put(TbsCoreSettings.TBS_SETTINGS_USE_DEXLOADER_SERVICE, true);
    QbSdk.initTbsSettings(map);

    QbSdk.setDownloadWithoutWifi(true);
    QbSdk.setTbsListener(new TbsListener() {
      @Override
      public void onDownloadFinish(int i) {
        initX5Status = i == 100 ? 20 : 21;
        Log.e(TAG, "TBS下载完成 - " + i + " - " + showStatus(i == 100));
      }

      @Override
      public void onInstallFinish(int i) {
        initX5Status = i == 200 ? 30 : 31;
        Log.e(TAG, "TBS安装完成 - " + i + " - " + showStatus(i == 200));
      }

      @Override
      public void onDownloadProgress(int i) {
        initX5Status = i > 0 && i <= 100 ? 22 : 20;
        Log.e(TAG, "TBS下载进度:" + i);
      }
    });

    QbSdk.PreInitCallback onQbSdkPreInitCallback = new QbSdk.PreInitCallback() {
      @Override
      public void onCoreInitFinished() {
        Log.e(TAG, "TBS内核初始化完毕");
      }

      @Override
      public void onViewInitFinished(boolean b) {
        initX5Status = b ? 10 : 11;

        if (!b) {
          resetQbSdk();
        }

        Log.e(TAG, "TBS内核初始化" + showStatus(b) + " - " + QbSdk.canLoadX5(mContext));
      }
    };

    QbSdk.initX5Environment(mContext, onQbSdkPreInitCallback);
    Log.e(TAG, "app是否主动禁用了X5内核: " + QbSdk.getIsSysWebViewForcedByOuter());
  }

  /**
   * 显示 状态
   *
   * @param flag
   * @return
   */
  private String showStatus(boolean flag) {
    return flag ? "成功" : "失败";
  }

  /**
   * 重置 QbSdk
   */
  private void resetQbSdk() {
    if (mContext != null && !QbSdk.canLoadX5(mContext)) {
      // 重置
      QbSdk.reset(mContext);
    }
  }

  /**
   * 获取X5初始化状态
   *
   * @return
   */
  private int getInitX5Status() {
    Log.e(TAG, "获取内核加载状态 - " + initX5Status);
    return initX5Status;
  }

  /**
   * 初始化 X5内核
   * Flutter 代码使用
   *
   * @param result
   */
  private void initX5ByFlutter(Result result) {
    if (mContext == null) {
      result.success(0);

      return;
    }

    if (initX5Status == 0) {
      initX5();
      result.success(1);
    } else if (initX5Status == 1 || initX5Status == 10) {
      // 正在初始化 / 内核加载完成，无须重复操作
      result.success(0);
    } else if (initX5Status == 11) {
      if (QbSdk.canLoadX5(mContext)) {
        // 重启app
        result.success(-1);
      } else {
        initX5();
        result.success(1);
      }
    } else if (initX5Status == 20 || initX5Status == 22) {
      // 下载完成 / 正在下载，无须重复操作
      result.success(0);
    } else if (initX5Status == 21) {
      TbsDownloader.startDownload(mContext);
      result.success(1);
    } else {
      result.success(0);
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    // 清空数据
    channel.setMethodCallHandler(null);
    this.mFlutterPluginBinding = null;
    this.mContext = null;
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    Log.e(TAG, "onAttachedToActivity");

    // App启动时，开始初始化X5内核
    initX5();

    // 因FileReaderView问题，故在此注册
    String viewTypeId = "plugins.file_reader/view";
    mFlutterPluginBinding.getPlatformViewRegistry().registerViewFactory(viewTypeId,
        new FileReaderFactory(mFlutterPluginBinding.getBinaryMessenger(), binding.getActivity()));
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    Log.e(TAG, "onDetachedFromActivityForConfigChanges");
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    Log.e(TAG, "onReattachedToActivityForConfigChanges");
  }

  @Override
  public void onDetachedFromActivity() {
    Log.e(TAG, "onDetachedFromActivity");
  }
}
