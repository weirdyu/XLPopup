//
//  PopupStore.h
//  XLPopupDemo
//
//  Created by weirdyu on 2019/7/24.
//  Copyright © 2019 weirdyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLPopup.h"

typedef NS_ENUM(NSInteger, PopupType) {
    PopupTypeView,
    PopupTypeViewController
};

@interface PopupStyle : NSObject

@property (nonatomic, assign) PopupType popupType;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) XLPopupShowType showType;
@property (nonatomic, assign) XLPopupMaskType maskType;

+ (instancetype)styleWithTitle:(NSString *)title
                     popupType:(PopupType)popupType
                      showType:(XLPopupShowType)showType
                      maskType:(XLPopupMaskType)maskType;

@end

@interface PopupStore : NSObject

+ (NSArray *)popupDataSource;

@end
