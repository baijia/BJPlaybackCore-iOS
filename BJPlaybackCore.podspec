#
#  Be sure to run `pod spec lint BJPlaybackCore.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

s.name         = "BJPlaybackCore"
s.version      = "0.0.6"
s.summary      = "BJPlaybackCore SDK."
s.description  = <<-DESC
BJPlaybackCore SDK for iOS.
DESC

s.homepage     = "http://www.baijiacloud.com/"
s.license      = "MIT"
s.author       = { "辛亚鹏" => "xinyapeng@baijiahulian.com" }

s.platform     = :ios, "7.0"
s.source       = { :git => "http://git.baijiahulian.com/iOS/BJPlaybackCore.git", :tag => "#{s.version}" }

s.source_files = "BJPlaybackCore", "BJPlaybackCore/**/*.{h,m}"
s.public_header_files = "BJPlaybackCore/**/BJP*.h", "BJPlaybackCore/**/NS*.h", "BJPlaybackCore/**/UI*.h"
s.private_header_files = "BJPlaybackCore/**/_*.h", "BJPlaybackCore/**/PB*.h", "BJPlaybackCore/**/*+private.h", "BJPlaybackCore/**/*+protected.h", "BJPlaybackCore/**/*+GSX.h"

s.frameworks   = ['CoreGraphics', 'Foundation', 'UIKit']
# s.libraries    = "iconv", "xml2"

s.requires_arc   = true
# s.xcconfig       = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }

s.dependency 'AFNetworking'
s.dependency 'BJHL-Foundation-iOS'
s.dependency 'BJLiveCore'
s.dependency 'BJHL-VideoPlayer-Manager'
s.dependency 'LogStat'
s.dependency 'YYModel'
# DEPRECATED
s.dependency 'ReactiveCocoa'

end
