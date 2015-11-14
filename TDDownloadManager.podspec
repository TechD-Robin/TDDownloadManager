
Pod::Spec.new do |s|

  s.name         = "TDDownloadManager"
  s.version      = "0.0.6"
  s.summary      = "The `TDDownloadManager` is network library of Tech.D."

  s.description  = <<-DESC
                   The `TDDownloadManager` is network library of Tech.D.

                   * This library is package several network's working flow to simplify call,
                   * is import directly from `AFNetworking` library.
                   DESC

  s.homepage     = "https://github.com/TechD-Robin/TDDownloadManager/"
  s.source       = { :git => "https://github.com/TechD-Robin/TDDownloadManager.git", :tag => "#{s.version}" }

  s.license            = 'MIT'
  s.author             = { "Robin Hsu" => "robinhsu599+dev@gmail.com" }
  s.social_media_url   = "https://plus.google.com/+RobinHsu"


  s.platform     = :ios, "8.0"
  s.requires_arc = true
  s.frameworks   = 'Foundation', 'UIKit' 

  s.source_files = 'ARCMacros.h', 'TDDownloadManager/*.{h,m,mm}'

  s.dependency    "AFNetworking",         "~> 2.5.4"
  s.dependency    "TDFoundation",         "~> 0.0.4"
  #s.dependency    "Foundation+TechD",    "~> 0.0.3"


end
