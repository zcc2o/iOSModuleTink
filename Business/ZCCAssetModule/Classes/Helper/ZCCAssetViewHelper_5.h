//
//  ZCCAssetViewHelper_5.h
//  ZCCAssetModule
//

#import <UIKit/UIKit.h>

@interface ZCCAssetViewConfig_5 : NSObject
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

@interface ZCCAssetViewHelper_5 : NSObject
+ (UIView *)buildCardWithConfig:(ZCCAssetViewConfig_5 *)config;
+ (CGFloat)heightForConfig:(ZCCAssetViewConfig_5 *)config width:(CGFloat)width;
+ (void)applyStyle:(ZCCAssetViewConfig_5 *)config toView:(UIView *)view;
@end
