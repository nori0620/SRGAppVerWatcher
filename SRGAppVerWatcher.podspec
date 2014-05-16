
Pod::Spec.new do |s|

  s.name         = "SRGAppVerWatcher"
  s.version      = "0.0.1"
  s.summary      = "SRGAppVerWatcher detect app-install or app-update, and hook your code."
  s.homepage     = "https://github.com/soragoto/SRGAppVerWatcher"
  s.license      = "MIT"
  s.author       = { "Norihiro Sakamoto" => "nori0620@gmail.com" }
  s.source       = { :git => "https://github.com/soragoto/SRGAppVerWatcher.git", :tag => "0.0.1" }
  s.platform     = :ios, '6.0'
  s.source_files = "Classes", "SRGAppVerWatcher/SRG*.{h,m}"
  s.requires_arc = true

end
