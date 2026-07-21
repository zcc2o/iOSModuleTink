//
//  ZCCAssetStateModel.h
//  ZCCAssetModule
//
//  资产状态模型 — 将订单/合同/办证三个模块的原始状态码
//  按级联依赖规则转换为按钮展示信息（文字、颜色、可点击性）
//

#import <Foundation/Foundation.h>
#import <ZCCMediator/ZCCServiceProtocols.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCCAssetStateModel : NSObject

/// 订单按钮状态
@property (nonatomic, strong, readonly) ZCCButtonStateInfo *orderButtonInfo;
/// 合同按钮状态
@property (nonatomic, strong, readonly) ZCCButtonStateInfo *contractButtonInfo;
/// 办证按钮状态
@property (nonatomic, strong, readonly) ZCCButtonStateInfo *certButtonInfo;

/// 传入三个模块的原始状态码，自动计算所有按钮展示信息
- (void)updateWithOrderState:(ZCCOrderState)order
              contractState:(ZCCContractState)contract
                  certState:(ZCCCertState)cert
        orderStateNameBlock:(NSString *(^)(ZCCOrderState))orderNameBlock
    contractStateNameBlock:(NSString *(^)(ZCCContractState))contractNameBlock
        certStateNameBlock:(NSString *(^)(ZCCCertState))certNameBlock;

@end

NS_ASSUME_NONNULL_END
