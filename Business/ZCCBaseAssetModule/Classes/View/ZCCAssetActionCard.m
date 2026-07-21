//
//  ZCCAssetActionCard.m
//  ZCCAssetModule
//

#import "ZCCAssetActionCard.h"

static CGFloat const kPadding   = 16.0;
static CGFloat const kCornerR   = 12.0;
static CGFloat const kRow1Y     = 40.0;
static CGFloat const kBtnH      = 55.0;
static CGFloat const kRow2Gap   = 12.0;

@interface ZCCAssetActionCard ()

@property (nonatomic, strong) NSMutableArray<UIView *> *row1Buttons;
@property (nonatomic, strong) NSMutableArray<UIView *> *row2Buttons;
@property (nonatomic, strong) NSMutableDictionary<NSString *, ZCCButtonStateInfo *> *states;

// Row 1 按钮配置
@property (nonatomic, strong) NSArray<NSDictionary *> *row1Config;
// Row 2 按钮配置
@property (nonatomic, strong) NSArray<NSDictionary *> *row2Config;

@end

@implementation ZCCAssetActionCard

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = kCornerR;
        self.clipsToBounds = YES;

        _states = [NSMutableDictionary dictionary];
        _row1Buttons = [NSMutableArray array];
        _row2Buttons = [NSMutableArray array];

        _row1Config = @[
            @{@"title": @"订单",   @"key": @"order",       @"icon": @"📋"},
            @{@"title": @"合同",   @"key": @"contract",    @"icon": @"📝"},
            @{@"title": @"办证",   @"key": @"certificate", @"icon": @"📜"},
        ];
        _row2Config = @[
            @{@"title": @"转单赠送",   @"key": @"transfer",   @"icon": @"🔄"},
            @{@"title": @"保障服务",   @"key": @"insurance",  @"icon": @"🛡️"},
            @{@"title": @"采伐运输",   @"key": @"cutting",    @"icon": @"🚛"},
            @{@"title": @"成长印迹",   @"key": @"growth",     @"icon": @"🌱"},
            @{@"title": @"森林证书",   @"key": @"forestCert", @"icon": @"📄"},
        ];

        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    // Section 标题
    UILabel *secTitle = [[UILabel alloc] initWithFrame:CGRectMake(kPadding, 12, self.bounds.size.width - 2*kPadding, 22)];
    secTitle.text = @"良木服务";
    secTitle.font = [UIFont boldSystemFontOfSize:16];
    secTitle.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:secTitle];

    // ── Row 1: 三个大按钮 ──
    CGFloat btnW = (self.bounds.size.width - 2*kPadding - 20) / 3.0;
    for (NSInteger i = 0; i < self.row1Config.count; i++) {
        UIView *btn = [self buildLargeButton:self.row1Config[i]
                                      frame:CGRectMake(kPadding + i*(btnW+10), kRow1Y, btnW, kBtnH)
                                        tag:1000 + i];
        [self addSubview:btn];
        [self.row1Buttons addObject:btn];
    }

    // ── Row 2: 五个小按钮 ──
    CGFloat btnW2 = (self.bounds.size.width - 2*kPadding - 32) / 5.0;
    CGFloat row2Y = kRow1Y + kBtnH + kRow2Gap;
    for (NSInteger i = 0; i < self.row2Config.count; i++) {
        UIView *btn = [self buildSmallButton:self.row2Config[i]
                                      frame:CGRectMake(kPadding + i*(btnW2+8), row2Y, btnW2, kBtnH)
                                        tag:1010 + i];
        [self addSubview:btn];
        [self.row2Buttons addObject:btn];
    }
}

#pragma mark - Public

- (void)updateOrderState:(ZCCButtonStateInfo *)orderInfo
           contractState:(ZCCButtonStateInfo *)contractInfo
              certState:(ZCCButtonStateInfo *)certInfo {
    self.states[@"order"]      = orderInfo;
    self.states[@"contract"]   = contractInfo;
    self.states[@"certificate"] = certInfo;

    // 刷新 Row1 按钮的样式
    for (UIView *btn in self.row1Buttons) {
        NSDictionary *config = self.row1Config[[self.row1Buttons indexOfObject:btn]];
        [self refreshLargeButton:btn config:config state:self.states[config[@"key"]]];
    }
}

+ (CGFloat)recommendedHeight {
    return kRow1Y + kBtnH + kRow2Gap + kBtnH + 24;
}

#pragma mark - Button Builders

- (UIView *)buildLargeButton:(NSDictionary *)info frame:(CGRect)frame tag:(NSInteger)tag {
    UIView *btn = [[UIView alloc] initWithFrame:frame];
    btn.layer.cornerRadius = 8;
    btn.layer.borderWidth = 0.5;
    btn.layer.borderColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0].CGColor;
    btn.backgroundColor = [UIColor whiteColor];
    btn.tag = tag;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [btn addGestureRecognizer:tap];

    // 图标
    UILabel *icon = [[UILabel alloc] initWithFrame:CGRectMake(0, 4, frame.size.width, 22)];
    icon.text = info[@"icon"];
    icon.textAlignment = NSTextAlignmentCenter;
    icon.font = [UIFont systemFontOfSize:20];
    icon.tag = 1;
    [btn addSubview:icon];

    // 标题
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 28, frame.size.width, 16)];
    title.text = info[@"title"];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont systemFontOfSize:11];
    title.textColor = [UIColor darkGrayColor];
    title.tag = 2;
    [btn addSubview:title];

    // 状态文字
    UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 2, frame.size.width - 4, 12)];
    stateLabel.textAlignment = NSTextAlignmentRight;
    stateLabel.font = [UIFont systemFontOfSize:9];
    stateLabel.tag = 3;
    [btn addSubview:stateLabel];

    return btn;
}

- (UIView *)buildSmallButton:(NSDictionary *)info frame:(CGRect)frame tag:(NSInteger)tag {
    UIView *btn = [[UIView alloc] initWithFrame:frame];
    btn.backgroundColor = [UIColor colorWithRed:0.96 green:0.97 blue:0.96 alpha:1.0];
    btn.layer.cornerRadius = 8;
    btn.tag = tag;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [btn addGestureRecognizer:tap];

    UILabel *icon = [[UILabel alloc] initWithFrame:CGRectMake(0, 6, frame.size.width, 22)];
    icon.text = info[@"icon"];
    icon.textAlignment = NSTextAlignmentCenter;
    icon.font = [UIFont systemFontOfSize:18];
    [btn addSubview:icon];

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, frame.size.width, 18)];
    title.text = info[@"title"];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont systemFontOfSize:9];
    title.textColor = [UIColor darkGrayColor];
    [btn addSubview:title];

    return btn;
}

- (void)refreshLargeButton:(UIView *)btn config:(NSDictionary *)info state:(ZCCButtonStateInfo *)state {
    BOOL clickable = state ? state.clickable : YES;
    btn.alpha = clickable ? 1.0 : 0.5;
    btn.backgroundColor = clickable ? [UIColor whiteColor] : [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    btn.layer.borderColor = clickable ? [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0].CGColor
                                      : [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0].CGColor;
    // 移除旧手势，按需添加
    for (UIGestureRecognizer *g in btn.gestureRecognizers) {
        [btn removeGestureRecognizer:g];
    }
    if (clickable) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [btn addGestureRecognizer:tap];
    }

    UILabel *title = (UILabel *)[btn viewWithTag:2];
    title.textColor = clickable ? [UIColor darkGrayColor] : [UIColor lightGrayColor];

    UILabel *stateLabel = (UILabel *)[btn viewWithTag:3];
    if (state) {
        stateLabel.text = state.stateText;
        stateLabel.textColor = clickable ? [self colorWithHex:state.colorHex] : [UIColor lightGrayColor];
    }
}

#pragma mark - Tap Handling

- (void)handleTap:(UITapGestureRecognizer *)gesture {
    NSInteger tag = gesture.view.tag;

    // Row1: 1000=order, 1001=contract, 1002=certificate
    // Row2: 1010=transfer, 1011=insurance, 1012=cutting, 1013=growth, 1014=forestCert

    switch (tag) {
        case 1000:
            if ([self.delegate respondsToSelector:@selector(actionCardDidTapOrder:)])
                [self.delegate actionCardDidTapOrder:self];
            break;
        case 1001:
            if ([self.delegate respondsToSelector:@selector(actionCardDidTapContract:)])
                [self.delegate actionCardDidTapContract:self];
            break;
        case 1002:
            if ([self.delegate respondsToSelector:@selector(actionCardDidTapCertificate:)])
                [self.delegate actionCardDidTapCertificate:self];
            break;
        case 1010:
            if ([self.delegate respondsToSelector:@selector(actionCardDidTapTransfer:)])
                [self.delegate actionCardDidTapTransfer:self];
            break;
        case 1011:
            if ([self.delegate respondsToSelector:@selector(actionCardDidTapInsurance:)])
                [self.delegate actionCardDidTapInsurance:self];
            break;
        case 1012:
            if ([self.delegate respondsToSelector:@selector(actionCardDidTapCutting:)])
                [self.delegate actionCardDidTapCutting:self];
            break;
        case 1013:
            if ([self.delegate respondsToSelector:@selector(actionCardDidTapGrowth:)])
                [self.delegate actionCardDidTapGrowth:self];
            break;
        case 1014:
            if ([self.delegate respondsToSelector:@selector(actionCardDidTapForestCert:)])
                [self.delegate actionCardDidTapForestCert:self];
            break;
        default: break;
    }
}

- (UIColor *)colorWithHex:(NSString *)hex {
    if (!hex || hex.length == 0) return [UIColor grayColor];
    NSString *clean = [hex stringByReplacingOccurrencesOfString:@"#" withString:@""];
    unsigned int rgb = 0;
    [[NSScanner scannerWithString:clean] scanHexInt:&rgb];
    return [UIColor colorWithRed:((rgb >> 16) & 0xFF)/255.0
                           green:((rgb >> 8) & 0xFF)/255.0
                            blue:(rgb & 0xFF)/255.0 alpha:1.0];
}

@end
