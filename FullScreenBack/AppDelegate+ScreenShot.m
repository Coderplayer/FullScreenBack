//
//  AppDelegate+ScreenShot.m
//  FUllScreenBack
//
//  Created by 李冠余 on 2018/1/10.
//  Copyright © 2018年 李冠余. All rights reserved.
//

#import "AppDelegate+ScreenShot.h"
#import "LGYSwizzlingDefine.h"

static NSString *kLGYScreenShotViewKey = @"LGYScreenShotViewKey";
static char kLGYListenTabbarViewMove[] = "LGYListenTabbarViewMove";

@implementation AppDelegate (ScreenShot)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzling_exchangeMethod([self class], @selector(application:didFinishLaunchingWithOptions:), @selector(swizzling_application:didFinishLaunchingWithOptions:));
    });
}

- (BOOL)swizzling_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    BOOL isFinish = [self swizzling_application:application didFinishLaunchingWithOptions:launchOptions];
    [self lgySetScreenshotView];
    return isFinish;
}

- (void)setScreenshotView:(LGYShotView *)screenshotView {
    objc_setAssociatedObject(self, &kLGYScreenShotViewKey,screenshotView, OBJC_ASSOCIATION_ASSIGN);
}

- (LGYShotView *)screenshotView {
    return objc_getAssociatedObject(self, &kLGYScreenShotViewKey);
}

- (void)lgySetScreenshotView {
    LGYShotView *screenshotView = [[LGYShotView alloc] initWithFrame:CGRectMake(0, 0, kLGYScreenW, kLGYScreenH)];
    [self.window insertSubview:screenshotView atIndex:0];
    self.screenshotView = screenshotView;
    
    [self.window.rootViewController.view addObserver:self
                                          forKeyPath:@"transform"
                                             options:NSKeyValueObservingOptionNew
                                             context:kLGYListenTabbarViewMove];
    self.screenshotView.hidden = YES;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (context == kLGYListenTabbarViewMove) {
        NSValue *value  = [change objectForKey:NSKeyValueChangeNewKey];
        CGAffineTransform newTransform = [value CGAffineTransformValue];
        [self.screenshotView showEffectChange:CGPointMake(newTransform.tx, 0) ];
    }
}
@end
