//
//  ZCCAssetDetailVC.m
//  ZCCAssetModule
//
//  资产详情页 — 海南黄花梨林木详情
//

#import "ZCCAssetDetailVC.h"
#import <ZCCBaseAssetModule/ZCCAssetActionCard.h>
#import <ZCCBaseAssetModule/ZCCResaleCardView.h>
#import <ZCCBaseAssetModule/ZCCAssetStateModel.h>
#import <ZCCMediator/ZCCMediator+Business.h>
#import <ZCCMediator/ZCCModuleDefines.h>
#import <ZCCUIComponent/ZCCBannerView.h>
#import <ZCCUIComponent/UIView+ZCCExtension.h>
#import <ZCCWebComponent/ZCCWebViewController.h>
#import <ZCCLogComponent/ZCCLogger.h>

static CGFloat const kCardMargin   = 10.0;
static CGFloat const kCardPadding  = 16.0;
static CGFloat const kCornerRadius = 12.0;

@interface ZCCAssetDetailVC () <UITableViewDelegate, UITableViewDataSource,
                                  ZCCAssetActionCardDelegate, ZCCResaleCardViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZCCProductDetailData *productData;
@property (nonatomic, strong) NSArray<NSDictionary *> *benefitList;
@property (nonatomic, strong) ZCCAssetStateModel *stateModel;

@end

@implementation ZCCAssetDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"资产详情";
    [self loadData];
    [self setupTableView];
    [self setupBannerHeader];
}

#pragma mark - Data Loading

- (void)loadData {
    ZCCMediator *mediator = [ZCCMediator sharedInstance];

    // 商品模块 → 详情数据
    id<ZCCProductServiceProtocol> productSvc = [mediator productService];
    self.productData = [productSvc getProductDetail:self.productId];

    // 权益模块 → 商品权益
    id<ZCCBenefitServiceProtocol> benefitSvc = [mediator benefitService];
    self.benefitList = [benefitSvc getBenefitsForProduct:self.productId];

    // 订单/合同/办证 模块 → 原始状态码 → Model 做状态转换
    self.stateModel = [[ZCCAssetStateModel alloc] init];
    [self.stateModel updateWithOrderState:[[mediator orderService] getOrderState:self.productId]
                           contractState:[[mediator contractService] getContractState:self.productId]
                               certState:[[mediator certificateService] getCertificateState:self.productId]
                     orderStateNameBlock:^NSString *(ZCCOrderState s) {
                         return [[ZCCMediator sharedInstance].orderService orderStateName:s];
                     }
                 contractStateNameBlock:^NSString *(ZCCContractState s) {
                     return [[ZCCMediator sharedInstance].contractService contractStateName:s];
                     }
                     certStateNameBlock:^NSString *(ZCCCertState s) {
                         return [[ZCCMediator sharedInstance].certificateService certificateStateName:s];
                     }];
}

#pragma mark - TableView

- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    self.tableView.showsVerticalScrollIndicator = NO;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.view addSubview:self.tableView];
}

#pragma mark - Card1: Banner ← ZCCUIComponent

- (void)setupBannerHeader {
    if (!self.productData || self.productData.bannerImages.count == 0) return;

    CGFloat bannerH = self.view.zcc_width * 0.75;
    ZCCBannerView *banner = [[ZCCBannerView alloc] initWithFrame:CGRectMake(0, 0, self.view.zcc_width, bannerH)];
    banner.imageUrls = self.productData.bannerImages;
    self.tableView.tableHeaderView = banner;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return 8; }
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 2) ? 1 : 1; // Card4 now single row
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section { return kCardMargin; }
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *v = [[UIView alloc] init]; v.backgroundColor = [UIColor clearColor]; return v;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    UIView *card = [self createCardForSection:indexPath.section];
    card.frame = CGRectMake(kCardMargin, 0, self.view.zcc_width - 2*kCardMargin, card.zcc_height);
    [cell.contentView addSubview:card];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self heightForSection:indexPath.section] + kCardMargin;
}

#pragma mark - Card Factory

- (UIView *)createCardForSection:(NSInteger)section {
    switch (section) {
        case 0: return [self createCard2_MarketPrice];
        case 1: return [self createCard3_ActionButtons];
        case 2: return [self createCard4_Resell];
        case 3: return [self createCard5_DetailInfo];
        case 4: return [self createCard6_MapPlaceholder];
        case 5: return [self createCard7_WebDetail];
        case 6: return [self createCard8_Benefits];
        case 7: return [self createCard9_Traceability];
        default: return [[UIView alloc] init];
    }
}

- (CGFloat)heightForSection:(NSInteger)section {
    switch (section) {
        case 0: return 160;
        case 1: return [ZCCAssetActionCard recommendedHeight];
        case 2: return [ZCCResaleCardView recommendedHeight];
        case 3: return [[[ZCCMediator sharedInstance] productService] productDetailCardHeight:self.productId];
        case 4: return 120;
        case 5: return 300;
        case 6: return 60 + self.benefitList.count * 68;
        case 7: return [[[ZCCMediator sharedInstance] productService] productTraceCardHeight:self.productId];
        default: return 0;
    }
}

#pragma mark - Card2: 市场指导价（VC 内联 UI，数据来自 ZCCProductModule）

- (UIView *)createCard2_MarketPrice {
    CGFloat w = self.view.zcc_width - 2*kCardMargin;
    UIView *card = [self cardContainerWithHeight:160];
    ZCCProductDetailData *d = self.productData;

    UILabel *title = [self label:CGRectMake(kCardPadding, kCardPadding, w-2*kCardPadding, 24)
                            text:d.title font:[UIFont boldSystemFontOfSize:20]];
    [card addSubview:title];

    UILabel *sub = [self label:CGRectMake(kCardPadding, 44, w-2*kCardPadding, 18)
                          text:d.subtitle font:[UIFont systemFontOfSize:13] color:[UIColor grayColor]];
    [card addSubview:sub];

    UILabel *price = [self label:CGRectMake(kCardPadding, 72, w-2*kCardPadding, 30)
                            text:[NSString stringWithFormat:@"市场指导价: ¥%.2f %@", d.marketPrice, d.priceUnit ?: @"元"]
                            font:[UIFont boldSystemFontOfSize:18]
                           color:[UIColor colorWithRed:0.9 green:0.3 blue:0.1 alpha:1.0]];
    [card addSubview:price];

    UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(kCardPadding, 110, w-2*kCardPadding, 0.5)];
    sep.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    [card addSubview:sep];

    UIView *avatar = [[UIView alloc] initWithFrame:CGRectMake(kCardPadding, 118, 32, 32)];
    avatar.backgroundColor = [UIColor colorWithRed:0.3 green:0.5 blue:0.8 alpha:1.0];
    avatar.layer.cornerRadius = 16; avatar.clipsToBounds = YES;
    [card addSubview:avatar];

    [card addSubview:[self label:CGRectMake(kCardPadding+42, 118, 100, 16)
                             text:d.sellerInfo.name font:[UIFont boldSystemFontOfSize:14]]];
    [card addSubview:[self label:CGRectMake(kCardPadding+42, 135, w-kCardPadding-42, 14)
                             text:d.sellerInfo.company font:[UIFont systemFontOfSize:12] color:[UIColor grayColor]]];
    return card;
}

#pragma mark - Card3: 操作按钮 ← ZCCAssetActionCard

- (UIView *)createCard3_ActionButtons {
    CGFloat w = self.view.zcc_width - 2*kCardMargin;
    CGFloat h = [ZCCAssetActionCard recommendedHeight];
    UIView *wrapper = [self cardContainerWithHeight:h];
    ZCCAssetActionCard *card = [[ZCCAssetActionCard alloc] initWithFrame:CGRectMake(0, 0, w, h)];
    card.delegate = self;
    [card updateOrderState:self.stateModel.orderButtonInfo
            contractState:self.stateModel.contractButtonInfo
                certState:self.stateModel.certButtonInfo];
    [wrapper addSubview:card];
    return wrapper;
}

#pragma mark - Card4: 转卖 ← ZCCResaleCardView

- (UIView *)createCard4_Resell {
    CGFloat w = self.view.zcc_width - 2*kCardMargin;
    CGFloat h = [ZCCResaleCardView recommendedHeight];
    UIView *wrapper = [self cardContainerWithHeight:h];
    ZCCResaleCardView *card = [[ZCCResaleCardView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
    card.delegate = self;
    [card updateWithPrice:self.productData.marketPrice * 0.9
           paymentMethod:@"线上全款"
              startDate:@"2025-07-21"
                endDate:@"2026-07-21"
            buttonTitle:@"创建转卖"];
    [wrapper addSubview:card];
    return wrapper;
}

#pragma mark - Card5: 详情参数 ← ZCCProductModule

- (UIView *)createCard5_DetailInfo {
    CGFloat w = self.view.zcc_width - 2*kCardMargin;
    CGFloat h = [[[ZCCMediator sharedInstance] productService] productDetailCardHeight:self.productId];
    UIView *wrapper = [self cardContainerWithHeight:h];
    id<ZCCProductServiceProtocol> svc = [[ZCCMediator sharedInstance] productService];
    UIView *card = [svc productDetailCardForProduct:self.productId frame:CGRectMake(0, 0, w, h)];
    [wrapper addSubview:card];
    return wrapper;
}

#pragma mark - Card6: 地图占位

- (UIView *)createCard6_MapPlaceholder {
    CGFloat w = self.view.zcc_width - 2*kCardMargin;
    UIView *card = [self cardContainerWithHeight:120];
    [card addSubview:[self label:CGRectMake(kCardPadding, 12, w-2*kCardPadding, 22)
                             text:@"📍 林木位置" font:[UIFont boldSystemFontOfSize:16]]];

    UILabel *pl = [self label:CGRectMake(kCardPadding, 40, w-2*kCardPadding, 60)
                          text:[NSString stringWithFormat:@"地图功能开发中\n(%.6f, %.6f)\n%@",
                                self.productData.latitude, self.productData.longitude,
                                self.productData.location ?: @""]
                          font:[UIFont systemFontOfSize:13] color:[UIColor grayColor]];
    pl.numberOfLines = 0; pl.textAlignment = NSTextAlignmentCenter;
    pl.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    pl.layer.cornerRadius = 8; pl.clipsToBounds = YES;
    [card addSubview:pl];
    return card;
}

#pragma mark - Card7: Web ← ZCCWebComponent

- (UIView *)createCard7_WebDetail {
    CGFloat w = self.view.zcc_width - 2*kCardMargin;
    UIView *card = [self cardContainerWithHeight:300];
    [card addSubview:[self label:CGRectMake(kCardPadding, 12, w-2*kCardPadding, 22)
                             text:@"商品详情" font:[UIFont boldSystemFontOfSize:16]]];

    // 使用 ZCCWebComponent 的 WebViewController 作为子 VC
    ZCCWebViewController *webVC = [[ZCCWebViewController alloc] init];
    [self addChildViewController:webVC];
    webVC.view.frame = CGRectMake(kCardPadding, 40, w-2*kCardPadding, 250);
    webVC.view.layer.cornerRadius = 8;
    webVC.view.clipsToBounds = YES;
    [card addSubview:webVC.view];
    [webVC didMoveToParentViewController:self];

    NSString *html = [NSString stringWithFormat:
        @"<html><head><meta name='viewport' content='width=device-width,initial-scale=1.0'>"
        @"<style>body{font-family:-apple-system;padding:12px;color:#333;}h3{color:#1a5c2a;}"
        @"p{line-height:1.6;font-size:14px;}</style></head><body>%@</body></html>",
        self.productData.detailHTML ?: @"<p>暂无详情</p>"];
    [webVC.webView loadHTMLString:html baseURL:nil];

    return card;
}

#pragma mark - Card8: 权益 ← ZCCBenefitModule

- (UIView *)createCard8_Benefits {
    CGFloat w = self.view.zcc_width - 2*kCardMargin;
    CGFloat h = 60 + self.benefitList.count * 68;
    UIView *card = [self cardContainerWithHeight:h];

    id<ZCCBenefitServiceProtocol> svc = [[ZCCMediator sharedInstance] benefitService];
    UIView *benefitView = [svc benefitViewForProduct:self.productId frame:CGRectMake(0, 0, w, h)];
    [card addSubview:benefitView];
    return card;
}

#pragma mark - Card9: 林木溯源 ← ZCCProductModule

- (UIView *)createCard9_Traceability {
    CGFloat w = self.view.zcc_width - 2*kCardMargin;
    CGFloat h = [[[ZCCMediator sharedInstance] productService] productTraceCardHeight:self.productId];
    UIView *wrapper = [self cardContainerWithHeight:h];
    id<ZCCProductServiceProtocol> svc = [[ZCCMediator sharedInstance] productService];
    UIView *card = [svc productTraceCardForProduct:self.productId frame:CGRectMake(0, 0, w, h)];
    [wrapper addSubview:card];
    return wrapper;
}

#pragma mark - ZCCAssetActionCardDelegate

- (void)actionCardDidTapOrder:(ZCCAssetActionCard *)card {
    [[[ZCCMediator sharedInstance] orderService] showOrderDetailForProduct:self.productId
                                                     navigationController:self.navigationController];
}
- (void)actionCardDidTapContract:(ZCCAssetActionCard *)card {
    [[[ZCCMediator sharedInstance] contractService] showContractForProduct:self.productId
                                                     navigationController:self.navigationController];
}
- (void)actionCardDidTapCertificate:(ZCCAssetActionCard *)card {
    [[[ZCCMediator sharedInstance] certificateService] showCertificateForProduct:self.productId
                                                           navigationController:self.navigationController];
}
// Row2 按钮暂通过 URL 路由
- (void)actionCardDidTapTransfer:(ZCCAssetActionCard *)card   { [self openRoute:kZCCRouteTransferPage]; }
- (void)actionCardDidTapInsurance:(ZCCAssetActionCard *)card  { [self openRoute:kZCCRouteInsurancePage]; }
- (void)actionCardDidTapCutting:(ZCCAssetActionCard *)card    { [self openRoute:kZCCRouteCuttingPage]; }
- (void)actionCardDidTapGrowth:(ZCCAssetActionCard *)card     { [self openRoute:kZCCRouteGrowthPage]; }
- (void)actionCardDidTapForestCert:(ZCCAssetActionCard *)card { [self openRoute:kZCCRouteForestCertPage]; }

- (void)openRoute:(NSString *)route {
    if (route.length > 0) {
        [[ZCCMediator sharedInstance] openURL:[NSURL URLWithString:route]];
    }
}

#pragma mark - ZCCResaleCardViewDelegate

- (void)resaleCardDidTapConfirm:(ZCCResaleCardView *)card {
    // 转卖确认 — 通过 URL 路由跳转
    [self openRoute:kZCCRouteTransferPage];
}

#pragma mark - Helpers

- (UIView *)cardContainerWithHeight:(CGFloat)height {
    CGFloat w = self.view.zcc_width - 2*kCardMargin;
    UIView *card = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, height)];
    card.backgroundColor = [UIColor whiteColor];
    card.layer.cornerRadius = kCornerRadius;
    card.clipsToBounds = YES;
    return card;
}

- (UILabel *)label:(CGRect)frame text:(NSString *)text font:(UIFont *)font {
    return [self label:frame text:text font:font color:[UIColor blackColor]];
}

- (UILabel *)label:(CGRect)frame text:(NSString *)text font:(UIFont *)font color:(UIColor *)color {
    UILabel *l = [[UILabel alloc] initWithFrame:frame];
    l.text = text; l.font = font; l.textColor = color;
    return l;
}

@end
