//
//  ZCCLogFormatter.h
//  ZCCLogComponent
//

#import <Foundation/Foundation.h>
#import "ZCCLogger.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZCCLogFormatter : NSObject

+ (NSString *)formatWithLevel:(ZCCLogLevel)level
                         file:(const char *)file
                         line:(int)line
                     function:(const char *)function
                      message:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
