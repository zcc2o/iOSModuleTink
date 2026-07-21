//
//  ZCCWebViewController.m
//  ZCCWebComponent
//

#import "ZCCWebViewController.h"
#import <ZCCLogComponent/ZCCLogger.h>

@interface ZCCWebViewController () <WKNavigationDelegate>

@property (nonatomic, strong, readwrite) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation ZCCWebViewController

- (instancetype)initWithURL:(NSURL *)url {
    self = [super init];
    if (self) {
        _url = url;
        _showProgress = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.webView];
    if (self.showProgress) {
        [self.view addSubview:self.progressView];
    }

    if (self.url) {
        [self loadRequest];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.webView.frame = self.view.bounds;
    self.progressView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 2);
}

- (WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
        _webView.navigationDelegate = self;
    }
    return _webView;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.trackTintColor = [UIColor clearColor];
    }
    return _progressView;
}

- (void)loadRequest {
    ZCCLogInfo(@"ZCCWebComponent: loading %@", self.url.absoluteString);
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:request];
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    ZCCLogDebug(@"ZCCWebComponent: page loaded");
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    ZCCLogError(@"ZCCWebComponent: load failed - %@", error.localizedDescription);
}

@end
