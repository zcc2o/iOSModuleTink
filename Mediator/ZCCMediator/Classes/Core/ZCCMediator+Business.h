//
//  ZCCMediator+Business.h
//  ZCCMediator
//
//  业务分类 — 为各业务模块提供类型安全的便捷调用接口
//

#import "ZCCMediator.h"
#import "ZCCServiceProtocols.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZCCMediator (Business)

/// 商品服务
- (id<ZCCProductServiceProtocol> _Nullable)productService;
/// 权益服务
- (id<ZCCBenefitServiceProtocol> _Nullable)benefitService;
/// 资产服务
- (id<ZCCAssetServiceProtocol> _Nullable)assetService;
/// 订单服务
- (id<ZCCOrderServiceProtocol> _Nullable)orderService;
/// 合同服务
- (id<ZCCContractServiceProtocol> _Nullable)contractService;
/// 办证服务
- (id<ZCCCertificateServiceProtocol> _Nullable)certificateService;

@end

NS_ASSUME_NONNULL_END
