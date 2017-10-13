# Uncomment this line to define a global platform for your project
platform :ios, '9.0'
#set ENABLE_BITCODE = NO
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
      #config.build_settings['OTHER_LDFLAGS'] = '-lstdc++'
      config.build_settings['GENERATE_MASTER_OBJECT_FILE'] = 'YES'
    end
  end
end
target 'ReceiptMe' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ReceiptMe
  pod 'TesseractOCRiOS', '4.0.0'
  pod "IPDFCameraViewController"
  pod 'StringScore_Swift'
 pod 'PIRipple', '1.1.0' 

end
