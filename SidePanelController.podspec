#
# Be sure to run `pod lib lint SidePanelController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SidePanelController'
  s.version          = '1.0.0'
  s.summary          = 'iOS UI component that aims to provide side panel functionality.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
This is UIViewController subsclass that you can use everywhere. It provides the ability
to inject inside up to three controllers. One of them is shown like central view and two of them
are dedicated to be side menu or something like that.
                       DESC

  s.homepage         = 'https://github.com/sivykh/SidePanel'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'sivykh' => 'sivykh@gmail.com' }
  s.source           = { :git => 'https://github.com/sivykh/SidePanel.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.swift_version = '5.0.1'

  s.source_files = 'SidePanelController/Classes/**/*'
  
end
