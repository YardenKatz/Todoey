# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'Todoey' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Todoey
pod 'RealmSwift'
pod 'SwipeCellKit'
pod 'ChameleonFramework/Swift', :git => 'https://github.com/wowansm/Chameleon.git', :branch => 'swift5'


end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end
