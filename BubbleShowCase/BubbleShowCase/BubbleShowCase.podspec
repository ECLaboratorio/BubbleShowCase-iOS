Pod::Spec.new do |s|

  s.name         = "BubbleShowCase"
  s.version      = "1.1.0"
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
  s.swift_version = '4.2'

  s.source       = { :git => "https://github.com/ECLaboratorio/BubbleShowCase-iOS.git", :tag => "#{s.version}" }
  s.source_files  = "BubbleShowCase/BubbleShowCase/*.swift"

  s.xcconfig = { "SWIFT_VERSION" => "4.0" }
  s.documentation_url = "https://github.com/ECLaboratorio/BubbleShowCase-iOS/blob/master/README.md"

end
