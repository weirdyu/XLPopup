//
//  CustomPopupView.m
//  XLPopupDemo
//
//  Created by weirdyu on 2019/7/24.
//  Copyright © 2019 weirdyu. All rights reserved.
//

#import "CustomPopupView.h"
#import <Masonry.h>

@interface CustomPopupView () <XLPopupViewDelegate>

@end

@implementation CustomPopupView

+ (instancetype)showPopupViewWithShowType:(XLPopupShowType)showType maskType:(XLPopupMaskType)maskType
{
    CustomPopupView *popupView = [[CustomPopupView alloc] initWithSuperView:nil showType:showType maskType:maskType];
    [popupView show];
    return popupView;
}

#pragma mark - Override Method

- (instancetype)initWithSuperView:(UIView *)superView showType:(XLPopupShowType)showType maskType:(XLPopupMaskType)maskType
{
    self = [super initWithSuperView:superView showType:showType maskType:maskType];
    if (self) {
        self.delegate = self;
        BOOL isMaskLight;
        if (maskType == XLPopupMaskTypeNormal || maskType == XLPopupMaskTypeDarkBlur) {
            isMaskLight = NO;
        }else {
            isMaskLight = YES;
        }
        self.backgroundColor = isMaskLight? [UIColor grayColor]:[UIColor whiteColor];
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 10;
        
        UILabel *label = [UILabel new];
        label.text = @"customView";
        label.textColor = isMaskLight? [UIColor whiteColor]:[UIColor grayColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.equalTo(self);
        }];
    }
    return self;
}

#pragma mark - XLPopupViewDelegate

- (void)popupViewLayoutFinalPostion
{
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.superview);
        make.height.equalTo(@(200));
        make.width.equalTo(self.superview).multipliedBy(0.8);
    }];
}

- (BOOL)popupViewDismissWhenMaskViewDidTap
{
    return YES;
}

@end
