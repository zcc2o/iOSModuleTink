//
//  ZCCLogger.m
//  ZCCLogComponent
//

#import "ZCCLogger.h"
#import "ZCCLogFormatter.h"

static ZCCLogLevel _minimumLogLevel = ZCCLogLevelDebug;

@implementation ZCCLogger

+ (ZCCLogLevel)minimumLogLevel {
    return _minimumLogLevel;
}

+ (void)setMinimumLogLevel:(ZCCLogLevel)level {
    _minimumLogLevel = level;
}

+ (void)logWithLevel:(ZCCLogLevel)level
                file:(const char *)file
                line:(int)line
            function:(const char *)function
             message:(NSString *)message {
    if (level < _minimumLogLevel) return;

    NSString *formatted = [ZCCLogFormatter formatWithLevel:level
                                                     file:file
                                                     line:line
                                                 function:function
                                                  message:message];
#if DEBUG
    NSLog(@"%@", formatted);
#else
    // Release 模式下可写入文件或上报到日志平台
#endif
}

@end
