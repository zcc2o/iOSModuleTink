//
//  ZCCAssetService.h
//  ZCCBaseAssetModule
//

#import <Foundation/Foundation.h>
#import <ZCCMediator/ZCCServiceProtocols.h>

NS_ASSUME_NONNULL_BEGIN

typedef UIViewController * _Nullable (^ZCCAssetVCFactory)(NSString * _Nullable assetId);

@interface ZCCAssetService : NSObject <ZCCAssetServiceProtocol>

/// Standard 层注入 VC 创建逻辑
@property (nonatomic, copy, nullable) ZCCAssetVCFactory detailVCFactory;
@property (nonatomic, copy, nullable) ZCCAssetVCFactory listVCFactory;

@end

NS_ASSUME_NONNULL_END
