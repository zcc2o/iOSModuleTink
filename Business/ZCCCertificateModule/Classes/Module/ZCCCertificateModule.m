//
//  ZCCCertificateModule.m
//  ZCCCertificateModule
//

#import "ZCCCertificateModule.h"
#import "ZCCCertificateService.h"
#import <ZCCMediator/ZCCMediator.h>

@implementation ZCCCertificateModule

+ (NSString *)moduleName { return @"CertificateModule"; }

- (void)moduleDidRegister {
    [[ZCCMediator sharedInstance] registerService:@protocol(ZCCCertificateServiceProtocol)
                                      implClass:[ZCCCertificateService class]];
    NSLog(@"[ZCCCertificateModule] 办证模块注册完成");
}

@end
