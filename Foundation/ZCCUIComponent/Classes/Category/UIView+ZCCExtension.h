//
//  UIView+ZCCExtension.h
//  ZCCUIComponent
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ZCCExtension)

/// 当前视图所在的 ViewController（向上遍历响应链）
@property (nonatomic, readonly, nullable) UIViewController *zcc_viewController;

/// 快速设置 frame 的各分量
@property (nonatomic, assign) CGFloat zcc_x;
@property (nonatomic, assign) CGFloat zcc_y;
@property (nonatomic, assign) CGFloat zcc_width;
@property (nonatomic, assign) CGFloat zcc_height;
@property (nonatomic, assign) CGSize  zcc_size;
@property (nonatomic, assign) CGFloat zcc_centerX;
@property (nonatomic, assign) CGFloat zcc_centerY;

@end

NS_ASSUME_NONNULL_END
