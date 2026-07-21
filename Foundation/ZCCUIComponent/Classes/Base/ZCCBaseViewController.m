//
//  ZCCBaseViewController.m
//  ZCCUIComponent
//

#import "ZCCBaseViewController.h"
#import <ZCCLogComponent/ZCCLogger.h>

@implementation ZCCBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    ZCCLogDebug(@"[%@] viewDidLoad", NSStringFromClass([self class]));
}

- (void)fetchData {
    // 子类重写
}

- (void)zcc_backButtonTapped {
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
