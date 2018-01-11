//
//  AppDelegate+lll.m
//  FUllScreenBack
//
//  Created by 李冠余 on 2018/1/10.
//  Copyright © 2018年 李冠余. All rights reserved.
//

#import "AppDelegate+lll.h"
#import "LGYSwizzlingDefine.h"
@implementation AppDelegate (lll)
+ (void)load {
    NSLog(@"-lllLoad");
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        swizzling_exchangeMethod([self class], @selector(application:didFinishLaunchingWithOptions:), @selector(lll_application:didFinishLaunchingWithOptions:));
    });
}

- (BOOL)lll_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"-----lllfinish");
    return [self lll_application:application didFinishLaunchingWithOptions:launchOptions];
}

/** 如果分类重写原类的方法，原类的方法将不会在执行 */
//- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    return YES;
//}
@end
