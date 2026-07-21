//
//  MainViewController.m
//  MainApp
//
//  主页面 — 展示三层组件化架构各模块入口
//  通过 Mediator 统一路由，不直接依赖业务模块的 ViewController
//

#import "MainViewController.h"
#import <ZCCMediator/ZCCMediator.h>

@interface MainViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSDictionary *> *menuItems;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"组件化架构示例";

    // ── 首页菜单：按三层架构组织 ──
    self.menuItems = @[
        // 业务层
        @{@"section": @"业务层 (Business)",
          @"items": @[
              @{@"title": @"🛍 商品模块",  @"route": @"zccapp://product/list"},
              @{@"title": @"🎁 权益模块",  @"route": @"zccapp://benefit/list"},
              @{@"title": @"💰 资产模块",  @"route": @"zccapp://asset/list"},
          ]},
        // Mediator 层说明
        @{@"section": @"Mediator 解耦层",
          @"items": @[
              @{@"title": @"跨模块调用说明", @"route": @""},
          ]},
        // 基础层
        @{@"section": @"基础层 (Foundation)",
          @"items": @[
              @{@"title": @"🌐 Web 容器演示", @"route": @""},
          ]},
    ];

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleInsetGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.menuItems.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.menuItems[section][@"items"] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.menuItems[section][@"section"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary *item = self.menuItems[indexPath.section][@"items"][indexPath.row];
    cell.textLabel.text = item[@"title"];
    cell.accessoryType = item[@"route"] ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSDictionary *item = self.menuItems[indexPath.section][@"items"][indexPath.row];
    NSString *route = item[@"route"];

    if (indexPath.section == 0) {
        // 业务层 — 通过 Mediator 路由跳转
        if (route.length > 0) {
            [[ZCCMediator sharedInstance] openURL:[NSURL URLWithString:route]];
        }
    } else if (indexPath.section == 1) {
        // Mediator 层 — 展示跨模块调用说明
        [self showMediatorExplanation];
    } else if (indexPath.section == 2) {
        // 基础层 — Web 容器演示
        [self showWebDemo];
    }
}

#pragma mark - Demo

- (void)showMediatorExplanation {
    UIAlertController *alert = [UIAlertController
        alertControllerWithTitle:@"Mediator 跨模块调用"
                         message:@"商品详情页可通过 Mediator 获取权益服务并跳转到权益列表 — "
                                 @"所有跨模块通信仅依赖协议，不依赖具体实现。\n\n"
                                 @"示例代码:\n"
                                 @"id<ZCCBenefitServiceProtocol> svc =\n"
                                 @"  [[ZCCMediator sharedInstance] benefitService];\n"
                                 @"[self.navigationController\n"
                                 @"  pushViewController:[svc benefitListVC]\n"
                                 @"  animated:YES];"
                  preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"了解" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showWebDemo {
    UIAlertController *alert = [UIAlertController
        alertControllerWithTitle:@"Web 容器组件"
                         message:@"基础层的 ZCCWebComponent 提供 WKWebView 容器 + JS Bridge。\n\n"
                                 @"业务模块可通过依赖此组件加载 H5 页面。"
                  preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"了解" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
