//
//  ZCCLogger.h
//  ZCCLogComponent
//
//  统一日志宏 — 提供 Debug / Info / Warn / Error 四个级别
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ZCCLogLevel) {
    ZCCLogLevelDebug,
    ZCCLogLevelInfo,
    ZCCLogLevelWarn,
    ZCCLogLevelError,
};

@interface ZCCLogger : NSObject

/// 全局日志级别，低于此级别的日志将不输出（默认 Debug）
@property (class, nonatomic, assign) ZCCLogLevel minimumLogLevel;

/// 直接输出一条日志
+ (void)logWithLevel:(ZCCLogLevel)level
                file:(const char *)file
                line:(int)line
            function:(const char *)function
             message:(NSString *)message;

@end

// ── 便捷宏 ──
#define ZCCLogDebug(fmt, ...) \
    [ZCCLogger logWithLevel:ZCCLogLevelDebug file:__FILE__ line:__LINE__ function:__FUNCTION__ \
                   message:[NSString stringWithFormat:(fmt), ##__VA_ARGS__]]

#define ZCCLogInfo(fmt, ...) \
    [ZCCLogger logWithLevel:ZCCLogLevelInfo file:__FILE__ line:__LINE__ function:__FUNCTION__ \
                   message:[NSString stringWithFormat:(fmt), ##__VA_ARGS__]]

#define ZCCLogWarn(fmt, ...) \
    [ZCCLogger logWithLevel:ZCCLogLevelWarn file:__FILE__ line:__LINE__ function:__FUNCTION__ \
                   message:[NSString stringWithFormat:(fmt), ##__VA_ARGS__]]

#define ZCCLogError(fmt, ...) \
    [ZCCLogger logWithLevel:ZCCLogLevelError file:__FILE__ line:__LINE__ function:__FUNCTION__ \
                   message:[NSString stringWithFormat:(fmt), ##__VA_ARGS__]]

NS_ASSUME_NONNULL_END
