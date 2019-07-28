//
//  XLAlert.h
//  XLPopupDemo
//
//  Created by weirdyu on 2019/7/24.
//  Copyright © 2019 weirdyu. All rights reserved.
//

#import "XLPopupView.h"

@class XLAlert;
typedef void(^XLAlertCompletionBlock)(XLAlert *alert, NSInteger buttonIndex);

@interface XLAlert : XLPopupView

@property(nonatomic, strong) UITextView *messageView;   //  message视图
@property(nonatomic, readonly) NSInteger cancelButtonIndex; // 取消按钮索引值（若无取消按钮则为 NSNotFound）
@property(nonatomic, readonly) NSInteger firstOtherButtonIndex; // 首个其他按钮索引值（若无其他按钮则为 NSNotFound）

/**
 弹出 Alert
 
 @param view 容器视图
 @param title 标题（NSString或者NSAttributedString）
 @param message 消息（NSString或者NSAttributedString）
 @param cancelButtonTitle 取消按钮标题
 @param otherButtonTitles 其他按钮标题
 @param tapBlock 点击回调
 @return Alert 实例
 */
+ (instancetype)showAlertInView:(UIView *)view
                              withTitle:(id)title
                                message:(id)message
                      cancelButtonTitle:(NSString *)cancelButtonTitle
                      otherButtonTitles:(NSArray *)otherButtonTitles
                               tapBlock:(XLAlertCompletionBlock)tapBlock;


- (instancetype)initWithView:(UIView *)view
                       title:(id)title
                     message:(id)message
           cancelButtonTitle:(NSString *)cancelButtonTitle
           otherButtonTitles:(NSArray *)otherButtonTitles
                    tapBlock:(XLAlertCompletionBlock)tapBlock;

@end
