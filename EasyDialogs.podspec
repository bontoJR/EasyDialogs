Pod::Spec.new do |s|
  s.name         = "EasyDialogs"
  s.version      = "1.1"
  s.summary      = "A simple, customizable dialog library for iOS written in Swift inspired by MaterialDialogs for Android."
  s.description  = <<-DESC
    TODO
                   DESC
  s.homepage     = "https://github.com/bontoJR/EasyDialogs"
  s.license      = { :type => "MIT", :file => "License.md" }
  s.author             = { "Junior B." => "@bontoJR" }
  s.social_media_url   = "http://twitter.com/bontoJR"

  s.ios.deployment_target = '9.0'

  s.source       = { :git => "https://github.com/bontoJR/EasyDialogs.git", :tag => s.version }
  s.source_files  = "EasyDialogs/Classes/*.{swift}"

  s.frameworks  = "Foundation", "UIKit"

end
