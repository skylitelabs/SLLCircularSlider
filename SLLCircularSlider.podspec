Pod::Spec.new do |s|
  s.name         = 'SLLCircularSlider'
  s.version      = '1.0.0'
  s.license      =  { :type => 'MIT', :file => 'LICENSE' }
  s.authors      =  { 'Leejay Schmidt' => 'leejay.schmidt@skylite.io' }
  s.summary      = 'An extensible circular slider for iOS applications'
  s.homepage     = 'https://github.com/skylitelabs/SLLCircularSlider'

# Source Info
  s.platform     =  :ios, '8.0'
  s.source       =  { :git => 'https://github.com/skylitelabs/SLLCircularSlider.git', :tag => "1.0.0" }
  s.source_files = 'SLLCircularSlider/SLLCircularSlider.{h,m}'

  s.requires_arc = true
end
