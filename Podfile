# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'rxrendevu' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!


  # Pods for rxrendevu
  	pod 'CryptoSwift', :git => "https://github.com/krzyzanowskim/CryptoSwift"
    pod 'RxSwift'
    pod 'RxCocoa'
    pod 'Action'
    pod 'NSObject+Rx'
    pod 'RealmSwift'
    pod 'RxRealm'
    pod 'Unbox'
    pod 'Then'
    pod 'Reachability'
    pod 'Kingfisher'
    pod 'RxRealmDataSources'
  #  pod "SwiftDDP", '~> 0.4.1'
        pod "SwiftDDP"
    pod 'ViewDeck'
    pod 'TPKeyboardAvoiding'
    pod 'LoremIpsum'
    pod 'GoogleMaps'
    pod 'GooglePlaces'
    pod 'Toast-Swift', '~> 2.0.0'
    pod 'DropDown'
 # pod 'Google-Material-Design-Icons-Swift'
    pod 'Font-Awesome-Swift'
    pod 'SwiftSoup'
    pod 'SlackTextViewController'
    pod 'SeaseAssist'
    pod 'Cloudinary', '~> 2.0'
    pod 'IHKeyboardAvoiding'

  target 'rxrendevuTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'rxrendevuUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
post_install do |installer|
  installer.pods_project.targets.each do |target|
    if target.name == 'RxSwift'
      target.build_configurations.each do |config|
        if config.name == 'Debug'
          config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['-D', 'TRACE_RESOURCES']
        end
      end
    end
  end
end