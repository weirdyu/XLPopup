//
//  XLPresentationController.m
//  XLPopupDemo
//
//  Created by weirdyu on 2019/7/25.
//  Copyright © 2019 weirdyu. All rights reserved.
//

#import "XLPresentationController.h"

@interface XLPresentationController () <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) XLPresentationPostion presentationPosition;
@property (nonatomic, assign) XLPopupShowType showType;
@property (nonatomic, assign) XLPopupMaskType maskType;
@property (nonatomic, strong) UIVisualEffectView *maskView;
@property (nonatomic, copy) void(^maskViewTapBlock)(UIViewController *presentedViewController);
@property (nonatomic, copy) CGPoint(^finalCenterBlock)(void);

@end

@implementation XLPresentationController

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController
                       presentingViewController:(UIViewController *)presentingViewController
                                       postion:(XLPresentationPostion)position
                                       showType:(XLPopupShowType)showType
                                       maskType:(XLPopupMaskType)maskType
{
    self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
    if (self) {
        self.presentationPosition = position;
        self.showType = showType;
        self.maskType = maskType;
        presentedViewController.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

- (void)setupMaskView
{
    if (_maskType == XLPopupMaskTypeNone) {
        return;
    }else if (_maskType == XLPopupMaskTypeClear) {
        _maskView = [[UIVisualEffectView alloc] initWithFrame:self.containerView.bounds];
        _maskView.backgroundColor = [UIColor clearColor];
    }else if (_maskType == XLPopupMaskTypeNormal) {
        _maskView = [[UIVisualEffectView alloc] initWithFrame:self.containerView.bounds];
        _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    }else if (_maskType == XLPopupMaskTypeLightBlur) {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _maskView = [[UIVisualEffectView alloc] initWithEffect:blur];
        _maskView.frame = self.containerView.bounds;
    }else {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _maskView = [[UIVisualEffectView alloc] initWithEffect:blur];
        _maskView.frame = self.containerView.bounds;
    }
    _maskView.alpha = 0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onMaskViewTapAction:)];
    [_maskView addGestureRecognizer:tap];
    [self.containerView addSubview:_maskView];
}

#pragma mark - Event Response

- (void)onMaskViewTapAction:(id)sender
{
    if (self.maskViewTapBlock) self.maskViewTapBlock(self.presentedViewController);
}

#pragma mark - Layout

- (void)containerViewWillLayoutSubviews
{
    [super containerViewWillLayoutSubviews];
    self.presentedView.frame = self.frameOfPresentedViewInContainerView;
}

- (CGSize)sizeForChildContentContainer:(id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize
{
    if (container == self.presentedViewController) {
        return ((UIViewController*)container).preferredContentSize;
    }else {
        return [super sizeForChildContentContainer:container withParentContainerSize:parentSize];
    }
}

//  最终view展示位置
- (CGRect)frameOfPresentedViewInContainerView
{
    CGRect containerViewBounds = self.containerView.bounds;
    CGSize presentedViewContentSize = [self sizeForChildContentContainer:self.presentedViewController withParentContainerSize:containerViewBounds.size];
    
    CGRect presentedViewControllerFrame;
    presentedViewControllerFrame.size = presentedViewContentSize;
    switch (self.presentationPosition) {
        case XLPresentationPostionTop:
            presentedViewControllerFrame.origin = CGPointMake((containerViewBounds.size.width-presentedViewContentSize.width)/2, 0);
            break;
        case XLPresentationPostionBottom:
            presentedViewControllerFrame.origin = CGPointMake ((containerViewBounds.size.width-presentedViewContentSize.width)/2, CGRectGetMaxY(containerViewBounds) - presentedViewContentSize.height);
            break;
        case XLPresentationPostionCenter:
            presentedViewControllerFrame.origin = CGPointMake((containerViewBounds.size.width-presentedViewContentSize.width)/2, (containerViewBounds.size.height-presentedViewContentSize.height)/2);
            break;
        case XLPresentationPostionCustom:
            if (self.finalCenterBlock) {
                CGPoint center = self.finalCenterBlock();
                CGPoint origin = CGPointMake(center.x-presentedViewContentSize.width/2, center.y-presentedViewContentSize.height/2);
                presentedViewControllerFrame.origin = origin;
            }
            break;
        default:
            break;
    }
    return presentedViewControllerFrame;
}

#pragma mark - Override Method

- (void)presentationTransitionWillBegin
{
    [self setupMaskView];
    
    id<UIViewControllerTransitionCoordinator> transitionCoordinator = self.presentingViewController.transitionCoordinator;
    
    self.maskView.alpha = 0;
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.maskView.alpha = 1;
    } completion:NULL];
}

- (void)dismissalTransitionWillBegin
{
    id<UIViewControllerTransitionCoordinator> transitionCoordinator = self.presentingViewController.transitionCoordinator;
    
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.maskView.alpha = 0;
    } completion:NULL];
}

#pragma mark UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return [transitionContext isAnimated] ? 0.5 : 0;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
//    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = transitionContext.containerView;
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    [containerView addSubview:toView];
    
    NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
    BOOL isPresenting = (fromViewController == self.presentingViewController);
    
    if (isPresenting) {
        switch (self.showType) {
            case XLPopupShowTypeFromTop:
                [self showAnimateTransitionFromTop:transitionContext toView:toView transitionDuration:transitionDuration];
                break;
            case XLPopupShowTypeFromBottom:
                [self showAnimateTransitionFromBottom:transitionContext toView:toView transitionDuration:transitionDuration];
                break;
            case XLPopupShowTypeScaleOut:
                [self showAnimateTransitionScaleOut:transitionContext toView:toView transitionDuration:transitionDuration];
                break;
            case XLPopupShowTypeScaleIn:
                [self showAnimateTransitionScaleIn:transitionContext toView:toView transitionDuration:transitionDuration];
                break;
            default:
                break;
        }
    }else {
        switch (self.showType) {
            case XLPopupShowTypeFromTop:
                [self dismissAnimateTransitionFromTop:transitionContext fromView:fromView transitionDuration:transitionDuration];
                break;
            case XLPopupShowTypeFromBottom:
                [self dismissAnimateTransitionFromBottom:transitionContext fromView:fromView transitionDuration:transitionDuration];
                break;
            case XLPopupShowTypeScaleOut:
                [self dismissAnimateTransitionScaleOut:transitionContext fromView:fromView transitionDuration:transitionDuration];
                break;
            case XLPopupShowTypeScaleIn:
                [self dismissAnimateTransitionScaleIn:transitionContext fromView:fromView transitionDuration:transitionDuration];
                break;
            default:
                break;
        }
    }
}

#pragma mark - show Animation

- (void)showAnimateTransitionFromTop:(id<UIViewControllerContextTransitioning>)transitionContext
                                              toView:(UIView *)toView
                                  transitionDuration:(NSTimeInterval)transitionDuration
{
    toView.transform = CGAffineTransformMakeTranslation(0, - CGRectGetMaxY(toView.frame));
    
    [UIView animateWithDuration:transitionDuration
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         toView.transform = CGAffineTransformIdentity;
                     } completion:^(BOOL finished) {
                         BOOL wasCancelled = [transitionContext transitionWasCancelled];
                         [transitionContext completeTransition:!wasCancelled];
                     }];
}

- (void)showAnimateTransitionFromBottom:(id<UIViewControllerContextTransitioning>)transitionContext
                                 toView:(UIView *)toView
                     transitionDuration:(NSTimeInterval)transitionDuration
{
    toView.transform = CGAffineTransformMakeTranslation(0, self.containerView.frame.size.height - CGRectGetMinY(toView.frame));
    
    [UIView animateWithDuration:transitionDuration
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         toView.transform = CGAffineTransformIdentity;
                     } completion:^(BOOL finished) {
                         BOOL wasCancelled = [transitionContext transitionWasCancelled];
                         [transitionContext completeTransition:!wasCancelled];
                     }];
}


- (void)showAnimateTransitionScaleOut:(id<UIViewControllerContextTransitioning>)transitionContext
                               toView:(UIView *)toView
                   transitionDuration:(NSTimeInterval)transitionDuration
{
    toView.alpha = 0;
    toView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [UIView animateWithDuration:transitionDuration
                          delay:0
         usingSpringWithDamping:0.6
          initialSpringVelocity:0.9
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         toView.alpha = 1;
                         toView.transform = CGAffineTransformIdentity;
                     } completion:^(BOOL finished) {
                         BOOL wasCancelled = [transitionContext transitionWasCancelled];
                         [transitionContext completeTransition:!wasCancelled];
                     }];
}

- (void)showAnimateTransitionScaleIn:(id<UIViewControllerContextTransitioning>)transitionContext
                              toView:(UIView *)toView
                  transitionDuration:(NSTimeInterval)transitionDuration
{
    toView.alpha = 0;
    toView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    [UIView animateWithDuration:transitionDuration
                          delay:0
         usingSpringWithDamping:0.6
          initialSpringVelocity:0.9
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         toView.alpha = 1;
                         toView.transform = CGAffineTransformIdentity;
                     } completion:^(BOOL finished) {
                         BOOL wasCancelled = [transitionContext transitionWasCancelled];
                         [transitionContext completeTransition:!wasCancelled];
                     }];
}

#pragma mark - Dismiss Animation

- (void)dismissAnimateTransitionFromTop:(id<UIViewControllerContextTransitioning>)transitionContext
                               fromView:(UIView *)fromView
                     transitionDuration:(NSTimeInterval)transitionDuration
{
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, - CGRectGetMaxY(fromView.frame));
    
    [UIView animateWithDuration:transitionDuration
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         fromView.transform = transform;
                     } completion:^(BOOL finished) {
                         BOOL wasCancelled = [transitionContext transitionWasCancelled];
                         [transitionContext completeTransition:!wasCancelled];
                     }];
}

- (void)dismissAnimateTransitionFromBottom:(id<UIViewControllerContextTransitioning>)transitionContext
                                  fromView:(UIView *)fromView
                        transitionDuration:(NSTimeInterval)transitionDuration
{
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, self.containerView.frame.size.height - CGRectGetMinY(fromView.frame));
    
    [UIView animateWithDuration:transitionDuration
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         fromView.transform = transform;
                     } completion:^(BOOL finished) {
                         BOOL wasCancelled = [transitionContext transitionWasCancelled];
                         [transitionContext completeTransition:!wasCancelled];
                     }];
}

- (void)dismissAnimateTransitionScaleOut:(id<UIViewControllerContextTransitioning>)transitionContext
                                          fromView:(UIView *)fromView
                                transitionDuration:(NSTimeInterval)transitionDuration
{
    [UIView animateWithDuration:transitionDuration
                          delay:0
         usingSpringWithDamping:0.9
          initialSpringVelocity:1
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         fromView.alpha = 0;
                         fromView.transform = CGAffineTransformMakeScale(0.8, 0.8);
                     } completion:^(BOOL finished) {
                         BOOL wasCancelled = [transitionContext transitionWasCancelled];
                         [transitionContext completeTransition:!wasCancelled];
                     }];
}

- (void)dismissAnimateTransitionScaleIn:(id<UIViewControllerContextTransitioning>)transitionContext
                                          fromView:(UIView *)fromView
                                transitionDuration:(NSTimeInterval)transitionDuration
{
    [UIView animateWithDuration:transitionDuration
                          delay:0
         usingSpringWithDamping:0.9
          initialSpringVelocity:1
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         fromView.alpha = 0;
                         fromView.transform = CGAffineTransformMakeScale(1.2, 1.2);
                     } completion:^(BOOL finished) {
                         BOOL wasCancelled = [transitionContext transitionWasCancelled];
                         [transitionContext completeTransition:!wasCancelled];
                     }];
}

#pragma mark - UIViewControllerTransitioningDelegate

- (UIPresentationController*)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    NSAssert(self.presentedViewController == presented, @"You didn't initialize %@ with the correct presentedViewController.  Expected %@, got %@.",
             self, presented, self.presentedViewController);
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self;
}

#pragma mark - Block

- (void)setupCustomFinalCenterBlock:(CGPoint (^)(void))block
{
    self.finalCenterBlock = block;
}

- (void)setupMaskViewTapBlock:(void (^)(UIViewController *))block
{
    self.maskViewTapBlock = block;
}

@end

