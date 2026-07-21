//
//  ZCCJSBridge.m
//  ZCCWebComponent
//

#import "ZCCJSBridge.h"

@interface ZCCJSBridge () <WKScriptMessageHandler>
@property (nonatomic, weak) WKWebView *webView;
@property (nonatomic, strong) NSMutableDictionary<NSString *, ZCCJSBridgeHandler> *handlers;
@end

@implementation ZCCJSBridge

- (instancetype)initWithWebView:(WKWebView *)webView {
    self = [super init];
    if (self) {
        _webView = webView;
        _handlers = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)registerHandler:(NSString *)handlerName handler:(ZCCJSBridgeHandler)handler {
    self.handlers[handlerName] = [handler copy];
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:handlerName];
}

- (void)callHandler:(NSString *)handlerName
               data:(id)data
           response:(void (^)(id))responseCallback {
    NSString *script = [NSString stringWithFormat:@"window.bridge.%@(%@)", handlerName,
                        data ? [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:data options:0 error:nil]
                                                     encoding:NSUTF8StringEncoding] : @"null"];
    [self.webView evaluateJavaScript:script completionHandler:^(id result, NSError *error) {
        if (responseCallback) {
            responseCallback(result);
        }
    }];
}

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    ZCCJSBridgeHandler handler = self.handlers[message.name];
    if (handler) {
        handler(message.body, ^(id response) {
            // 回调结果回传给 JS
        });
    }
}

@end
