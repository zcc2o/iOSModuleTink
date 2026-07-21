//
//  ZCCContractModule.m
//  ZCCContractModule
//

#import "ZCCContractModule.h"
#import "ZCCContractService.h"
#import <ZCCMediator/ZCCMediator.h>

@implementation ZCCContractModule

+ (NSString *)moduleName { return @"ContractModule"; }

- (void)moduleDidRegister {
    [[ZCCMediator sharedInstance] registerService:@protocol(ZCCContractServiceProtocol)
                                      implClass:[ZCCContractService class]];
    NSLog(@"[ZCCContractModule] 合同模块注册完成");
}

@end
