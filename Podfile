# Uncomment this line to define a global platform for your project
 source 'https://github.com/CocoaPods/Specs.git'
 platform :ios, '13.5'

use_frameworks!

workspace 'iSaveMoneyGo'



#application
def isavemoney_pods
  # Pods for iSaveMoney
  pod 'KAPinField'
  pod 'NVActivityIndicatorView'
  pod 'Charts'
  pod 'GoogleSignIn'
  pod 'SearchTextField'
  pod 'SwiftyStoreKit'
  pod 'MMDrawerController', '~> 0.5.7'
end

def firebase_pods
  pod 'Firebase'
  pod 'Firebase/Core'
  pod 'Firebase/Database'
  pod 'Firebase/Firestore'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/Analytics'
  pod 'Firebase/Auth'
  pod 'Firebase/DynamicLinks'
end

def accounts_frmk_pods
 pod 'SwiftValidator', :git => 'https://github.com/jpotts18/SwiftValidator.git', :tag => '4.2.0'
  pod 'DZNEmptyDataSet'
  pod 'TinyConstraints'
end

target 'ISMLBase' do
  project 'ISMLBase/ISMLBase.xcodeproj'
  pod 'TinyConstraints'
end

target 'ISMLDataService' do
  project 'ISMLDataService/ISMLDataService.xcodeproj'
  accounts_frmk_pods
  firebase_pods
end


target 'CheckoutModule' do
  project 'CheckoutModule/CheckoutModule.xcodeproj'
  pod 'TinyConstraints'

end

target 'iSaveMoney' do
  project 'iSaveMoney/iSaveMoney.xcodeproj'
#  pod 'Firebase'
#  pod 'Firebase/Core'
#  pod 'Firebase/Database'
#  pod 'Firebase/Firestore'
#  pod 'Firebase/Crashlytics'
#  pod 'Firebase/Analytics'
#  pod 'Firebase/Auth'
#  pod 'Firebase/DynamicLinks'
  firebase_pods
  accounts_frmk_pods
  isavemoney_pods
 
end



