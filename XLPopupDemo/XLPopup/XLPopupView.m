//
//  XLPopupView.m
//  XLPopupDemo
//
//  Created by weirdyu on 2019/7/24.
//  Copyright © 2019 weirdyu. All rights reserved.
//

#import "XLPopupView.h"
#import "XLPopupWindow.h"
#import <Masonry.h>
#import <YYCategories.h>

@interface XLPopupView ()

@property (nonatomic, strong) UIView *superView;
@property (nonatomic, assign) XLPopupShowType showType;
@property (nonatomic, strong) XLPopupWindow *customWindow;

@end

@implementation XLPopupView

#pragma mark - Init Method

- (instancetype)initWithSuperView:(UIView *)superView
                     showType:(XLPopupShowType)showType
                         maskType:(XLPopupMaskType)maskType
{
    if (self = [super initWithFrame:CGRectZero]) {
        [self setupSubviews:superView showType:showType maskType:maskType];
    }
    return self;
}

#pragma mark - UI Method

- (void)setupSubviews:(UIView *)superView showType:(XLPopupShowType)showType maskType:(XLPopupMaskType)maskType
{
    if (!superView) {
        XLPopupWindow *window = [XLPopupWindow customWindow];
        _customWindow = window;
        superView = window.attachView;
    }
    _showType = showType;
    [self setupBackgroundView:superView maskType:maskType];
    [superView addSubview:self];
    _superView = superView;
}

- (void)setupBackgroundView:(UIView *)superView maskType:(XLPopupMaskType)maskType
{
    if (maskType == XLPopupMaskTypeNone) {
        return;
    }else if (maskType == XLPopupMaskTypeClear) {
        _maskView = [[UIVisualEffectView alloc] initWithFrame:superView.bounds];
        _maskView.backgroundColor = [UIColor clearColor];
    }else if (maskType == XLPopupMaskTypeNormal) {
        _maskView = [[UIVisualEffectView alloc] initWithFrame:superView.bounds];
        _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    }else if (maskType == XLPopupMaskTypeLightBlur) {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _maskView = [[UIVisualEffectView alloc] initWithEffect:blur];
        _maskView.frame = superView.bounds;
    }else {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _maskView = [[UIVisualEffectView alloc] initWithEffect:blur];
        _maskView.frame = superView.bounds;
    }
    _maskView.alpha = 0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onMaskViewTapAction:)];
    [_maskView addGestureRecognizer:tap];
    [superView addSubview:_maskView];
}

#pragma mark - Event Response

- (void)onMaskViewTapAction:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(popupViewDismissWhenMaskViewDidTap)]) {
        BOOL needAutoDismiss = [self.delegate popupViewDismissWhenMaskViewDidTap];
        if (needAutoDismiss) [self dismiss];
    }
}

- (void)show
{
    if ([self.delegate respondsToSelector:@selector(popupViewLayoutFinalPostion)]) {
        [self.delegate popupViewLayoutFinalPostion];
    }
    [self showWithCompletion:NULL];
}

- (void)showWithCompletion:(dispatch_block_t)completion
{
    [self layoutIfNeeded];
    [self.superView layoutIfNeeded];
    if (_customWindow) [_customWindow show];
    switch (self.showType) {
        case XLPopupShowTypeFromBottom:{
            [self showAnimationFromBottom:completion];
            break;
        }
        case XLPopupShowTypeFromTop:{
            [self showAnimationFromTop:completion];
            break;
        }
        case XLPopupShowTypeScaleOut:{
            [self showAnimationScaleOut:completion];
            break;
        }
        case XLPopupShowTypeScaleIn:{
            [self showAnimationScaleIn:completion];
            break;
        }
        case XLPopupShowTypeCustom:{
            if ([self.delegate respondsToSelector:@selector(popupViewShowAnimationCustom)]) {
                [self.delegate popupViewShowAnimationCustom];
            }
            break;
        }
        default:
            break;
    }
}

- (void)dismiss
{
    [self dismissWithCompletion:NULL];
}

- (void)dismissWithCompletion:(dispatch_block_t)completion
{
    if (_customWindow) {
        [_customWindow dismiss];
        _customWindow = nil;
    }
    [self endEditing:YES];
    switch (self.showType) {
        case XLPopupShowTypeFromBottom:{
            [self dismissAnimationFromBottom:completion];
            break;
        }
        case XLPopupShowTypeFromTop:{
            [self dismissAnimationFromTop:completion];
            break;
        }
        case XLPopupShowTypeScaleOut:{
            [self dismissAnimationScaleOut:completion];
            break;
        }
        case XLPopupShowTypeScaleIn:{
            [self dismissAnimationScaleIn:completion];
            break;
        }
        case XLPopupShowTypeCustom:{
            if ([self.delegate respondsToSelector:@selector(popupViewDismissAnimationCustom)]) {
                [self.delegate popupViewDismissAnimationCustom];
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark - show Animation

- (void)showAnimationFromBottom:(dispatch_block_t)completion
{
    self.transform = CGAffineTransformMakeTranslation(0, self.superView.frame.size.height - CGRectGetMinY(self.frame));
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.maskView.alpha = 1.0;
                         self.transform = CGAffineTransformIdentity;
                     } completion:^(BOOL finished) {
                         if (completion) completion();
                     }];
}

- (void)showAnimationFromTop:(dispatch_block_t)completion
{
    self.transform = CGAffineTransformMakeTranslation(0, - CGRectGetMaxY(self.frame));
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.maskView.alpha = 1.0;
                         self.transform = CGAffineTransformIdentity;
                     } completion:^(BOOL finished) {
                         if (completion) completion();
                     }];
}

- (void)showAnimationScaleOut:(dispatch_block_t)completion
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 8;
    self.transform = CGAffineTransformMakeScale(0.8, 0.8);
    self.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        self.maskView.alpha = 1.0;
        self.alpha = 1.0;
    }];
    [UIView animateWithDuration:0.4
                          delay:0
         usingSpringWithDamping:0.6
          initialSpringVelocity:0.8
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.transform = CGAffineTransformIdentity;
                     } completion:^(BOOL finished) {
                         if (completion) completion();
                     }];
}

- (void)showAnimationScaleIn:(dispatch_block_t)completion
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 8;
    self.transform = CGAffineTransformMakeScale(1.2, 1.2);
    self.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        self.maskView.alpha = 1.0;
        self.alpha = 1.0;
    }];
    [UIView animateWithDuration:0.4
                          delay:0
         usingSpringWithDamping:0.6
          initialSpringVelocity:0.8
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.transform = CGAffineTransformIdentity;
                     } completion:^(BOOL finished) {
                         if (completion) completion();
                     }];
}

#pragma mark - dismiss Animation

- (void)dismissAnimationFromBottom:(dispatch_block_t)completion
{
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.maskView.alpha = 0;
                         self.transform = CGAffineTransformMakeTranslation(0, self.superView.frame.size.height - CGRectGetMinY(self.frame));
                     } completion:^(BOOL finished) {
                         [self.maskView removeFromSuperview];
                         [self removeFromSuperview];
                         if (completion) completion();
                     }];
}


- (void)dismissAnimationFromTop:(dispatch_block_t)completion
{
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.maskView.alpha = 0;
                         self.transform = CGAffineTransformMakeTranslation(0, - CGRectGetMaxY(self.frame));
                     } completion:^(BOOL finished) {
                         [self.maskView removeFromSuperview];
                         [self removeFromSuperview];
                         if (completion) completion();
                     }];
}

- (void)dismissAnimationScaleOut:(dispatch_block_t)completion
{
    [UIView animateWithDuration:0.2 animations:^{
        self.maskView.alpha = 0;
        self.alpha = 0;
    }];
    [UIView animateWithDuration:0.4
                          delay:0
         usingSpringWithDamping:0.9
          initialSpringVelocity:1
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.transform = CGAffineTransformMakeScale(0.8, 0.8);
                     } completion:^(BOOL finished) {
                         [self.maskView removeFromSuperview];
                         [self removeFromSuperview];
                         if (completion) completion();
                     }];
}

- (void)dismissAnimationScaleIn:(dispatch_block_t)completion
{
    [UIView animateWithDuration:0.2 animations:^{
        self.maskView.alpha = 0;
        self.alpha = 0;
    }];
    [UIView animateWithDuration:0.4
                          delay:0
         usingSpringWithDamping:0.9
          initialSpringVelocity:1
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.transform = CGAffineTransformMakeScale(1.2, 1.2);
                     } completion:^(BOOL finished) {
                         [self.maskView removeFromSuperview];
                         [self removeFromSuperview];
                         if (completion) completion();
                     }];
}

@end

