Pod::Spec.new do |s|

  s.name         = "BubbleShowCase"
  s.version      = "0.0.3"
  s.summary      = "A wonderful way to show case your users your App features"

  s.description  = <<-DESC
  This framework shows up a bubble-like view which targets some element in your scene whose feature you would like to explain to your users. 
  It is really simple to use, comes with animations and helps your users understand your App design.
                   DESC

  s.homepage     = "https://www.elconfidencial.com"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "ElConfidencial" => "apps@elconfidencial.com", "fermoya" => "fmdr.ct@gmail.com" }
  s.social_media_url   = "https://twitter.com/elconfidencial"

  s.platform     = :ios
  s.ios.deployment_target  = '9.0'
  s.swift_version = '4.0'

  s.source       = { :git => "https://github.com/ECLaboratorio/ShowCase-iOS.git", :tag => "#{s.version}" }
  s.source_files  = "ShowCase/ShowCase/*.swift"

  s.xcconfig = { "SWIFT_VERSION" => "4.0" }

end
