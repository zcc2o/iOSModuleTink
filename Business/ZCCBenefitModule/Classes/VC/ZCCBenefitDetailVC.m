//
//  ZCCBenefitDetailVC.m
//  ZCCBenefitModule
//

#import "ZCCBenefitDetailVC.h"
#import <ZCCMediator/ZCCMediator+Business.h>
#import <ZCCLogComponent/ZCCLogger.h>

@implementation ZCCBenefitDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"权益详情";

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 120, self.view.bounds.size.width - 40, 80)];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:16];
    label.text = [NSString stringWithFormat:@"权益ID: %@\n\n此权益可用于商品兑换，详情以活动规则为准。", self.benefitId];
    [self.view addSubview:label];

    // 跨模块调用：查看相关商品
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 240, self.view.bounds.size.width - 40, 44)];
    [btn setTitle:@"查看可用商品" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor systemBlueColor];
    [btn addTarget:self action:@selector(viewProducts) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

    ZCCLogInfo(@"权益详情加载: benefitId=%@", self.benefitId);
}

- (void)viewProducts {
    id<ZCCProductServiceProtocol> productService = [[ZCCMediator sharedInstance] productService];
    UIViewController *listVC = [productService productListViewController];
    [self.navigationController pushViewController:listVC animated:YES];
}

@end
