//
//  ZCCProductDetailVC.m
//  ZCCProductModule
//

#import "ZCCProductDetailVC.h"
#import <ZCCMediator/ZCCMediator+Business.h>
#import <ZCCLogComponent/ZCCLogger.h>

@interface ZCCProductDetailVC ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIButton *actionButton;
@end

@implementation ZCCProductDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品详情";

    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 120, self.view.bounds.size.width - 40, 30)];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:22];
    self.titleLabel.text = [NSString stringWithFormat:@"商品 %@", self.productId];
    [self.view addSubview:self.titleLabel];

    self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 160, self.view.bounds.size.width - 40, 30)];
    self.priceLabel.font = [UIFont systemFontOfSize:18];
    self.priceLabel.textColor = [UIColor redColor];
    self.priceLabel.text = @"¥9,999.00";
    [self.view addSubview:self.priceLabel];

    self.actionButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 220, self.view.bounds.size.width - 40, 44)];
    [self.actionButton setTitle:@"使用权益兑换" forState:UIControlStateNormal];
    self.actionButton.backgroundColor = [UIColor systemBlueColor];
    [self.actionButton addTarget:self action:@selector(useBenefit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.actionButton];

    ZCCLogInfo(@"商品详情页加载: productId=%@", self.productId);
}

- (void)useBenefit {
    // 跨模块调用：通过 Mediator 获取权益服务
    id<ZCCBenefitServiceProtocol> benefitService = [[ZCCMediator sharedInstance] benefitService];
    NSArray *benefits = [benefitService getCurrentBenefits];
    if (benefits.count > 0) {
        ZCCLogInfo(@"用户拥有 %lu 项权益可兑换", (unsigned long)benefits.count);
    }
    // 跳转到权益列表
    UIViewController *benefitVC = [benefitService benefitListViewController];
    [self.navigationController pushViewController:benefitVC animated:YES];
}

@end
