#
#  Be sure to run `pod spec lint ShowCase.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "  ShowCase"
  s.version      = "0.0.1"
  s.summary      = "A wonderful way to show case your users your App features"

  s.description  = <<-DESC
  This framework shows up a bubble-like view which targets some element in your scene whose feature you would like to explain to your users. 
  It is really simple to use, comes with animations and helps your users understand your App design.
                   DESC

  s.homepage     = "https://wwww.elconfidencial.com"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "ElConfidencial" => "apps@elconfidencial.com", "fermoya" => "fmdr.ct@gmail.com" }
  s.social_media_url   = "https://twitter.com/elconfidencial"

  s.platform     = :ios
  s.ios.deployment_target  = '9.0'

  s.source       = { :git => "https://github.com/ECLaboratorio/ShowCase-iOS.git", :tag => "#{s.version}" }
  s.source_files  = "ShowCase/ShowCase/*.swift"
  # s.public_header_files = "Classes/**/*.h"

  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"

end
