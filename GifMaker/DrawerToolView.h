//
//  DrawerToolView.h
//  GifMaker
//
//  Created by HalloWorld on 14-10-17.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>


#define k_rect_button CGRectMake(0, 0, 36, 36)

#pragma mark - DrawerToolView
@class ToolItemView;
@protocol ToolItemProtocol;
@interface DrawerToolView : UIScrollView <ToolItemProtocol>
{
    int itemCount;
}

- (void)addItems:(NSArray *)aArr;

- (void)addItem:(ToolItemView *)aItem;

@end

#pragma mark - ToolButton

@protocol ToolItemProtocol;
@interface ToolItemView : UIView
{
    __strong id SrcObjc;
}

@property (weak, nonatomic) id<ToolItemProtocol> delegate;

+ (instancetype)toolItemViewWithObjc:(id)objc;

- (instancetype)initWithObjc:(id)objc;

- (id)SrcObjc;

@end


#pragma mark - ToolItemProtocol
@protocol ToolItemProtocol <NSObject>

- (void)toolItemTaped:(ToolItemView *)aItem;

@end