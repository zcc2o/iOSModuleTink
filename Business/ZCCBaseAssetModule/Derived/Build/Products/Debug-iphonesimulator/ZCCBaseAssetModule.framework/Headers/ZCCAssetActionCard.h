//
//  ZCCAssetActionCard.h
//  ZCCAssetModule
//
//  良木服务操作卡片 — 独立 UIView，8 个按钮 + 订单/合同/办证状态展示
//  点击通过 delegate 回调，不耦合任何 ViewController
//

#import <UIKit/UIKit.h>
#import <ZCCMediator/ZCCServiceProtocols.h>

NS_ASSUME_NONNULL_BEGIN

@class ZCCAssetActionCard;

/// 操作按钮点击回调协议
@protocol ZCCAssetActionCardDelegate <NSObject>

@optional
- (void)actionCardDidTapOrder:(ZCCAssetActionCard *)card;
- (void)actionCardDidTapContract:(ZCCAssetActionCard *)card;
- (void)actionCardDidTapCertificate:(ZCCAssetActionCard *)card;
- (void)actionCardDidTapTransfer:(ZCCAssetActionCard *)card;
- (void)actionCardDidTapInsurance:(ZCCAssetActionCard *)card;
- (void)actionCardDidTapCutting:(ZCCAssetActionCard *)card;
- (void)actionCardDidTapGrowth:(ZCCAssetActionCard *)card;
- (void)actionCardDidTapForestCert:(ZCCAssetActionCard *)card;

@end

/// 良木服务操作卡片
@interface ZCCAssetActionCard : UIView

@property (nonatomic, weak) id<ZCCAssetActionCardDelegate> delegate;

/// 更新订单/合同/办证三个按钮的状态
- (void)updateOrderState:(ZCCButtonStateInfo *)orderInfo
           contractState:(ZCCButtonStateInfo *)contractInfo
              certState:(ZCCButtonStateInfo *)certInfo;

/// 推荐高度
+ (CGFloat)recommendedHeight;

@end

NS_ASSUME_NONNULL_END
