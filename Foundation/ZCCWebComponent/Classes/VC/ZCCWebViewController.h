//
//  ZCCWebViewController.h
//  ZCCWebComponent
//
//  基于 WKWebView 的通用 Web 容器页面
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCCWebViewController : UIViewController

/// WKWebView 实例
@property (nonatomic, strong, readonly) WKWebView *webView;
/// 加载指定 URL
@property (nonatomic, copy, nullable) NSURL *url;
/// 是否显示进度条（默认 YES）
@property (nonatomic, assign) BOOL showProgress;

/// 初始化方法
- (instancetype)initWithURL:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
