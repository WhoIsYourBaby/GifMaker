//
//  DrawerToolView.h
//  GifMaker
//
//  Created by HalloWorld on 14-10-17.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>


#define k_rect_button CGRectMake(0, 0, 32, 32)

typedef void(^ToolViewItemSelect)(id objc);

#pragma mark - DrawerToolView
@class ToolItemView;
@protocol ToolItemProtocol;
@interface DrawerToolView : UIScrollView <ToolItemProtocol>
{
    int itemCount;
    NSMutableArray *itemsArray;
}

@property (copy, nonatomic) ToolViewItemSelect callbackBlock;

@property NSUInteger selectIndex;

- (void)addItem:(ToolItemView *)aItem;

@end

#pragma mark - ToolButton

@protocol ToolItemProtocol;
@interface ToolItemView : UIView
{
    __strong id SrcObjc;
    BOOL selected;
}

@property (weak, nonatomic) id<ToolItemProtocol> delegate;

+ (instancetype)toolItemViewWithObjc:(id)objc;

- (instancetype)initWithObjc:(id)objc;

- (id)SrcObjc;

- (void)setSelected:(BOOL)bSlctd;
- (BOOL)isSelected;

@end


#pragma mark - ToolItemProtocol
@protocol ToolItemProtocol <NSObject>

- (void)toolItemTaped:(ToolItemView *)aItem;

@end