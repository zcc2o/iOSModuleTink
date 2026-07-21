//
//  ZCCMediator.h
//  ZCCMediator
//
//  核心中介者（单例）— 基于有赞 Bifrost 协议的注册/查找模式
//  业务模块通过此中介者注册服务并通过协议获取其他模块的服务，
//  从而消除模块间的直接依赖。
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCCMediator : NSObject

/// 单例
+ (instancetype)sharedInstance;

#pragma mark - 模块注册

/// 注册一个模块（实现 ZCCModuleProtocol 的对象），在 App 启动时调用
/// @param module 模块实例
/// @param moduleName 模块唯一标识（如 "ProductModule"）
- (void)registerModule:(id)module name:(NSString *)moduleName;

/// 获取已注册的模块实例
- (id _Nullable)moduleForName:(NSString *)moduleName;

#pragma mark - 服务注册（协议 → 实现）

/// 注册一个服务协议对应的实现类
/// @param protocol 服务协议（如 @protocol(ZCCProductServiceProtocol)）
/// @param implClass 实现该协议的 Class（如 [ZCCProductService class]）
- (void)registerService:(Protocol *)protocol implClass:(Class)implClass;

/// 通过协议获取服务实例（懒加载，首次调用时创建）
/// @param protocol 服务协议
- (id _Nullable)serviceForProtocol:(Protocol *)protocol;

#pragma mark - 跨模块 URL 路由

/// 通过 URL 打开一个模块内的页面（如 zccapp://product/detail?id=123）
/// @param url 路由 URL
/// @return 是否成功路由
- (BOOL)openURL:(NSURL *)url;

/// 注册 URL 路由处理器
/// @param scheme URL scheme（如 "product"）
/// @param handler 处理 Block，返回目标 ViewController
- (void)registerRoute:(NSString *)scheme
              handler:(UIViewController * _Nullable (^)(NSURL *url, NSDictionary *params))handler;

@end

NS_ASSUME_NONNULL_END
