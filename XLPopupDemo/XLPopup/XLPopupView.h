//
//  XLPopupView.h
//  XLPopupDemo
//
//  Created by weirdyu on 2019/7/24.
//  Copyright © 2019 weirdyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLPopupDefinition.h"
/**
 弹框基类需要实现的协议
 */
@class XLPopupView;
@protocol XLPopupViewDelegate <NSObject>

@required
- (void)popupViewLayoutFinalPostion;
@optional
- (void)popupViewShowAnimationCustom;
- (void)popupViewDismissAnimationCustom;
- (BOOL)popupViewDismissWhenMaskViewDidTap;

@end

/**
 弹框基类
 */
@interface XLPopupView : UIView

@property (nonatomic, strong) UIVisualEffectView *maskView;
@property (nonatomic, weak) id <XLPopupViewDelegate> delegate;

- (instancetype)initWithSuperView:(UIView *)superView
                         showType:(XLPopupShowType)showType
                         maskType:(XLPopupMaskType)maskType;

- (void)show;
- (void)dismiss;
- (void)showWithCompletion:(dispatch_block_t)completion;
- (void)dismissWithCompletion:(dispatch_block_t)completion;

@end
