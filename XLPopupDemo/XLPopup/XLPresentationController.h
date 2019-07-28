//
//  XLPresentationController.h
//  XLPopupDemo
//
//  Created by weirdyu on 2019/7/25.
//  Copyright © 2019 weirdyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLPopupDefinition.h"

typedef NS_ENUM(NSInteger, XLPresentationPostion) {
    XLPresentationPostionTop,
    XLPresentationPostionBottom,
    XLPresentationPostionCenter,
    XLPresentationPostionCustom
};

@interface XLPresentationController : UIPresentationController <UIViewControllerTransitioningDelegate>

/**
 初始化presentationController

 @example
    UIViewController *vc = [UIViewController new];
    vc.view.backgroundColor = [UIColor whiteColor];
    // set viewController display size
    vc.preferredContentSize = CGSizeMake(vc.view.frame.size.width, vc.view.frame.size.height/2);
    XLPresentationController *presentation = [[XLPresentationController alloc] initWithPresentedViewController:vc presentingViewController:navigationController position:XLPresentationPostionCenter showType:XLPopupShowTypeScaleOut maskType:XLPopupMaskTypeNormal];
    [presentation setupMaskViewTapBlock:^(UIViewController *presentedViewController) {
        [vc dismissViewControllerAnimated:YES completion:NULL];
    }];
    vc.transitioningDelegate = presentation;
    [navigationController presentViewController:vc animated:YES completion:NULL];
 
 @param presentedViewController 被弹出视图控制器
 @param presentingViewController 原视图控制器
 @param showType 弹出方式
 @return 实例
 */
- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController
                       presentingViewController:(UIViewController *)presentingViewController
                                        postion:(XLPresentationPostion)position
                                       showType:(XLPopupShowType)showType
                                       maskType:(XLPopupMaskType)maskType;

/**
 设置最终显示位置（center）

 @param block 位置回调
 */
- (void)setupCustomFinalCenterBlock:(CGPoint(^)(void))block;

/**
 点击背景视图回调
 
 @param block 点击回调
 */
- (void)setupMaskViewTapBlock:(void(^)(UIViewController *presentedViewController))block;

@end
