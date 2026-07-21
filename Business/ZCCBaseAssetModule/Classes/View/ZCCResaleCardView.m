//
//  ZCCResaleCardView.m
//  ZCCAssetModule
//

#import "ZCCResaleCardView.h"

static CGFloat const kPadding = 16.0;

@interface ZCCResaleCardView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *payMethodLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *startDateLabel;
@property (nonatomic, strong) UILabel *endDateLabel;
@property (nonatomic, strong) UIButton *confirmButton;

@end

@implementation ZCCResaleCardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    CGFloat w = self.bounds.size.width;

    // 标题
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadding, 12, w - 2*kPadding, 22)];
    _titleLabel.text = @"我的转卖";
    _titleLabel.font = [UIFont boldSystemFontOfSize:16];
    _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:_titleLabel];

    // 信息行
    CGFloat y = 46;
    _payMethodLabel = [self infoLabelAtY:y];
    [self addSubview:_payMethodLabel];
    y += 26;

    _priceLabel = [self infoLabelAtY:y];
    [self addSubview:_priceLabel];
    y += 26;

    _startDateLabel = [self infoLabelAtY:y];
    [self addSubview:_startDateLabel];
    y += 26;

    _endDateLabel = [self infoLabelAtY:y];
    [self addSubview:_endDateLabel];
    y += 30;

    // 确认按钮
    _confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(kPadding, y, w - 2*kPadding, 40)];
    [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _confirmButton.backgroundColor = [UIColor colorWithRed:0.2 green:0.6 blue:0.4 alpha:1.0];
    _confirmButton.layer.cornerRadius = 8;
    _confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    _confirmButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [_confirmButton addTarget:self action:@selector(confirmTapped) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_confirmButton];
}

- (UILabel *)infoLabelAtY:(CGFloat)y {
    return [[UILabel alloc] initWithFrame:CGRectMake(kPadding, y, self.bounds.size.width - 2*kPadding, 24)];
}

- (void)updateWithPrice:(double)price
         paymentMethod:(NSString *)paymentMethod
            startDate:(NSString *)startDate
              endDate:(NSString *)endDate
          buttonTitle:(NSString *)buttonTitle {
    _payMethodLabel.text = [NSString stringWithFormat:@"付款方式:  %@", paymentMethod ?: @"线上全款"];
    _priceLabel.text = [NSString stringWithFormat:@"转卖价格:  ¥%.2f", price];
    _startDateLabel.text = [NSString stringWithFormat:@"转卖开始:  %@", startDate ?: @"无"];
    _endDateLabel.text = [NSString stringWithFormat:@"转卖截止:  %@", endDate ?: @"无"];
    [_confirmButton setTitle:buttonTitle ?: @"创建转卖" forState:UIControlStateNormal];
}

+ (CGFloat)recommendedHeight {
    // title(12+22) + 4rows(26*4) + gap(8) + btn(40) + bottom(16)
    return 46 + 26*4 + 8 + 40 + 16;
}

- (void)confirmTapped {
    if ([self.delegate respondsToSelector:@selector(resaleCardDidTapConfirm:)]) {
        [self.delegate resaleCardDidTapConfirm:self];
    }
}

@end
