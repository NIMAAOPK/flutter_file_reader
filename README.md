# Flutter File Reader

> A local file view widget
>
> Supports Android and iOS

Language: English | [中文](README-ZH.md)

#### Android is implemented by [Tencent X5](https://x5.tencent.com/docs/index.html), iOS is implemented by [WKWebView](https://developer.apple.com/documentation/webkit/wkwebview).

## Supported file type
* Android `docx,doc,xlsx,xls,pptx,ppt,pdf,txt`
* IOS `docx,doc,xlsx,xls,pptx,ppt,pdf,txt,jpg,jpeg,png`

## Usage
### iOS
Make sure you add the following key to `Info.plist` for iOS
```
<key>io.flutter.embedded_views_preview</key><true/>
```
### Android
1. The X5 kernel loading method has been integrated in the plugin
2. Get the current kernel loading status through `getx5status()`
3. It can be initialized by itself through `initx5()`. It is mainly used to solve the problem of unsuccessful download
4. Android P Unable to download kernel Solution

Add a code in label `application` on File `AndroidManifst.xml`
```
android:networkSecurityConfig="@xml/network_security_config"
```
Add a file named `network_security_config.xml` in the `res/xml` directory, The content of the file is
```
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
  <base-config cleartextTrafficPermitted="true" />
</network-security-config>
```

## READ
1. Not Support Google Play, Reason: [Issues 1.11](https://x5.tencent.com/docs/questions.html)
2. Running on Android emulator is not supported
3. If the txt document displays garbled code, please change the txt document code to GBK