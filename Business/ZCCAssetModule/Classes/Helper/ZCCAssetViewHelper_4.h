//
//  ZCCAssetViewHelper_4.h
//  ZCCAssetModule
//

#import <UIKit/UIKit.h>

@interface ZCCAssetViewConfig_4 : NSObject
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

@interface ZCCAssetViewHelper_4 : NSObject
+ (UIView *)buildCardWithConfig:(ZCCAssetViewConfig_4 *)config;
+ (CGFloat)heightForConfig:(ZCCAssetViewConfig_4 *)config width:(CGFloat)width;
+ (void)applyStyle:(ZCCAssetViewConfig_4 *)config toView:(UIView *)view;
@end
