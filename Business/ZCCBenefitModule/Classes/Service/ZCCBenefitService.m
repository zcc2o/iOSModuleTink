//
//  ZCCBenefitService.m
//  ZCCBenefitModule
//

#import "ZCCBenefitService.h"
#import "ZCCBenefitListVC.h"
#import "ZCCBenefitDetailVC.h"

@implementation ZCCBenefitService

- (NSArray<NSDictionary *> *)getCurrentBenefits {
    return @[
        @{@"id": @"B001", @"name": @"满减券",       @"desc": @"满200减30"},
        @{@"id": @"B002", @"name": @"免邮券",       @"desc": @"全场包邮"},
        @{@"id": @"B003", @"name": @"VIP折扣",      @"desc": @"9折优惠"},
    ];
}

- (NSArray<NSDictionary *> *)getBenefitsForProduct:(NSString *)productId {
    // 实际项目中根据商品ID请求服务端，这里返回模拟数据
    return @[
        @{@"id": @"B_P001", @"name": @"林木保险",   @"desc": @"免费赠送1年基础林木保险"},
        @{@"id": @"B_P002", @"name": @"管护服务",   @"desc": @"专业团队管护至2028年"},
        @{@"id": @"B_P003", @"name": @"优先认购权", @"desc": @"享有同庄园新品优先认购权"},
        @{@"id": @"B_P004", @"name": @"采摘权益",   @"desc": @"果实成熟期享有优先采摘权"},
    ];
}

- (UIViewController *)benefitDetailViewController:(NSString *)benefitId {
    ZCCBenefitDetailVC *vc = [[ZCCBenefitDetailVC alloc] init];
    vc.benefitId = benefitId;
    return vc;
}

- (UIViewController *)benefitListViewController {
    return [[ZCCBenefitListVC alloc] init];
}

- (UIView *)benefitViewForProduct:(NSString *)productId frame:(CGRect)frame {
    NSArray *benefits = [self getBenefitsForProduct:productId];

    UIView *container = [[UIView alloc] initWithFrame:frame];
    container.backgroundColor = [UIColor whiteColor];

    // 标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 16, frame.size.width - 32, 22)];
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.text = @"认购权益";
    titleLabel.textColor = [UIColor darkGrayColor];
    [container addSubview:titleLabel];

    // 权益列表
    CGFloat y = 46;
    for (NSDictionary *benefit in benefits) {
        UIView *row = [[UIView alloc] initWithFrame:CGRectMake(16, y, frame.size.width - 32, 60)];
        row.backgroundColor = [UIColor colorWithRed:0.95 green:0.97 blue:0.95 alpha:1.0];
        row.layer.cornerRadius = 8;

        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 10, row.bounds.size.width - 24, 20)];
        nameLabel.font = [UIFont boldSystemFontOfSize:14];
        nameLabel.text = benefit[@"name"];
        [row addSubview:nameLabel];

        UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 32, row.bounds.size.width - 24, 18)];
        descLabel.font = [UIFont systemFontOfSize:12];
        descLabel.textColor = [UIColor grayColor];
        descLabel.text = benefit[@"desc"];
        [row addSubview:descLabel];

        [container addSubview:row];
        y += 68;
    }

    CGRect finalFrame = container.frame;
    finalFrame.size.height = y + 16;
    container.frame = finalFrame;

    return container;
}

@end
