//
//  ZCCResaleCardView.h
//  ZCCAssetModule
//
//  转卖卡片 — 独立 UIView，展示转卖信息+创建转卖按钮，点击通过 delegate 回调
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZCCResaleCardView;

@protocol ZCCResaleCardViewDelegate <NSObject>
@optional
- (void)resaleCardDidTapConfirm:(ZCCResaleCardView *)card;
@end

@interface ZCCResaleCardView : UIView

@property (nonatomic, weak) id<ZCCResaleCardViewDelegate> delegate;

/// 更新转卖信息
- (void)updateWithPrice:(double)price
           paymentMethod:(NSString *)paymentMethod
              startDate:(NSString *)startDate
                endDate:(NSString *)endDate
              buttonTitle:(NSString *)buttonTitle;

/// 推荐高度
+ (CGFloat)recommendedHeight;

@end

NS_ASSUME_NONNULL_END
