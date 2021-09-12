# Flutter File Reader

> 本地File文件视图
>
> 支持Android、iOS

Language: [English](README.md) | 中文

#### Android 由 [Tencent X5](https://x5.tencent.com/docs/index.html) 实现，iOS 由 [WKWebView](https://developer.apple.com/documentation/webkit/wkwebview) 实现

## 所支持的文件类型
* Android `docx,doc,xlsx,xls,pptx,ppt,pdf,txt`
* IOS `docx,doc,xlsx,xls,pptx,ppt,pdf,txt,jpg,jpeg,png`

## 用法
### iOS
请确保将以下键添加到`Info.plist`
```
<key>io.flutter.embedded_views_preview</key><true/>
```
### Android
1. 在插件内已集成加载X5内核方法
2. 通过`getX5Status()`可获取当前内核加载状态
3. 通过`initX5()`，可自行初始化，主要用于解决下载不成功的问题
4. Android P 无法下载内核解决方案

在文件 `AndroidManifst.xml` 的标签 `application` 中添加代码
```
android:networkSecurityConfig="@xml/network_security_config"
android:usesCleartextTraffic="true"
```
在 `res/xml` 目录中添加一个名为 `network_security_config.xml` 的文件, 文件内容为
```
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
  <base-config cleartextTrafficPermitted="true" />
</network-security-config>
```

## 注意事项
1. 不支持Google Play，原因：[问题 1.11](https://x5.tencent.com/docs/questions.html)
2. 不支持在Android 模拟器
3. 如果txt文档显示乱码，请将txt文档代码更改为GBK