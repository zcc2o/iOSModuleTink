//
//  ZCCBenefitModule.m
//  ZCCBenefitModule
//

#import "ZCCBenefitModule.h"
#import "ZCCBenefitService.h"
#import <ZCCMediator/ZCCMediator.h>

@implementation ZCCBenefitModule

+ (NSString *)moduleName {
    return @"BenefitModule";
}

- (void)moduleDidRegister {
    [[ZCCMediator sharedInstance] registerService:@protocol(ZCCBenefitServiceProtocol)
                                      implClass:[ZCCBenefitService class]];

    [[ZCCMediator sharedInstance] registerRoute:@"benefit" handler:^UIViewController * _Nullable(NSURL *url, NSDictionary *params) {
        NSString *benefitId = params[@"id"];
        if (benefitId) {
            return [[ZCCBenefitService alloc] benefitDetailViewController:benefitId];
        }
        return [[ZCCBenefitService alloc] benefitListViewController];
    }];

    NSLog(@"[ZCCBenefitModule] 权益模块注册完成");
}

@end
