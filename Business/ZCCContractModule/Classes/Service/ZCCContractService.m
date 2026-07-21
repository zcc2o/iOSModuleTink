//
//  ZCCContractService.m
//  ZCCContractModule
//

#import "ZCCContractService.h"

@implementation ZCCContractService

- (ZCCContractState)getContractState:(NSString *)productId {
    // 模拟数据 — 实际从服务端获取
    return ZCCContractStateSigned;   // 已签订 → 可办证
    // return ZCCContractStateWaitSign; // 待签署
    // return ZCCContractStateWaitGen;  // 待生成
}

- (NSString *)contractStateName:(ZCCContractState)state {
    switch (state) {
        case ZCCContractStateBackup:              return @"备用";
        case ZCCContractStateWaitGen:             return @"待生成";
        case ZCCContractStateGenerated:           return @"已生成";
        case ZCCContractStateWaitSign:            return @"待签署";
        case ZCCContractStateSigning:             return @"签订中";
        case ZCCContractStateSigned:              return @"已签订";
        case ZCCContractStateEffective:           return @"生效中";
        case ZCCContractStateWaitGenInvalid:      return @"已失效";
        case ZCCContractStateGeneratedInvalid:    return @"已失效";
        case ZCCContractStateSigningInvalid:      return @"已失效";
        case ZCCContractStateSignedInvalid:       return @"已失效";
        case ZCCContractStateEffectiveInvalid:    return @"已失效";
        default: return @"未知";
    }
}

- (void)showContractForProduct:(NSString *)productId navigationController:(UINavigationController *)nav {
    UIViewController *vc = [[UIViewController alloc] init];
    vc.title = @"签署合同";
    vc.view.backgroundColor = [UIColor whiteColor];
    [nav pushViewController:vc animated:YES];
}

@end
