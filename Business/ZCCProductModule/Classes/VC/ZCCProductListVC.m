//
//  ZCCProductListVC.m
//  ZCCProductModule
//

#import "ZCCProductListVC.h"
#import <ZCCMediator/ZCCMediator.h>
#import <ZCCLogComponent/ZCCLogger.h>

@interface ZCCProductListVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSDictionary *> *dataSource;
@end

@implementation ZCCProductListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品列表";

    self.dataSource = @[
        @{@"id": @"1001", @"name": @"iPhone 16 Pro",   @"price": @"¥8999"},
        @{@"id": @"1002", @"name": @"MacBook Pro M4",  @"price": @"¥14999"},
        @{@"id": @"1003", @"name": @"AirPods Pro 3",    @"price": @"¥1999"},
    ];

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];

    ZCCLogInfo(@"商品列表页加载完成，共 %lu 件商品", (unsigned long)self.dataSource.count);
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary *item = self.dataSource[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@  %@", item[@"name"], item[@"price"]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSDictionary *item = self.dataSource[indexPath.row];
    // 通过 Mediator 路由跳转到商品详情（跨模块解耦）
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"zccapp://product/detail?id=%@", item[@"id"]]];
    [[ZCCMediator sharedInstance] openURL:url];
}

@end
