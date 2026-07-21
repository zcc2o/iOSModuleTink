//
//  ZCCJSBridge.h
//  ZCCWebComponent
//
//  简易 JS Bridge — 提供 Native ↔ H5 双向通信能力
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

/// JS 调用 Native 的回调
typedef void (^ZCCJSBridgeHandler)(id _Nullable params, void (^responseCallback)(id _Nullable response));

@interface ZCCJSBridge : NSObject

- (instancetype)initWithWebView:(WKWebView *)webView;

/// 注册一个 Native 方法供 JS 调用
- (void)registerHandler:(NSString *)handlerName handler:(ZCCJSBridgeHandler)handler;

/// Native 调用 JS 方法
- (void)callHandler:(NSString *)handlerName
               data:(id _Nullable)data
           response:(void (^_Nullable)(id _Nullable response))responseCallback;

@end

NS_ASSUME_NONNULL_END
