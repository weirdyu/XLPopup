//
//  XLPopupDefinition.h
//  XLPopupDemo
//
//  Created by weirdyu on 2019/7/24.
//  Copyright © 2019 weirdyu. All rights reserved.
//

#ifndef XLPopupDefinition_h
#define XLPopupDefinition_h

typedef NS_ENUM(NSUInteger, XLPopupShowType) {
    XLPopupShowTypeFromBottom,
    XLPopupShowTypeFromTop,
    XLPopupShowTypeScaleIn,
    XLPopupShowTypeScaleOut,
    XLPopupShowTypeCustom
};

typedef NS_ENUM(NSUInteger, XLPopupMaskType) {
    XLPopupMaskTypeNone,
    XLPopupMaskTypeClear,
    XLPopupMaskTypeNormal,
    XLPopupMaskTypeLightBlur,
    XLPopupMaskTypeDarkBlur
};

#endif /* XLPopupDefinition_h */
