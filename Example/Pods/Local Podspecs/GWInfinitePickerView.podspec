#
# Be sure to run `pod lib lint GWInfinitePickerView.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "GWInfinitePickerView"
  s.version          = "0.1.0"
  s.summary          = "A short description of GWInfinitePickerView."
  s.description      = <<-DESC
                       An optional longer description of GWInfinitePickerView

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "https://github.com/gwikiera/GWInfinitePickerView"
  s.license          = 'MIT'
  s.author           = { "Grzegorz Wikiera" => "gwikiera@gmail.com" }
  s.source           = { :git => "https://github.com/gwikiera/GWInfinitePickerView.git", :tag => s.version.to_s }
  
  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'

  s.public_header_files = 'Pod/Classes/**/*.h'
end
