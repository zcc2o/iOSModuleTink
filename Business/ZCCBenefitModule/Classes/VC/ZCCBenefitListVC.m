//
//  ZCCBenefitListVC.m
//  ZCCBenefitModule
//

#import "ZCCBenefitListVC.h"
#import <ZCCMediator/ZCCMediator.h>
#import <ZCCLogComponent/ZCCLogger.h>

@interface ZCCBenefitListVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSDictionary *> *dataSource;
@end

@implementation ZCCBenefitListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的权益";

    self.dataSource = @[
        @{@"id": @"B001", @"name": @"满减券",       @"desc": @"满200减30"},
        @{@"id": @"B002", @"name": @"免邮券",       @"desc": @"全场包邮"},
        @{@"id": @"B003", @"name": @"VIP折扣",      @"desc": @"9折优惠"},
    ];

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];

    ZCCLogInfo(@"权益列表页加载完成");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary *item = self.dataSource[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", item[@"name"], item[@"desc"]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *item = self.dataSource[indexPath.row];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"zccapp://benefit/detail?id=%@", item[@"id"]]];
    [[ZCCMediator sharedInstance] openURL:url];
}

@end
