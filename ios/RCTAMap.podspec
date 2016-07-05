Pod::Spec.new do |s|

  s.name         = "RCTAMap"
  s.version      = "0.0.1"
  s.summary      = "React Native AMap."
  s.homepage     = "http://github.com/starlight36"
  s.license      = "MIT"
  s.author       = { "starlight36" => "starlight36@163.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/starlight36/react-native-amap.git" }
  s.source_files = 'RCTAMap', 'RCTAMap/*.{h,m}'
  s.dependency 'AMap3DMap'
  s.dependency 'AMapSearch'
  s.dependency 'AMapLocation'
end
