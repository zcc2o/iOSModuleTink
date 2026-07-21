//
//  ZCCOrderService.m
//  ZCCOrderModule
//

#import "ZCCOrderService.h"

@implementation ZCCOrderService

- (ZCCOrderState)getOrderState:(NSString *)productId {
    // 模拟数据 — 实际从服务端获取
    return ZCCOrderStateCompleted; // 已完成，可签合同
    // return ZCCOrderStatePaid;    // 已付款但未完成
    // return ZCCOrderStateWaitPay;  // 待付款
}

- (NSString *)orderStateName:(ZCCOrderState)state {
    switch (state) {
        case ZCCOrderStateCreating:        return @"创建中";
        case ZCCOrderStateWaitPay:         return @"待付款";
        case ZCCOrderStateWaitFinalPay:    return @"待付尾款";
        case ZCCOrderStateFinalPaid:       return @"已付尾款";
        case ZCCOrderStatePaid:            return @"已付款";
        case ZCCOrderStateCompleted:       return @"已完成";
        case ZCCOrderStateCanceled:        return @"已取消";
        case ZCCOrderStateRefunding:       return @"退款中";
        case ZCCOrderStateRefundingFirst:  return @"退款中(首款)";
        case ZCCOrderStateRefunded:        return @"已退款";
        case ZCCOrderStateRefundedFirst:   return @"已退首款";
        default: return @"未知";
    }
}

- (void)showOrderDetailForProduct:(NSString *)productId navigationController:(UINavigationController *)nav {
    UIViewController *vc = [[UIViewController alloc] init];
    vc.title = @"认购订单";
    vc.view.backgroundColor = [UIColor whiteColor];
    [nav pushViewController:vc animated:YES];
}

@end
