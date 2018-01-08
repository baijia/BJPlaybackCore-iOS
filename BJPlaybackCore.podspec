Pod::Spec.new do |s|
  s.name         = "BJPlaybackCore"
  s.version      = "1.3.0-alpha04"
  s.summary      = "BJPlaybackCore SDK."
  s.license      = "MIT"
  s.author       = { "辛亚鹏" => "xinyapeng@baijiahulian.com" }
  s.homepage     = "http://www.baijiacloud.com/"
  s.description = 'BJPlaybackCore SDK for iOS.'
  s.requires_arc = true

  s.platform     = :ios, "8.0"
  s.frameworks = ['CoreGraphics', 'Foundation', 'UIKit']

  # s.ios.vendored_frameworks = 'BJPlaybackCore-#{s.version}/BJPlaybackCore.framework'    
  
  # http
  # s.source       = { :git => "http://git.baijia.com/iOS/BJPlaybackCore.git", :tag => "#{s.version}" }
  # s.source = { :http => 'http://file.gsxservice.com/0baijiatools/09b9807a96075f6247fd08ea48cab16b/BJPlaybackCore-0.0.1.zip' }
  # s.source_files = 'BJPlaybackCore-#{s.version}/**/*.h'
  # s.vendored_libraries = 'BJPlaybackCore-#{s.version}/**/*.a'
  # # s.resources = 'BJPlaybackCore-#{s.version}/**/*.bundle'
  
  # git
  s.source = { :git => 'https://github.com/baijia/BJPlaybackCore-iOS.git', :tag => s.version.to_s }
  
  # # library
#  s.public_header_files = 'BJPlaybackCore/**/*.h'
#  s.source_files = 'BJPlaybackCore/**/*.h'
#  s.vendored_libraries = 'BJPlaybackCore/**/*.a'
#  s.resources = 'BJPlaybackCore/**/*.bundle'

  # # framework
  s.ios.preserve_paths       = 'BJPlaybackCore/BJPlaybackCore.framework'
  s.ios.source_files         = 'BJPlaybackCore/BJPlaybackCore.framework/Versions/A/Headers/**/*.h'
  s.ios.public_header_files  = 'BJPlaybackCore/BJPlaybackCore.framework/Versions/A/Headers/**/*.h'
#  s.ios.resource             = 'BJPlaybackCore/BJPlaybackCore.framework/Versions/A/Resources/**/*'
  s.ios.vendored_frameworks  = 'BJPlaybackCore/BJPlaybackCore.framework'
  
  s.xcconfig = {
                 "ENABLE_BITCODE" => "NO", "CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES" => "YES",
                 "GCC_PREPROCESSOR_DEFINITIONS" => "$(inherited) PODSPEC_NAME=#{s.name} PODSPEC_VERSION=#{s.version}"
                }
  

  s.dependency 'BJLiveCore', '~> 1.3.0-alpha02'
  s.dependency 'BJPlayerManagerCore', '~>1.3.0-alpha'

  s.dependency 'BJLiveBase', '~> 1.3.0-alpha'
  s.dependency 'BJLiveBase/Ext'
  s.dependency 'BJLiveBase/Base'
  s.dependency 'BJLiveBase/YYModel'
  s.dependency 'BJLiveBase/Networking'
  
#--
  
  # s.dependency 'AFNetworking'
  # s.dependency 'BJLiveCore', '~>1.2.0'
  # s.dependency 'BJPlayerManagerCore', '~>1.2.0'
  # s.dependency 'YYModel'
  #
  # s.dependency 'BJLiveBase', '~> 1.2.0'
  # s.dependency 'BJLiveBase/Ext'
  # s.dependency 'BJLiveBase/Base'

  # DEPRECATED
#  s.dependency 'ReactiveObjC'
#  s.dependency 'NVHTarGzip'
 
end
