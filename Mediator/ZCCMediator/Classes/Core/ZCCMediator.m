//
//  ZCCMediator.m
//  ZCCMediator
//

#import "ZCCMediator.h"
#import "ZCCModuleProtocol.h"

@interface ZCCMediator ()
/// 模块名 → 模块实例
@property (nonatomic, strong) NSMutableDictionary<NSString *, id> *modules;
/// 协议名 → 实现 Class
@property (nonatomic, strong) NSMutableDictionary<NSString *, Class> *serviceMap;
/// 协议名 → 已创建的实例缓存
@property (nonatomic, strong) NSMutableDictionary<NSString *, id> *serviceCache;
/// URL scheme → 路由处理 Block
@property (nonatomic, strong) NSMutableDictionary<NSString *, UIViewController * _Nullable (^)(NSURL *, NSDictionary *)> *routeHandlers;
@end

@implementation ZCCMediator

+ (instancetype)sharedInstance {
    static ZCCMediator *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _modules      = [NSMutableDictionary dictionary];
        _serviceMap   = [NSMutableDictionary dictionary];
        _serviceCache = [NSMutableDictionary dictionary];
        _routeHandlers = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - 模块注册

- (void)registerModule:(id)module name:(NSString *)moduleName {
    NSParameterAssert(module);
    NSParameterAssert(moduleName.length > 0);
    self.modules[moduleName] = module;

    // 调用模块的初始化方法
    if ([module respondsToSelector:@selector(moduleDidRegister)]) {
        [module moduleDidRegister];
    }
}

- (id)moduleForName:(NSString *)moduleName {
    return self.modules[moduleName];
}

#pragma mark - 服务注册

- (void)registerService:(Protocol *)protocol implClass:(Class)implClass {
    NSParameterAssert(protocol);
    NSParameterAssert(implClass);
    NSString *key = NSStringFromProtocol(protocol);
    self.serviceMap[key] = implClass;
}

- (id)serviceForProtocol:(Protocol *)protocol {
    NSString *key = NSStringFromProtocol(protocol);
    // 优先从缓存取
    id cached = self.serviceCache[key];
    if (cached) return cached;

    Class implClass = self.serviceMap[key];
    if (!implClass) {
        NSLog(@"[ZCCMediator] ⚠️ 未注册协议 %@ 的实现类", key);
        return nil;
    }

    id instance = [[implClass alloc] init];
    self.serviceCache[key] = instance;
    return instance;
}

#pragma mark - URL 路由

- (BOOL)openURL:(NSURL *)url {
    NSString *scheme = url.host ?: url.scheme;
    UIViewController * _Nullable (^handler)(NSURL *, NSDictionary *) = self.routeHandlers[scheme];
    if (!handler) {
        NSLog(@"[ZCCMediator] ⚠️ 未注册 scheme '%@' 的路由处理器", scheme);
        return NO;
    }

    // 解析 query parameters
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSURLComponents *components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
    for (NSURLQueryItem *item in components.queryItems) {
        params[item.name] = item.value;
    }

    UIViewController *vc = handler(url, params);
    if (!vc) return NO;

    // 获取当前最顶层的 ViewController 并 push
    UINavigationController *nav = (UINavigationController *)[self topViewController].navigationController;
    if (nav) {
        [nav pushViewController:vc animated:YES];
    } else {
        // fallback: modal 展示（包装一个 Nav）
        UINavigationController *wrap = [[UINavigationController alloc] initWithRootViewController:vc];
        [[self topViewController] presentViewController:wrap animated:YES completion:nil];
    }
    return YES;
}

- (void)registerRoute:(NSString *)scheme
              handler:(UIViewController * _Nullable (^)(NSURL *url, NSDictionary *params))handler {
    self.routeHandlers[scheme] = [handler copy];
}

#pragma mark - Private

- (UIViewController *)topViewController {
    UIViewController *root = UIApplication.sharedApplication.keyWindow.rootViewController;
    while (root.presentedViewController) {
        root = root.presentedViewController;
    }
    if ([root isKindOfClass:[UINavigationController class]]) {
        return [(UINavigationController *)root visibleViewController] ?: root;
    }
    return root;
}

@end
