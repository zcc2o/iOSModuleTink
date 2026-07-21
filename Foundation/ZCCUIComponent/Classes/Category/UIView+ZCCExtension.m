//
//  UIView+ZCCExtension.m
//  ZCCUIComponent
//

#import "UIView+ZCCExtension.h"

@implementation UIView (ZCCExtension)

- (UIViewController *)zcc_viewController {
    UIResponder *responder = self.nextResponder;
    while (responder) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
        responder = responder.nextResponder;
    }
    return nil;
}

- (CGFloat)zcc_x         { return self.frame.origin.x; }
- (void)setLx_x:(CGFloat)x { CGRect f = self.frame; f.origin.x = x; self.frame = f; }

- (CGFloat)zcc_y         { return self.frame.origin.y; }
- (void)setLx_y:(CGFloat)y { CGRect f = self.frame; f.origin.y = y; self.frame = f; }

- (CGFloat)zcc_width     { return self.frame.size.width; }
- (void)setLx_width:(CGFloat)w { CGRect f = self.frame; f.size.width = w; self.frame = f; }

- (CGFloat)zcc_height    { return self.frame.size.height; }
- (void)setLx_height:(CGFloat)h { CGRect f = self.frame; f.size.height = h; self.frame = f; }

- (CGSize)zcc_size       { return self.frame.size; }
- (void)setLx_size:(CGSize)s { CGRect f = self.frame; f.size = s; self.frame = f; }

- (CGFloat)zcc_centerX   { return self.center.x; }
- (void)setLx_centerX:(CGFloat)x { self.center = CGPointMake(x, self.center.y); }

- (CGFloat)zcc_centerY   { return self.center.y; }
- (void)setLx_centerY:(CGFloat)y { self.center = CGPointMake(self.center.x, y); }

@end
