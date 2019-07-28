//
//  XLPopupWindow.h
//  XLPopupDemo
//
//  Created by weirdyu on 2019/7/24.
//  Copyright © 2019 weirdyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLPopupWindow : UIWindow

@property (nonatomic, readonly) UIView *attachView;

+ (instancetype)customWindow;

- (void)show;
- (void)dismiss;

@end
