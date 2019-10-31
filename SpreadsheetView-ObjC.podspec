Pod::Spec.new do |s|
  s.name             = 'SpreadsheetView-ObjC'
  s.version          = '0.1.0'
  s.summary          = 'Full configurable spreadsheet view user interfaces for iOS applications'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'Full configurable spreadsheet view user interfaces for iOS applications. With this framework, you can easily create complex layouts like schedule, gantt chart or timetable as if you are using Excel. Highly motivated & influenced by https://github.com/kishikawakatsumi/SpreadsheetView'

  s.homepage         = 'https://github.com/walidhossain/SpreadsheetView-ObjC.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Walid Hossain' => 'waliduet@gmail.com' }
  s.source           = { :git => 'https://github.com/walidhossain/SpreadsheetView-ObjC.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/walidhossain'

  s.ios.deployment_target = '8.0'
  
  s.framework = "UIKit"
  s.source_files = 'Classes/*','Resources/*'
end
