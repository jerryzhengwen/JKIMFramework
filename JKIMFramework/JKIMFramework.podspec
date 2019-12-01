#
# Be sure to run `pod lib lint JKIMFramework.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JKIMFramework'
  s.version          = '1.4.0'
  s.summary          = '这是一个关于久科IMSDK的初级版'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = "当前版本支持真机和模拟器运行，是关于访客端的SDK，具体使用请联系久科客服进行相关注册等"

  s.homepage         = 'https://github.com/jerryzhengwen/JKIMFramework'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ilucklyzhengwen@163.com' => 'jerry.gu@9client.com' }
  s.source           = { :git => 'https://github.com/jerryzhengwen/JKIMFramework.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'
  s.platform     = :ios, "8.0"

s.source_files = 'JKIMFramework/**/Classes/**/*.{h,m}','JKIMFramework/**/UI/**/*.{h,m}',
  
# s.resource_bundles = {
#     'JKIMFramework' => ['JKIMFramework/**/Assets/*.png']
#  }
s.public_header_files = 'JKIMFramework/**/Classes/**/*.h'
s.ios.vendored_libraries = 'JKIMFramework/**/Frameworks/**/*.a'
s.resources = 'JKIMFramework/**/UIKit/**/{JKDialogeModel.xcdatamodeld,JKFace.plist,JKIMImage.bundle,style.css}'
s.libraries = "resolv", "xml2","icucore"
s.xcconfig = { 'VALID_ARCHS' => 'arm64 x86_64 armv7 i386', }
s.frameworks = 'UIKit', 'MapKit'
s.requires_arc = false

s.requires_arc = ['JKIMFramework/**/Classes/*.{h,m}']
s.dependency 'YYWebImage'
s.dependency 'MJRefresh'
s.dependency 'MBProgressHUD', '~> 1.1.0'
end
