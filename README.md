# XLPopup
Customizable popup for iOS.

XLPopup is now available.

# Usage

### Custom view from XLPopupView

**Override init Method**

```objective-c
CustomPopupView.m

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
```

**Implementation protocol**

```objective-c
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
```

# Preview

![img](https://github.com/weirdyu/XLPopup/blob/master/Preview.gif)

# TODO

Custom Animation Example