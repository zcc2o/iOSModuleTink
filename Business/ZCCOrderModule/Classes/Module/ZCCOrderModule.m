//
//  ZCCOrderModule.m
//  ZCCOrderModule
//

#import "ZCCOrderModule.h"
#import "ZCCOrderService.h"
#import <ZCCMediator/ZCCMediator.h>

@implementation ZCCOrderModule

+ (NSString *)moduleName {
    return @"OrderModule";
}

- (void)moduleDidRegister {
    [[ZCCMediator sharedInstance] registerService:@protocol(ZCCOrderServiceProtocol)
                                      implClass:[ZCCOrderService class]];
    NSLog(@"[ZCCOrderModule] 订单模块注册完成");
}

@end
