# Flutter File Reader

>本地File文件视图
>
>支持Android、iOS

#### Android 由 [Tencent X5](https://x5.tencent.com/docs/index.html) 实现，iOS 由 [WKWebView](https://developer.apple.com/documentation/webkit/wkwebview) 实现

## 所支持的文件类型
* Android `docx,doc,xlsx,xls,pptx,ppt,pdf,txt`
* IOS `docx,doc,xlsx,xls,pptx,ppt,pdf,txt,jpg,jpeg,png`

## 用法
### iOS
Make sure you add the following key to Info.plist for iOS
```
<key>io.flutter.embedded_views_preview</key><true/>
```