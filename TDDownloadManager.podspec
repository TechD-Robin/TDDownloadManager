
Pod::Spec.new do |s|

  s.name         = "TDDownloadManager"
  s.version      = "0.0.3"
  s.summary      = "A Download Manager of Tech.D."

  s.homepage     = "https://git.techd.idv.tw:5001"
  s.source       = { :git => "git://git.techd.idv.tw/Libraries/TDDownloadManager.git", :tag => "#{s.version}" }

  s.license      = { :type=> "No License", :file => "LICENSE" }
  s.author       = { "Robin Hsu" => "robinhsu599+dev@gmail.com" }


  s.platform     = :ios, "8.0"
  s.requires_arc = true
  s.frameworks   = 'Foundation'

  s.source_files = 'ARCMacros.h', 'TDDownloadManager/*.{h,m,mm}'


  s.dependency    "AFNetworking",         "~> 2.5.2"
  s.dependency    "TDFoundation",         "~> 0.0.1"
  s.dependency    "Foundation+TechD",     "~> 0.0.1"


end
