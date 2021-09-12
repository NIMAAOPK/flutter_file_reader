import UIKit
import WebKit

class FileReaderView: NSObject,FlutterPlatformView {

  var _webView: FileReaderWKWebView?
  
  let supportFileType = ["docx","doc","xlsx","xls","pptx","ppt","pdf","txt","jpg","jpeg","png"]

  init(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?,binaryMessenger messenger: FlutterBinaryMessenger) {
    super.init()
    
    let args = args as! [String: String]
    let filePath = args["filePath"] as! String
    let fileType = args["fileType"] as! String
    
    let channel = FlutterMethodChannel(name: channelName + "_\(viewId)", binaryMessenger: messenger)
    
    channel.setMethodCallHandler { (call, result) in
      if call.method == "openFile" {
        if self.isSupportOpen(fileType: fileType){
          self.openFile(filePath: filePath)
          
          result(true)
        } else {
          result(false)
        }
        return
      }
    }
    
    self._webView = FileReaderWKWebView.init(frame: frame)
  }
  
  func openFile(filePath:String)  {
    let url = URL.init(fileURLWithPath: filePath)
    
    if #available(iOS 9.0, *) {
      _webView?.loadFileURL(url, allowingReadAccessTo: url)
    } else {
      let request = URLRequest.init(url: url)
      _webView?.load(request)
    }
  }

  func isSupportOpen(fileType:String) -> Bool {
    if supportFileType.contains(fileType.lowercased()) {
      return true
    }

    return false
  }
  
  func view() -> UIView {
    return _webView!
  }
}
