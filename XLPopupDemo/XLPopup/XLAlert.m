//
//  XLAlert.m
//  XLPopupDemo
//
//  Created by weirdyu on 2019/7/24.
//  Copyright © 2019 weirdyu. All rights reserved.
//

#import "XLAlert.h"
#import <Masonry.h>
#import <YYCategories.h>

@interface XLAlert () <UITextViewDelegate, XLPopupViewDelegate>

@property(nonatomic) BOOL hasCancelButton;
@property(nonatomic) BOOL hasOtherButtons;
@property(nonatomic, copy) NSMutableArray<UIButton *> *buttons;
@property(nonatomic, copy) XLAlertCompletionBlock tapBlock;
@end

@implementation XLAlert

+ (instancetype)showAlertInView:(UIView *)view
                      withTitle:(id)title
                        message:(id)message
              cancelButtonTitle:(NSString *)cancelButtonTitle
              otherButtonTitles:(NSArray *)otherButtonTitles
                       tapBlock:(XLAlertCompletionBlock)tapBlock
{
    XLAlert *alert = [[XLAlert alloc] initWithView:view
                                             title:title
                                           message:message
                                 cancelButtonTitle:cancelButtonTitle
                                 otherButtonTitles:otherButtonTitles
                                          tapBlock:tapBlock];
    [alert show];
    return alert;
}

- (instancetype)initWithView:(UIView *)view
                       title:(id)title
                     message:(id)message
           cancelButtonTitle:(NSString *)cancelButtonTitle
           otherButtonTitles:(NSArray *)otherButtonTitles
                    tapBlock:(XLAlertCompletionBlock)tapBlock
{
    self = [super initWithSuperView:view showType:XLPopupShowTypeScaleOut maskType:XLPopupMaskTypeNormal];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.delegate = self;
        _hasCancelButton = cancelButtonTitle != nil;
        _hasOtherButtons = otherButtonTitles.count > 0;
        _buttons = [NSMutableArray array];
        _tapBlock = tapBlock;
        
        UILabel *titleLabel = [UILabel new];
        NSAttributedString *titleAttributedString;
        if ([title isKindOfClass:[NSString class]]) {
            titleAttributedString = [[NSAttributedString alloc] initWithString:title];
        }else if ([title isKindOfClass:[NSAttributedString class]]) {
            titleAttributedString = title;
        }
        titleLabel.attributedText = titleAttributedString;
        titleLabel.font = [UIFont boldSystemFontOfSize:15];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = UIColorHex(26263a);
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(28);
            make.left.equalTo(self).offset(20);
            make.right.equalTo(self).offset(-20);
        }];
        
        UITextView *messageView = [UITextView new];
        messageView.scrollEnabled = NO;
        messageView.delegate = self;
        NSAttributedString *messageAttributedString;
        if ([message isKindOfClass:[NSString class]]) {
            messageAttributedString = [[NSAttributedString alloc] initWithString:message];
        }else if ([message isKindOfClass:[NSAttributedString class]]) {
            messageAttributedString = message;
        }
        messageView.attributedText = messageAttributedString;
        messageView.font = [UIFont systemFontOfSize:14];
        messageView.textAlignment = NSTextAlignmentCenter;
        messageView.textColor = UIColorHex(4C4C40);
        messageView.editable = NO;
        [self addSubview:messageView];
        _messageView = messageView;
        [messageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).offset(titleAttributedString.length > 0 ? 20 : 0);
            make.left.right.equalTo(titleLabel);
        }];
        
        UIView *separator = [UIView new];
        separator.backgroundColor = UIColorHex(dddde0);
        [self addSubview:separator];
        [separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(messageView.mas_bottom).offset(28);
            make.left.right.equalTo(self);
            make.height.equalTo(@1);
        }];
        
        [self setupButtonsWithSeparator:separator
                      cancelButtonTitle:cancelButtonTitle
                      otherButtonTitles:otherButtonTitles];
    }
    return self;
}

- (void)setupButtonsWithSeparator:(UIView *)separator
                cancelButtonTitle:(NSString *)cancelButtonTitle
                otherButtonTitles:(NSArray *)otherButtonTitles
{
    if (cancelButtonTitle) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:cancelButtonTitle attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:UIColorHex(999999)}];
        [button setAttributedTitle:attributedTitle forState:UIControlStateNormal];
        [_buttons addObject:button];
    }
    
    for (NSUInteger i = 0; i < otherButtonTitles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:otherButtonTitles[i] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:UIColorHex(BB7E6C)}];
        [button setAttributedTitle:attributedTitle forState:UIControlStateNormal];
        [_buttons addObject:button];
    }
    
    UIButton *previousButton = nil;
    for (NSUInteger i = 0; i < _buttons.count; i++) {
        UIButton *button = _buttons[i];
        [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:1 alpha:0.2]] forState:UIControlStateHighlighted];
        __weak typeof(self)weakSelf = self;
        [button addBlockForControlEvents:UIControlEventTouchUpInside block:^(id _Nonnull sender) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (strongSelf.tapBlock) strongSelf.tapBlock(strongSelf, i);
            [strongSelf dismiss];
        }];
        [self addSubview:button];
        if (_buttons.count <= 2) { // 横向排布按钮
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(previousButton ? previousButton.mas_right : self);
                make.top.equalTo(separator.mas_bottom);
                make.bottom.equalTo(self);
                make.width.equalTo(self).dividedBy(self.buttons.count);
                make.height.equalTo(@42);
            }];
            previousButton = button;
            if (i == _buttons.count - 1) continue;
            UIView *verticalSeparator = [UIView new];
            verticalSeparator.backgroundColor = UIColorHex(dddde0);
            [self addSubview:verticalSeparator];
            [verticalSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(button);
                make.right.equalTo(button).offset(0.5);
                make.width.equalTo(@1);
            }];
        } else { // 纵向排布按钮
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(previousButton ? previousButton.mas_bottom : separator.mas_bottom);
                make.left.right.equalTo(self);
                make.height.equalTo(@42);
            }];
            previousButton = button;
            if (i == _buttons.count - 1) {
                [button mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(self);
                }];
                continue;
            }
            UIView *horizontalSeparator = [UIView new];
            horizontalSeparator.backgroundColor = UIColorHex(dddde0);
            [self addSubview:horizontalSeparator];
            [horizontalSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(button);
                make.bottom.equalTo(button).offset(0.5);
                make.height.equalTo(@1);
            }];
        }
    }
}

#pragma mark - Public

- (NSInteger)cancelButtonIndex
{
    return self.hasCancelButton ? 0 : NSNotFound;
}

- (NSInteger)firstOtherButtonIndex
{
    return self.hasOtherButtons ? (self.hasCancelButton ? 1 : 0) : NSNotFound;
}

#pragma mark - XLPopupViewDelegate

- (void)popupViewLayoutFinalPostion
{
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.superview);
        make.width.lessThanOrEqualTo(self.superview).multipliedBy(0.8);
        make.width.greaterThanOrEqualTo(self.superview).multipliedBy(0.7);
        make.height.lessThanOrEqualTo(self.superview).multipliedBy(0.9);
    }];
}

@end

