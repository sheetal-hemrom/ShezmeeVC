

Pod::Spec.new do |s|

  s.name         = "ShezmeeVC"
  s.version      = "0.0.1"
  s.summary      = "Base View Controller with CustomNavBar"
  s.description  = "Base View Controller with CustomNavBar"

  s.homepage     = "http://EXAMPLE/ShezmeeVC"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }


  s.author             = { "Hemrom, Sheetal Swati" => "sheetal.hemrom@gmail.com" }
  # Or just: s.author    = "Hemrom, Sheetal Swati"
  # s.authors            = { "Hemrom, Sheetal Swati" => "sheetal.hemrom@gmail.com" }
  # s.social_media_url   = "http://twitter.com/Hemrom, Sheetal Swati"


  # s.platform     = :ios
  s.platform     = :ios, "11.0"

  #  When using multiple platforms
  # s.ios.deployment_target = "5.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"

  s.source       = { :git => 'https://github.com/sheetal-hemrom/ShezmeeVC.git' , :tag => '1.0.0' }
  s.source_files  = "ShezmeeVC", "ShezmeeVC/**/*.{h,m,swift}"
  # s.exclude_files = "Classes/Exclude"

  # s.public_header_files = "Classes/**/*.h"
  # s.resource  = "icon.png"
  s.resources = "ShezmeeVC/*.png"
  
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4' }

end
