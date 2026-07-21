//
//  ZCCBannerView.h
//  ZCCUIComponent
//
//  通用 Banner 轮播组件 — 传入图片URL数组，自动轮播+PageControl
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZCCBannerView;

@protocol ZCCBannerViewDelegate <NSObject>
@optional
- (void)bannerView:(ZCCBannerView *)banner didTapImageAtIndex:(NSInteger)index;
@end

@interface ZCCBannerView : UIView

@property (nonatomic, weak) id<ZCCBannerViewDelegate> delegate;

/// 图片URL数组
@property (nonatomic, copy) NSArray<NSString *> *imageUrls;
/// 占位图背景色（默认深绿色）
@property (nonatomic, strong) UIColor *placeholderColor;
/// 是否自动轮播（默认YES）
@property (nonatomic, assign) BOOL autoScroll;
/// 轮播间隔（默认4秒）
@property (nonatomic, assign) NSTimeInterval scrollInterval;
/// 当前页
@property (nonatomic, assign, readonly) NSInteger currentPage;
/// PageControl 颜色
@property (nonatomic, strong) UIColor *pageIndicatorColor;
@property (nonatomic, strong) UIColor *currentPageIndicatorColor;

@end

NS_ASSUME_NONNULL_END
