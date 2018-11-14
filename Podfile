# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'trnd' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for trnd

  pod 'Parse'
  pod 'FBSDKCoreKit'
  pod 'FBSDKLoginKit'
  pod 'FBSDKShareKit'

  pod 'KILabel', '1.0.0'
  pod 'FLAnimatedImage'
  pod 'VBFPopFlatButton'
  pod 'ALCameraViewController'
  pod 'TextFieldEffects'
  pod 'CRRefresh'

  pod 'ARVideoKit', :git => 'https://github.com/AFathi/ARVideoKit.git'

  target 'trndTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'trndUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings.delete('CODE_SIGNING_ALLOWED')
            config.build_settings.delete('CODE_SIGNING_REQUIRED')
        end
    end
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
end
