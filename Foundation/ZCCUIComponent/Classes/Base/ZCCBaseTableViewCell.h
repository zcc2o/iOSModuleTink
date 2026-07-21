//
//  ZCCBaseTableViewCell.h
//  ZCCUIComponent
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCCBaseTableViewCell : UITableViewCell

/// 子类重写以配置子视图
- (void)zcc_setupSubviews;
/// 子类重写以绑定数据模型
- (void)zcc_bindModel:(id _Nullable)model;

@end

NS_ASSUME_NONNULL_END
