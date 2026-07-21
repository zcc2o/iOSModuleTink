//
//  ZCCMediator+Business.m
//  ZCCMediator
//

#import "ZCCMediator+Business.h"

@implementation ZCCMediator (Business)

- (id<ZCCProductServiceProtocol>)productService {
    return [self serviceForProtocol:@protocol(ZCCProductServiceProtocol)];
}

- (id<ZCCBenefitServiceProtocol>)benefitService {
    return [self serviceForProtocol:@protocol(ZCCBenefitServiceProtocol)];
}

- (id<ZCCAssetServiceProtocol>)assetService {
    return [self serviceForProtocol:@protocol(ZCCAssetServiceProtocol)];
}

- (id<ZCCOrderServiceProtocol>)orderService {
    return [self serviceForProtocol:@protocol(ZCCOrderServiceProtocol)];
}

- (id<ZCCContractServiceProtocol>)contractService {
    return [self serviceForProtocol:@protocol(ZCCContractServiceProtocol)];
}

- (id<ZCCCertificateServiceProtocol>)certificateService {
    return [self serviceForProtocol:@protocol(ZCCCertificateServiceProtocol)];
}

@end
