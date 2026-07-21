//
//  ZCCCertificateService.m
//  ZCCCertificateModule
//

#import "ZCCCertificateService.h"

@implementation ZCCCertificateService

- (ZCCCertState)getCertificateState:(NSString *)productId {
    // 模拟数据 — 实际从服务端获取
    return ZCCCertStateAuthing;    // 认证中
    // return ZCCCertStateDraft;    // 草稿
    // return ZCCCertStateAuthDone; // 认证完成
}

- (NSString *)certificateStateName:(ZCCCertState)state {
    switch (state) {
        case ZCCCertStateDraft:        return @"草稿";
        case ZCCCertStateResubmit:     return @"待重复提交";
        case ZCCCertStateWaitPay:      return @"待支付";
        case ZCCCertStateWaitAudit:    return @"待审核";
        case ZCCCertStateAuthing:      return @"认证中";
        case ZCCCertStateAuthDone:     return @"认证完成";
        case ZCCCertStateAuthFailed:   return @"认证失败";
        case ZCCCertStateAuthExpired:  return @"认证过期";
        default: return @"未知";
    }
}

- (void)showCertificateForProduct:(NSString *)productId navigationController:(UINavigationController *)nav {
    UIViewController *vc = [[UIViewController alloc] init];
    vc.title = @"办理产证";
    vc.view.backgroundColor = [UIColor whiteColor];
    [nav pushViewController:vc animated:YES];
}

@end
