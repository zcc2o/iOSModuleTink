//
//  ZCCProductService.h
//  ZCCProductModule
//
//  商品服务 — 实现 ZCCProductServiceProtocol，供 Mediator 和其他模块调用
//

#import <Foundation/Foundation.h>
#import <ZCCMediator/ZCCServiceProtocols.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCCProductService : NSObject <ZCCProductServiceProtocol>

@end

NS_ASSUME_NONNULL_END
