//
//  ZCCAssetViewHelper_5.m
//  ZCCAssetModule
//

#import "ZCCAssetViewHelper_5.h"

@implementation ZCCAssetViewConfig_5
- (instancetype)init {
    self = [super init];
    if (self) {
        _height = 44.0;
        _insets = UIEdgeInsetsMake(16, 16, 16, 16);
        _bgColor = [UIColor whiteColor];
        _titleFont = [UIFont boldSystemFontOfSize:16];
        _detailFont = [UIFont systemFontOfSize:13];
        _showSeparator = YES;
        _roundedCorners = YES;
        _cornerRadius = 12.0;
    }
    return self;
}
@end

@implementation ZCCAssetViewHelper_5

+ (UIView *)buildCardWithConfig:(ZCCAssetViewConfig_5 *)config {
    UIView *card = [[UIView alloc] init];
    card.backgroundColor = config.bgColor;
    if (config.roundedCorners) {
        card.layer.cornerRadius = config.cornerRadius;
        card.clipsToBounds = YES;
    }

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = config.title;
    titleLabel.font = config.titleFont;
    titleLabel.textColor = [UIColor darkGrayColor];
    [card addSubview:titleLabel];

    if (config.subtitle.length > 0) {
        UILabel *subLabel = [[UILabel alloc] init];
        subLabel.text = config.subtitle;
        subLabel.font = config.detailFont;
        subLabel.textColor = [UIColor grayColor];
        [card addSubview:subLabel];
    }

    if (config.showSeparator) {
        UIView *sep = [[UIView alloc] init];
        sep.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
        [card addSubview:sep];
    }

    return card;
}

+ (CGFloat)heightForConfig:(ZCCAssetViewConfig_5 *)config width:(CGFloat)width {
    CGFloat h = config.insets.top + config.insets.bottom;
    CGSize titleSize = [config.title boundingRectWithSize:CGSizeMake(width - config.insets.left - config.insets.right, CGFLOAT_MAX)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName: config.titleFont}
                                                  context:nil].size;
    h += ceil(titleSize.height) + 4;
    if (config.subtitle.length > 0) {
        CGSize subSize = [config.subtitle boundingRectWithSize:CGSizeMake(width - config.insets.left - config.insets.right, CGFLOAT_MAX)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName: config.detailFont}
                                                       context:nil].size;
        h += ceil(subSize.height) + 4;
    }
    if (config.showSeparator) h += 1;
    return ceil(h);
}

+ (void)applyStyle:(ZCCAssetViewConfig_5 *)config toView:(UIView *)view {
    view.backgroundColor = config.bgColor;
    if (config.roundedCorners) {
        view.layer.cornerRadius = config.cornerRadius;
        view.clipsToBounds = YES;
    }
}

@end
