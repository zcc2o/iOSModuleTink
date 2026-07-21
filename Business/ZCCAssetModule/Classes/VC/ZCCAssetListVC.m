//
//  ZCCAssetListVC.m
//  ZCCAssetModule
//

#import "ZCCAssetListVC.h"
#import <ZCCMediator/ZCCMediator.h>
#import <ZCCLogComponent/ZCCLogger.h>

@interface ZCCAssetListVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSDictionary *> *dataSource;
@end

@implementation ZCCAssetListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的资产";

    self.dataSource = @[
        @{@"id": @"A001", @"name": @"保证金",     @"value": @"¥60,000.00"},
        @{@"id": @"A002", @"name": @"预付款",     @"value": @"¥30,000.00"},
        @{@"id": @"A003", @"name": @"返利余额",   @"value": @"¥38,888.88"},
    ];

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];

    ZCCLogInfo(@"资产列表页加载完成");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary *item = self.dataSource[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ — %@", item[@"name"], item[@"value"]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *item = self.dataSource[indexPath.row];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"zccapp://asset/detail?id=%@", item[@"id"]]];
    [[ZCCMediator sharedInstance] openURL:url];
}

@end
