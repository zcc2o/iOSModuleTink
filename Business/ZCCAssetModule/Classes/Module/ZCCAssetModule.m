//
//  ZCCAssetModule.m
//  ZCCAssetModule
//

#import "ZCCAssetModule.h"
#import "ZCCAssetDetailVC.h"
#import "ZCCAssetListVC.h"
#import <ZCCMediator/ZCCMediator+Business.h>
#import <ZCCBaseAssetModule/ZCCAssetService.h>

@implementation ZCCAssetModule

+ (NSString *)moduleName {
    return @"AssetModule";
}

- (void)moduleDidRegister {
    // 1. 注册服务到 Mediator
    [[ZCCMediator sharedInstance] registerService:@protocol(ZCCAssetServiceProtocol)
                                      implClass:[ZCCAssetService class]];

    // 2. 注入 VC 工厂到 Base 层 Service（解除 Base → Standard 依赖）
    ZCCAssetService *service = (ZCCAssetService *)[[ZCCMediator sharedInstance] assetService];
    __weak typeof(self) weakSelf = self;
    service.detailVCFactory = ^UIViewController *(NSString *assetId) {
        ZCCAssetDetailVC *vc = [[ZCCAssetDetailVC alloc] init];
        vc.assetId = assetId;
        vc.productId = assetId;
        return vc;
    };
    service.listVCFactory = ^UIViewController *(NSString *assetId) {
        return [[ZCCAssetListVC alloc] init];
    };

    // 3. 注册 URL 路由
    [[ZCCMediator sharedInstance] registerRoute:@"asset" handler:^UIViewController * _Nullable(NSURL *url, NSDictionary *params) {
        NSString *assetId = params[@"id"];
        NSString *productId = params[@"productId"];
        if (assetId) {
            ZCCAssetDetailVC *vc = [[ZCCAssetDetailVC alloc] init];
            vc.assetId = assetId;
            vc.productId = productId ?: assetId;
            return vc;
        }
        return [[ZCCAssetListVC alloc] init];
    }];

    NSLog(@"[ZCCAssetModule] 资产模块注册完成 (Standard 层 VC 工厂已注入 Base 层)");
}

@end
