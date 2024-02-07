# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'CollectionViewAds' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for SwitchProject
  pod 'RxSwift', '~> 5.1'
  pod 'RxCocoa', '~> 5.1'
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings["IPHONEOS_DEPLOYMENT_TARGET"] = "11.0"
      end
    end
  end

end
