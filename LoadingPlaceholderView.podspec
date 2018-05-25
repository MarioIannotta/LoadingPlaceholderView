Pod::Spec.new do |s|
  s.name             = 'LoadingPlaceholderView'
  s.version          = '0.0.1'
  s.summary          = 'Animated gradient placeholder with zero effort.'
  s.description      = <<-DESC
LoadingPlaceholderView allows you to display an animated gradient placeholder for all of your view' subviews with just a couple of line of codes.
                       DESC
  s.swift_version = '4.0'
  s.homepage         = 'https://github.com/MarioIannotta/LoadingPlaceholderView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'MarioIannotta' => 'info@marioiannotta.com' }
  s.source           = { :git => 'https://github.com/MarioIannotta/LoadingPlaceholderView.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/MarioIannotta'
  s.ios.deployment_target = '9.0'
  s.source_files = 'LoadingPlaceholderView/**/*.swift'
  
end
