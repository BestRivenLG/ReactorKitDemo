# Uncomment the next line to define a global platform for your project
 platform :ios, '12.0'

target 'ReactorKitDemo' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'ReactorKit'
  pod 'RxSwift', '~> 6.0'
  pod 'RxCocoa', '~> 6.0'
  pod 'SnapKit'
  pod 'NSObject+Rx', '~> 5.2.2'
  pod 'Moya/RxSwift'
  pod 'SwiftyJSON'
  pod 'HandyJSON', :git => 'https://github.com/Miles-Matheson/HandyJSON.git'
  pod 'SVProgressHUD', '~> 2.3.1'
  pod 'LookinServer', '~> 1.2.8', :configurations => ['Debug']
  pod 'Then'
  pod 'SwifterSwift', '~> 6.2.0', :subspecs => ['UIKit', 'Foundation', 'CoreAnimation', 'SwiftStdlib', 'CoreGraphics']
  pod 'MJRefresh'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
#              config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
              config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
#              config.build_settings['ENABLE_BITCODE'] = 'NO'
#
#              config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ""
#
#              config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
#
#              config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
#
#              config.build_settings['CODE_SIGN_IDENTITY'] = 'NO'
#              if config.base_configuration_reference.is_a? Xcodeproj::Project::Object::PBXFileReference
#                xcconfig_path = config.base_configuration_reference.real_path
#                IO.write(xcconfig_path, IO.read(xcconfig_path).gsub("DT_TOOLCHAIN_DIR", "TOOLCHAIN_DIR"))
#              end
        end
    end
end
