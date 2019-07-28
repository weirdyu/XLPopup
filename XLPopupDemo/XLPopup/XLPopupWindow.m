//
//  XLPopupWindow.m
//  XLPopupDemo
//
//  Created by weirdyu on 2019/7/24.
//  Copyright © 2019 weirdyu. All rights reserved.
//

#import "XLPopupWindow.h"

@interface XLPopupWindowViewController : UIViewController

@end

@implementation XLPopupWindowViewController

- (BOOL)shouldAutorotate
{
    return NO;
}

@end

@interface XLPopupWindow ()

@property (nonatomic, strong) UIWindow *currentWindow;

@end

@implementation XLPopupWindow

+ (instancetype)customWindow
{
    XLPopupWindow *window = [[XLPopupWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    window.rootViewController = [XLPopupWindowViewController new];
    return window;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        self.windowLevel = UIWindowLevelStatusBar-1;
    }
    return self;
}

- (UIView *)attachView
{
    return self.rootViewController.view;
}

- (void)show
{
    self.hidden = NO;
    self.alpha = 1;
    [self makeKeyAndVisible];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [[[UIApplication sharedApplication].delegate window] makeKeyWindow];
    }];
}

@end
