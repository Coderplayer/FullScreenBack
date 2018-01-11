//
//  LGYShotView.m
//  FUllScreenBack
//
//  Created by 李冠余 on 2018/1/10.
//  Copyright © 2018年 李冠余. All rights reserved.
//

#import "LGYShotView.h"

@implementation LGYShotView {
    __weak UIImageView *_imgView;
    __weak UIView *_maskView;
    NSMutableArray *_screenShotImages;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _screenShotImages = [NSMutableArray array];
        self.backgroundColor = [UIColor blackColor];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:imgView];
        _imgView = imgView;
        
        UIView *maskView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:maskView];
        _maskView = maskView;
        _maskView.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0.4];
    }
    return self;
}

- (void)showEffectChange:(CGPoint)point {
    if (point.x > 0) {
        _maskView.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:-point.x / kLGYScreenW * 0.4 + 0.4];
        _imgView.transform = CGAffineTransformMakeScale(0.95 + (point.x / kLGYScreenW * 0.05), 0.95 + (point.x / kLGYScreenW * 0.05));
    }
}
- (void)restore {
    if (_maskView && _imgView) {
        _maskView.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0.4];
        _imgView.transform = CGAffineTransformMakeScale(0.95, 0.95);
    }
}
- (void)screenShot {}
@end
