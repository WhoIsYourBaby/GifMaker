//
//  HWActionSheet.h
//  GifMaker
//
//  Created by HalloWorld on 14-10-28.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    HWActionSheetHeightA = 1,
    HWActionSheetHeightB,
    HWActionSheetHeightC,
    HWActionSheetHeightD,
    HWActionSheetHeightE,
    HWActionSheetHeightF
} HWActionSheetHeight;

@class SettingBundle;

typedef void(^HWActionSheetCallback)(SettingBundle *aSet);

@interface HWActionSheet : UIActionSheet

/*因为是通过给ActionSheet 加 Button来改变ActionSheet, 所以大小要与actionsheet的button数有关
 
 height = 52 + 44 * (hEnum - 1);  //52,96,140,184,228...
 
 *如果要用self.view = anotherview.  那么another的大小也必须与view的大小一样
 
 */
- (instancetype)initWithHeight:(HWActionSheetHeight)hEnum withSetting:(SettingBundle *)aSB;

@property (nonatomic, weak) SettingBundle *setBundle;

@property (copy, nonatomic) HWActionSheetCallback callback;

@end
