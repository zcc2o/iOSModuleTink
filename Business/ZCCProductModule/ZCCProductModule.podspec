Pod::Spec.new do |s|
  s.name         = 'ZCCProductModule'
  s.version      = '1.0.0'
  s.summary      = '商品业务模块 — 商品列表、详情展示'
  s.homepage     = 'https://github.com/example/ZCCProductModule'
  s.license      = { :type => 'MIT' }
  s.author       = 'ComponentizedApp'
  s.source       = { :git => 'https://github.com/example/ZCCProductModule.git', :tag => s.version.to_s }
  s.platform     = :ios, '15.0'
  s.source_files = 'Classes/**/*.{h,m}'
  s.public_header_files = 'Classes/**/*.h'
  s.frameworks   = 'UIKit', 'Foundation'
  s.requires_arc = true

  # 依赖 Mediator（获取其他模块服务）+ 基础 UI 组件
  s.dependency 'ZCCMediator'
  s.dependency 'ZCCUIComponent'
  s.dependency 'ZCCLogComponent'
end
