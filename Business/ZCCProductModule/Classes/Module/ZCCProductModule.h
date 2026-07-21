//
//  ZCCProductModule.h
//  ZCCProductModule
//
//  商品模块入口 — 实现 ZCCModuleProtocol，在注册到 Mediator 时完成服务注册
//

#import <Foundation/Foundation.h>
#import <ZCCMediator/ZCCModuleProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCCProductModule : NSObject <ZCCModuleProtocol>

@end

NS_ASSUME_NONNULL_END
