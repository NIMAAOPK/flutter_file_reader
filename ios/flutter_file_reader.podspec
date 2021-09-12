#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_file_reader.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_file_reader'
  s.version          = '0.0.2'
  s.summary          = '本地文件视图，支持多种文件类型，Android由Tencent X5实现，iOS由WKWebView实现'
  s.description      = <<-DESC
本地文件视图，支持多种文件类型，Android由Tencent X5实现，iOS由WKWebView实现
                       DESC
  s.homepage         = 'https://github.com/LiWenHui96/flutter_file_reader'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'LiWeNHuI' => 'sdgrlwh@163.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'
  s.ios.deployment_target = '10.0'

  s.swift_version = '5.0'
end
