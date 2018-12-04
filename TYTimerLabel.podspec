
Pod::Spec.new do |s|
  s.name             = 'TYTimerLabel'
  s.version          = '0.1.0'
  s.summary          = 'This is a handy timer.'
  s.homepage         = 'https://github.com/tianYaolove/TYTimerLabel'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Tianyao' => '963487409@qq.com' }
  s.source           = { :git => 'https://github.com/tianYaolove/TYTimerLabel.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = 'TYTimerLabel/Classes/**/*'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
