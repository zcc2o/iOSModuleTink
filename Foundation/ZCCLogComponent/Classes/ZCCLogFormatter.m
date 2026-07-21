//
//  ZCCLogFormatter.m
//  ZCCLogComponent
//

#import "ZCCLogFormatter.h"

@implementation ZCCLogFormatter

+ (NSString *)formatWithLevel:(ZCCLogLevel)level
                         file:(const char *)file
                         line:(int)line
                     function:(const char *)function
                      message:(NSString *)message {
    NSString *levelString;
    switch (level) {
        case ZCCLogLevelDebug: levelString = @"DEBUG"; break;
        case ZCCLogLevelInfo:  levelString = @"INFO";  break;
        case ZCCLogLevelWarn:  levelString = @"WARN";  break;
        case ZCCLogLevelError: levelString = @"ERROR"; break;
    }

    NSString *fileName = [[NSString stringWithUTF8String:file] lastPathComponent];
    return [NSString stringWithFormat:@"[ZCC %@] %@:%d | %@", levelString, fileName, line, message];
}

@end
