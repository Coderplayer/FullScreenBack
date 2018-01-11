//
//  ViewController.m
//  FullScreenBackDemo
//
//  Created by 李冠余 on 2018/1/11.
//  Copyright © 2018年 李冠余. All rights reserved.
//

#import "ViewController.h"
#import "SecViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.navigationController pushViewController:[[SecViewController alloc] init] animated:YES];
}
@end
