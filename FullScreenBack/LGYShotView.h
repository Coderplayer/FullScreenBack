//
//  LGYShotView.h
//  FUllScreenBack
//
//  Created by 李冠余 on 2018/1/10.
//  Copyright © 2018年 李冠余. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kLGYScreenW [[UIScreen mainScreen] bounds].size.width
#define kLGYScreenH [[UIScreen mainScreen] bounds].size.height

@interface LGYShotView : UIView
@property (nonatomic,weak,readonly) UIImageView * imgView;
//@property (nonatomic,weak,readonly) UIView * maskView;
@property (nonatomic, weak,readonly) UIView * maskView;
@property (nonatomic,strong,readonly) NSMutableArray *screenShotImages;

- (void)showEffectChange:(CGPoint)point;
- (void)restore;
- (void)screenShot;
@end
