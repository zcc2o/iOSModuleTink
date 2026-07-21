//
//  ZCCProductModule.m
//  ZCCProductModule
//

#import "ZCCProductModule.h"
#import "ZCCProductService.h"
#import <ZCCMediator/ZCCMediator.h>

@implementation ZCCProductModule

+ (NSString *)moduleName {
    return @"ProductModule";
}

- (void)moduleDidRegister {
    // 将此模块的服务实现注册到 Mediator
    [[ZCCMediator sharedInstance] registerService:@protocol(ZCCProductServiceProtocol)
                                      implClass:[ZCCProductService class]];

    // 注册 URL 路由
    [[ZCCMediator sharedInstance] registerRoute:@"product" handler:^UIViewController * _Nullable(NSURL *url, NSDictionary *params) {
        NSString *productId = params[@"id"];
        if (productId) {
            return [[ZCCProductService alloc] productDetailViewController:productId];
        }
        return [[ZCCProductService alloc] productListViewController];
    }];

    NSLog(@"[ZCCProductModule] 商品模块注册完成");
}

@end
