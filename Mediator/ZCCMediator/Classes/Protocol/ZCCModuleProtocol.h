//
//  ZCCModuleProtocol.h
//  ZCCMediator
//
//  模块生命周期协议 — 每个业务 Pod 需要提供一个实现此协议的模块入口类
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZCCModuleProtocol <NSObject>

@required
/// 模块唯一标识（如 "ProductModule"）
+ (NSString *)moduleName;

@optional
/// 模块被注册到 Mediator 后调用
- (void)moduleDidRegister;

/// 模块即将被卸载时调用
- (void)moduleWillUnregister;

@end

NS_ASSUME_NONNULL_END
