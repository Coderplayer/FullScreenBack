//
//  UINavigationController+FullBackNavi.m
//  FUllScreenBack
//
//  Created by 李冠余 on 2018/1/10.
//  Copyright © 2018年 李冠余. All rights reserved.
//

#import "UINavigationController+FullBackNavi.h"
#import "LGYSwizzlingDefine.h"
#import "AppDelegate.h"
#import "AppDelegate+ScreenShot.h"

#define LGYDISTANCETOPOP 80
static NSString *kLGYPanGestureKey = @"LGYPanGestureKey";

@interface UINavigationController ()<UIGestureRecognizerDelegate>
@property(nonatomic,weak)UIPanGestureRecognizer *lgyPan;
@end

@implementation UINavigationController (FullBackNavi)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzling_exchangeMethod([self class],@selector(viewDidLoad), @selector(swizzling_viewDidLoad));
        swizzling_exchangeMethod([self class],@selector(pushViewController:animated:), @selector(swizzling_pushViewController:animated:));
        swizzling_exchangeMethod([self class], @selector(popViewControllerAnimated:), @selector(swizzling_popViewControllerAnimated:));
        
        swizzling_exchangeMethod([self class],@selector(popToViewController:animated:), @selector(swizzling_popToViewController:animated:));
        swizzling_exchangeMethod([self class], @selector(popToRootViewControllerAnimated:), @selector(swizzling_popToRootViewControllerAnimated:));
    });
}

- (void)setLgyPan:(UIPanGestureRecognizer *)lgyPan {
    objc_setAssociatedObject(self, &kLGYPanGestureKey, lgyPan, OBJC_ASSOCIATION_ASSIGN);
}

- (UIPanGestureRecognizer *)lgyPan {
   return objc_getAssociatedObject(self, &kLGYPanGestureKey);
}

- (void)swizzling_viewDidLoad {
    [self swizzling_viewDidLoad];
    UIPanGestureRecognizer *lgyPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesIng:)];
    lgyPan.delegate = self;
    [self.view addGestureRecognizer:lgyPan];
    self.lgyPan = lgyPan;
}

- (void)panGesIng:(UIPanGestureRecognizer *)panGes {
    if (self.viewControllers.count == 1) {
        return;
    }
    //    NSLog(@"nav pan");
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *rootVC = appdelegate.window.rootViewController;
    UIViewController *presentedVC = rootVC.presentedViewController;
    
    if (panGes.state == UIGestureRecognizerStateBegan) {
        appdelegate.screenshotView.hidden = NO;
    } else if (panGes.state == UIGestureRecognizerStateChanged)  {
        CGPoint pt = [panGes translationInView:self.view];
        
        if (pt.x >= 10) {
            rootVC.view.transform = CGAffineTransformMakeTranslation(pt.x - 10, 0);
            presentedVC.view.transform = CGAffineTransformMakeTranslation(pt.x - 10, 0);
        }
    } else if (panGes.state == UIGestureRecognizerStateEnded) {
        CGPoint pt = [panGes translationInView:self.view];
        if (pt.x >= LGYDISTANCETOPOP) {
            [UIView animateWithDuration:0.3 animations:^{
                rootVC.view.transform = CGAffineTransformMakeTranslation(kLGYScreenW, 0);
                presentedVC.view.transform = CGAffineTransformMakeTranslation(kLGYScreenW, 0);
            } completion:^(BOOL finished) {
                [self popViewControllerAnimated:NO];
                rootVC.view.transform = CGAffineTransformIdentity;
                presentedVC.view.transform = CGAffineTransformIdentity;
                appdelegate.screenshotView.hidden = YES;
            }];
        } else {
            [UIView animateWithDuration:0.3 animations:^{
                rootVC.view.transform = CGAffineTransformIdentity;
                presentedVC.view.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                appdelegate.screenshotView.hidden = YES;
            }];
        }
    }
}
- (void)swizzling_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(kLGYScreenW, kLGYScreenH), YES, 0);
        [appdelegate.window.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [appdelegate.screenshotView.screenShotImages addObject:viewImage];
        appdelegate.screenshotView.imgView.image = viewImage;
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [self swizzling_pushViewController:viewController animated:YES];
}

- (UIViewController *)swizzling_popViewControllerAnimated:(BOOL)animated {
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdelegate.screenshotView.screenShotImages removeLastObject];
    UIImage *image = [appdelegate.screenshotView.screenShotImages lastObject];
    if (image) {
        appdelegate.screenshotView.imgView.image = image;
    }
    return [self swizzling_popViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)swizzling_popToRootViewControllerAnimated:(BOOL)animated {
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSMutableArray *images = appdelegate.screenshotView.screenShotImages;
    if (images.count > 2) {
        [images removeObjectsInRange:NSMakeRange(1, images.count - 1)];
    }
    UIImage *image = [images lastObject];
    if (image) {
        appdelegate.screenshotView.imgView.image = image;
    }
    return [self swizzling_popToRootViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)swizzling_popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSArray *popControllers = [self swizzling_popToViewController:viewController  animated:animated];
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSMutableArray *images = appdelegate.screenshotView.screenShotImages;
    NSInteger imagesCount = images.count;
    NSUInteger popVCsCount = popControllers.count;
    (imagesCount <= popVCsCount) ? : [images removeObjectsInRange:NSMakeRange(imagesCount, popVCsCount - imagesCount)];
    return popControllers;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    NSLog(@"------%@",gestureRecognizer);
    if (gestureRecognizer == self.lgyPan) {
        CGFloat transX = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:self.view].x;
        if (transX < 0) {
            return NO;
        }
    }
    return YES;
}
@end
