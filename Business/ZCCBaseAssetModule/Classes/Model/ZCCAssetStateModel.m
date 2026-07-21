//
//  ZCCAssetStateModel.m
//  ZCCAssetModule
//

#import "ZCCAssetStateModel.h"

@interface ZCCAssetStateModel ()
@property (nonatomic, strong, readwrite) ZCCButtonStateInfo *orderButtonInfo;
@property (nonatomic, strong, readwrite) ZCCButtonStateInfo *contractButtonInfo;
@property (nonatomic, strong, readwrite) ZCCButtonStateInfo *certButtonInfo;
@end

@implementation ZCCAssetStateModel

- (void)updateWithOrderState:(ZCCOrderState)order
              contractState:(ZCCContractState)contract
                  certState:(ZCCCertState)cert
        orderStateNameBlock:(NSString *(^)(ZCCOrderState))orderNameBlock
    contractStateNameBlock:(NSString *(^)(ZCCContractState))contractNameBlock
        certStateNameBlock:(NSString *(^)(ZCCCertState))certNameBlock {

    self.orderButtonInfo    = [self computeOrder:order   nameBlock:orderNameBlock];
    self.contractButtonInfo = [self computeContract:order contract:contract nameBlock:contractNameBlock];
    self.certButtonInfo     = [self computeCert:order contract:contract cert:cert nameBlock:certNameBlock];
}

#pragma mark - 订单：始终可点击

- (ZCCButtonStateInfo *)computeOrder:(ZCCOrderState)order
                           nameBlock:(NSString *(^)(ZCCOrderState))nameBlock {
    ZCCButtonStateInfo *info = [[ZCCButtonStateInfo alloc] init];
    info.stateText = [NSString stringWithFormat:@"%@ >", nameBlock(order)];
    info.state = ZCCButtonUIStateNormal;
    info.clickable = YES;
    info.colorHex = (order == ZCCOrderStateCompleted) ? @"#22C55E" : @"#5D6667";
    return info;
}

#pragma mark - 合同：订单已完成 → 可点击

- (ZCCButtonStateInfo *)computeContract:(ZCCOrderState)order
                               contract:(ZCCContractState)contract
                              nameBlock:(NSString *(^)(ZCCContractState))nameBlock {
    ZCCButtonStateInfo *info = [[ZCCButtonStateInfo alloc] init];
    BOOL orderDone = (order == ZCCOrderStateCompleted);

    if (!orderDone) {
        info.stateText = @"请先完成订单";
        info.state = ZCCButtonUIStateDisabled;
        info.clickable = NO;
        info.colorHex = @"#CCCCCC";
    } else if (contract >= ZCCContractStateSigned) {
        info.stateText = @"已签署 >";
        info.state = ZCCButtonUIStateDone;
        info.clickable = YES;
        info.colorHex = @"#22C55E";
    } else if (contract < 0) {
        info.stateText = @"已失效 >";
        info.state = ZCCButtonUIStateDisabled;
        info.clickable = NO;
        info.colorHex = @"#EF4444";
    } else {
        info.stateText = [NSString stringWithFormat:@"%@ >", nameBlock(contract)];
        info.state = ZCCButtonUIStateNormal;
        info.clickable = YES;
        info.colorHex = @"#5D6667";
    }
    return info;
}

#pragma mark - 办证：合同已签订/生效中 → 可点击

- (ZCCButtonStateInfo *)computeCert:(ZCCOrderState)order
                           contract:(ZCCContractState)contract
                               cert:(ZCCCertState)cert
                          nameBlock:(NSString *(^)(ZCCCertState))nameBlock {
    ZCCButtonStateInfo *info = [[ZCCButtonStateInfo alloc] init];
    BOOL orderDone = (order == ZCCOrderStateCompleted);
    BOOL contractDone = (contract >= ZCCContractStateSigned);

    if (!orderDone) {
        info.stateText = @"请先完成订单";
        info.state = ZCCButtonUIStateDisabled;
        info.clickable = NO;
        info.colorHex = @"#CCCCCC";
    } else if (!contractDone) {
        info.stateText = @"请先签署合同";
        info.state = ZCCButtonUIStateDisabled;
        info.clickable = NO;
        info.colorHex = @"#CCCCCC";
    } else if (cert == ZCCCertStateAuthDone) {
        info.stateText = @"认证完成 >";
        info.state = ZCCButtonUIStateDone;
        info.clickable = YES;
        info.colorHex = @"#22C55E";
    } else if (cert == ZCCCertStateAuthFailed) {
        info.stateText = @"认证失败 >";
        info.state = ZCCButtonUIStateNormal;
        info.clickable = YES;
        info.colorHex = @"#EF4444";
    } else {
        info.stateText = [NSString stringWithFormat:@"%@ >", nameBlock(cert)];
        info.state = ZCCButtonUIStateNormal;
        info.clickable = YES;
        info.colorHex = @"#F59E0B";
    }
    return info;
}

@end
