//
//  ZCCProductDetailCard.h
//  ZCCProductModule
//
//  商品详情参数卡片 — 展示林木参数键值对（品种、树龄、胸径等）
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCCProductDetailCard : UIView

/// 传入参数字典（key: 参数名, value: 参数值），自动渲染
@property (nonatomic, copy) NSDictionary<NSString *, NSString *> *params;

/// 当前高度（根据参数数量动态计算）
+ (CGFloat)heightForParams:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
