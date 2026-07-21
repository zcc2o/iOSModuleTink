//
//  ZCCAssetViewHelper_3.h
//  ZCCAssetModule
//

#import <UIKit/UIKit.h>

@interface ZCCAssetViewConfig_3 : NSObject
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) UIEdgeInsets insets;
@property (nonatomic, strong) UIColor *bgColor;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIFont *detailFont;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, assign) BOOL showSeparator;
@property (nonatomic, assign) BOOL roundedCorners;
@property (nonatomic, assign) CGFloat cornerRadius;
@end

@interface ZCCAssetViewHelper_3 : NSObject
+ (UIView *)buildCardWithConfig:(ZCCAssetViewConfig_3 *)config;
+ (CGFloat)heightForConfig:(ZCCAssetViewConfig_3 *)config width:(CGFloat)width;
+ (void)applyStyle:(ZCCAssetViewConfig_3 *)config toView:(UIView *)view;
@end
