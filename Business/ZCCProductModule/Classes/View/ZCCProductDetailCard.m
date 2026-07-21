//
//  ZCCProductDetailCard.m
//  ZCCProductModule
//

#import "ZCCProductDetailCard.h"

static CGFloat const kPadding = 16.0;

@implementation ZCCProductDetailCard

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setParams:(NSDictionary<NSString *, NSString *> *)params {
    _params = [params copy];
    [self rebuildUI];
}

- (void)rebuildUI {
    for (UIView *v in self.subviews) { [v removeFromSuperview]; }

    // 标题
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(kPadding, 12, self.bounds.size.width - 2*kPadding, 22)];
    title.text = @"林木参数";
    title.font = [UIFont boldSystemFontOfSize:16];
    [self addSubview:title];

    CGFloat y = 42;
    for (NSString *key in self.params) {
        UILabel *row = [[UILabel alloc] initWithFrame:CGRectMake(kPadding, y, self.bounds.size.width - 2*kPadding, 22)];
        row.text = [NSString stringWithFormat:@"%@: %@", key, self.params[key]];
        row.font = [UIFont systemFontOfSize:13];
        row.textColor = [UIColor darkGrayColor];
        [self addSubview:row];
        y += 26;
    }
}

+ (CGFloat)heightForParams:(NSDictionary *)params {
    return 42 + params.count * 26 + 12;
}

@end
