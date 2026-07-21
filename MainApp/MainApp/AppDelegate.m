//
//  AppDelegate.m
//  MainApp
//
//  主工程入口 — 在此处完成所有业务模块的注册与启动
//

#import "AppDelegate.h"
#import "MainViewController.h"

// Mediator
#import <ZCCMediator/ZCCMediator.h>

// 业务模块入口类
#import <ZCCProductModule/ZCCProductModule.h>
#import <ZCCBenefitModule/ZCCBenefitModule.h>
#import <ZCCAssetModule/ZCCAssetModule.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // ══════════════════════════════════════
    // 1. 注册所有业务模块到 Mediator
    // ══════════════════════════════════════
    [self registerModules];

    // ══════════════════════════════════════
    // 2. 初始化主窗口
    // ══════════════════════════════════════
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    MainViewController *rootVC = [[MainViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rootVC];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)registerModules {
    ZCCMediator *mediator = [ZCCMediator sharedInstance];

    // 商品模块
    ZCCProductModule *productModule = [[ZCCProductModule alloc] init];
    [mediator registerModule:productModule name:[ZCCProductModule moduleName]];

    // 权益模块
    ZCCBenefitModule *benefitModule = [[ZCCBenefitModule alloc] init];
    [mediator registerModule:benefitModule name:[ZCCBenefitModule moduleName]];

    // 资产模块
    ZCCAssetModule *assetModule = [[ZCCAssetModule alloc] init];
    [mediator registerModule:assetModule name:[ZCCAssetModule moduleName]];

    NSLog(@"========================================");
    NSLog(@"MainApp: 全部模块注册完毕");
    NSLog(@"  - ProductModule (商品)");
    NSLog(@"  - BenefitModule (权益)");
    NSLog(@"  - AssetModule   (资产)");
    NSLog(@"========================================");
}

@end
