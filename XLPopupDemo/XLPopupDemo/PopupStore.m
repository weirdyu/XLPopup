//
//  PopupStore.m
//  XLPopupDemo
//
//  Created by weirdyu on 2019/7/24.
//  Copyright © 2019 weirdyu. All rights reserved.
//

#import "PopupStore.h"

@implementation PopupStyle

+ (instancetype)styleWithTitle:(NSString *)title popupType:(PopupType)popupType showType:(XLPopupShowType)showType maskType:(XLPopupMaskType)maskType
{
    PopupStyle *style = [PopupStyle new];
    style.popupType = popupType;
    style.title = title;
    style.showType = showType;
    style.maskType = maskType;
    return style;
}

@end


@implementation PopupStore

+ (NSArray *)popupDataSource
{
    return @[[PopupStyle styleWithTitle:@"ShowTypeFromTop + MaskTypeNormal" popupType:PopupTypeView showType:XLPopupShowTypeFromTop maskType:XLPopupMaskTypeNormal],
             [PopupStyle styleWithTitle:@"ShowTypeFromBottom + MaskTypeClear" popupType:PopupTypeView showType:XLPopupShowTypeFromBottom maskType:XLPopupMaskTypeClear],
             [PopupStyle styleWithTitle:@"ShowTypeScaleOut + MaskTypeDarkBlur" popupType:PopupTypeView showType:XLPopupShowTypeScaleOut maskType:XLPopupMaskTypeDarkBlur],
             [PopupStyle styleWithTitle:@"ShowTypeScaleIn + MaskTypeLightBlur" popupType:PopupTypeView showType:XLPopupShowTypeScaleIn maskType:XLPopupMaskTypeLightBlur],
             [PopupStyle styleWithTitle:@"Presentation" popupType:PopupTypeViewController showType:XLPopupShowTypeScaleOut maskType:XLPopupMaskTypeNormal]];
}

@end
