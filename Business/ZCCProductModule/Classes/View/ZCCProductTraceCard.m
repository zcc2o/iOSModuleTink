//
//  ZCCProductTraceCard.m
//  ZCCProductModule
//

#import "ZCCProductTraceCard.h"

static CGFloat const kPadding = 16.0;

@implementation ZCCProductTraceCard

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setTraceNodes:(NSArray<ZCCTreeTraceNode *> *)traceNodes {
    _traceNodes = [traceNodes copy];
    [self rebuildUI];
}

- (void)rebuildUI {
    for (UIView *v in self.subviews) { [v removeFromSuperview]; }

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(kPadding, 12, self.bounds.size.width - 2*kPadding, 22)];
    title.text = @"🌳 林木溯源";
    title.font = [UIFont boldSystemFontOfSize:16];
    [self addSubview:title];

    CGFloat y = 44;
    for (NSInteger i = 0; i < self.traceNodes.count; i++) {
        ZCCTreeTraceNode *node = self.traceNodes[i];
        BOOL isLast = (i == self.traceNodes.count - 1);
        CGFloat w = self.bounds.size.width;

        UIView *dot = [[UIView alloc] initWithFrame:CGRectMake(25, y + 4, 10, 10)];
        dot.backgroundColor = [UIColor colorWithRed:0.2 green:0.6 blue:0.4 alpha:1.0];
        dot.layer.cornerRadius = 5;
        [self addSubview:dot];

        if (!isLast) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(29, y + 14, 2, 56)];
            line.backgroundColor = [UIColor colorWithRed:0.8 green:0.9 blue:0.85 alpha:1.0];
            [self addSubview:line];
        }

        [self addLabel:CGRectMake(45, y, 80, 16) text:node.dateString font:[UIFont systemFontOfSize:11] color:[UIColor grayColor]];
        [self addLabel:CGRectMake(45, y + 16, w - 70, 18) text:node.title font:[UIFont boldSystemFontOfSize:14] color:[UIColor blackColor]];
        [self addLabel:CGRectMake(45, y + 36, w - 70, 16) text:node.nodeDescription font:[UIFont systemFontOfSize:12] color:[UIColor grayColor]];

        y += 70;
    }
}

- (UILabel *)addLabel:(CGRect)frame text:(NSString *)text font:(UIFont *)font color:(UIColor *)color {
    UILabel *l = [[UILabel alloc] initWithFrame:frame];
    l.text = text; l.font = font; l.textColor = color;
    [self addSubview:l];
    return l;
}

+ (CGFloat)heightForNodes:(NSArray<ZCCTreeTraceNode *> *)nodes {
    return 44 + nodes.count * 70 + 16;
}

@end
