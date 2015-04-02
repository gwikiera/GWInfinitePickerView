Pod::Spec.new do |s|
  s.name             = "GWInfinitePickerView"
  s.version          = "0.1.0"
  s.summary          = "The GWInfinitePickerView is an extension of the UIPickerView which makes it endless (like UIDatePicker)."
  s.description      = "The GWInfinitePickerView by adding additional rows makes UIPickerView endless. All the magic is under the hood, outside it seems to be normal UIPickerView. The GWInfinitePickerView inherited from UIPickerView, so all you have to do is just change the class of your picker view to the GWInfinitePickerView."
  s.homepage         = "https://github.com/gwikiera/GWInfinitePickerView"
  s.license          = 'MIT'
  s.author           = { "Grzegorz Wikiera" => "gwikiera@gmail.com" }
  s.source           = { :git => "https://github.com/gwikiera/GWInfinitePickerView.git", :tag => s.version.to_s }
  
  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'

  s.public_header_files = 'Pod/Classes/**/*.h'
end
