platform :ios, '15.0'
source 'https://cdn.cocoapods.org/'
project 'MainApp.xcodeproj'

USE_BINARY = ENV['USE_BINARY'] == '1'

def foundation_pod(name, path)
  src  = "./#{path}/#{name}_source.podspec"
  bin  = "./#{path}/#{name}_binary.podspec"
  dest = "./#{path}/#{name}.podspec"
  if USE_BINARY
    FileUtils.cp(bin, dest) if File.exist?(bin)
  else
    FileUtils.cp(src, dest) if File.exist?(src)
  end
  pod name, :path => "./#{path}"
end

target 'MainApp' do

  # ── Foundation 层（支持 source/framework 切换）──
  foundation_pod 'ZCCUIComponent',   'Foundation/ZCCUIComponent'
  foundation_pod 'ZCCWebComponent',  'Foundation/ZCCWebComponent'
  foundation_pod 'ZCCLogComponent',  'Foundation/ZCCLogComponent'

  # ── Mediator ──
  pod 'ZCCMediator', :path => './Mediator/ZCCMediator'

  # ── Base 层（支持 source/framework 切换）──
  foundation_pod 'ZCCBaseAssetModule', 'Business/ZCCBaseAssetModule'

  # ── Standard 层（始终源码，高频变更）──
  pod 'ZCCAssetModule',       :path => './Business/ZCCAssetModule'

  # ── 其他 Business ──
  pod 'ZCCProductModule',     :path => './Business/ZCCProductModule'
  pod 'ZCCBenefitModule',     :path => './Business/ZCCBenefitModule'
  pod 'ZCCOrderModule',       :path => './Business/ZCCOrderModule'
  pod 'ZCCContractModule',    :path => './Business/ZCCContractModule'
  pod 'ZCCCertificateModule', :path => './Business/ZCCCertificateModule'

end
