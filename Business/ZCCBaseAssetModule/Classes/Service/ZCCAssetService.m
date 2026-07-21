//
//  ZCCAssetService.m
//  ZCCBaseAssetModule
//

#import "ZCCAssetService.h"

@implementation ZCCAssetService

- (double)getTotalAssets {
    return 128888.88;
}

- (UIViewController *)assetDetailViewController:(NSString *)assetId {
    if (self.detailVCFactory) {
        return self.detailVCFactory(assetId);
    }
    // fallback: 无 Standard 层时返回空页面
    UIViewController *vc = [[UIViewController alloc] init];
    vc.title = @"资产详情";
    return vc;
}

- (UIViewController *)assetListViewController {
    if (self.listVCFactory) {
        return self.listVCFactory(nil);
    }
    UIViewController *vc = [[UIViewController alloc] init];
    vc.title = @"资产列表";
    return vc;
}

@end
