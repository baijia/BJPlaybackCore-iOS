Pod::Spec.new do |s|
  s.name = 'BJPlaybackCore'
  s.version = '0.0.5'
  s.summary = 'BJPlaybackCore SDK.'
  s.license = 'MIT'
  s.authors = {"辛亚鹏"=>"xinyapeng@baijiahulian.com"}
  s.homepage = 'http://www.baijiacloud.com/'
  s.description = 'BJPlaybackCore SDK for iOS.'
  s.requires_arc = true

  s.ios.deployment_target = '7.0'
  s.frameworks = ['CoreGraphics', 'Foundation', 'UIKit']

  # s.ios.vendored_frameworks = 'BJPlaybackCore-#{s.version}/BJPlaybackCore.framework'

  # http
  # s.source = { :http => 'http://file.gsxservice.com/0baijiatools/09b9807a96075f6247fd08ea48cab16b/BJPlaybackCore-0.0.1.zip' }
  # s.public_header_files = 'BJPlaybackCore-#{s.version}/**/*.h'
  # s.source_files = 'BJPlaybackCore-#{s.version}/**/*.h'
  # s.vendored_libraries = 'BJPlaybackCore-#{s.version}/**/*.a'
  # # s.resources = 'BJPlaybackCore-#{s.version}/**/*.bundle'

  # git
  s.source = { :git => 'https://github.com/baijia/BJPlaybackCore-iOS.git', :tag => s.version.to_s }
  s.public_header_files = 'BJPlaybackCore/**/*.h'
  s.source_files = 'BJPlaybackCore/**/*.h'
  s.vendored_libraries = 'BJPlaybackCore/**/*.a'
  # s.resources = 'BJPlaybackCore/**/*.bundle'

  s.dependency 'AFNetworking'
  s.dependency 'BJHL-Foundation-iOS'
  s.dependency 'BJLiveCore'
  s.dependency 'BJVideoPlayer'
  s.dependency 'LogStat'
  s.dependency 'YYModel'
  # DEPRECATED
  s.dependency 'ReactiveCocoa'

end
