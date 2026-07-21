//
//  ZCCBaseViewController.h
//  ZCCUIComponent
//
//  所有业务 ViewController 的基类，提供统一的导航栏样式、空态处理等
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCCBaseViewController : UIViewController

/// 子类重写该方法以在页面首次显示时请求数据
- (void)fetchData NS_REQUIRES_SUPER;

/// 统一返回按钮点击回调（子类可重写）
- (void)zcc_backButtonTapped;

@end

NS_ASSUME_NONNULL_END
