//
//  DrawerToolView.m
//  GifMaker
//
//  Created by HalloWorld on 14-10-17.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "DrawerToolView.h"

#pragma mark - DrawerToolView
@implementation DrawerToolView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //init code
        [self customInit];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self customInit];
}

- (void)customInit
{
    itemCount = 0;
    self.backgroundColor = [UIColor clearColor];
    self.pagingEnabled = NO;
    itemsArray = [NSMutableArray arrayWithCapacity:10];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



- (void)setSelectIndex:(NSUInteger)selectIndex
{
    _selectIndex = selectIndex;
    [itemsArray[_selectIndex] setSelected:YES];
}

- (void)addItem:(ToolItemView *)aItem
{
    aItem.frame = CGRectOffset(aItem.frame, itemCount * aItem.frame.size.width, (self.frame.size.height - aItem.frame.size.height) / 2);
    [self addSubview:aItem];
    [itemsArray addObject:aItem];
    aItem.delegate = self;
    itemCount ++;
    int totalWidth = aItem.frame.size.width * itemCount;
    if (totalWidth > self.contentSize.width) {
        self.contentSize = CGSizeMake(totalWidth, self.frame.size.height);
    }
}

- (void)toolItemTaped:(ToolItemView *)aItem
{
    if (![aItem isSelected]) {
        for (int i = 0; i < itemsArray.count; i ++) {
            ToolItemView *it = itemsArray[i];
            if ([it isSelected]) {
                [it setSelected:NO];
            }
        }
        [aItem setSelected:YES];
        _selectIndex = [itemsArray indexOfObject:aItem];
    }
    if (_callbackBlock) {
        _callbackBlock([aItem SrcObjc]);
    }
}


@end

#pragma mark - ToolItemView
@implementation ToolItemView

+ (instancetype)toolItemViewWithObjc:(id)objc
{
    ToolItemView *btn = [[ToolItemView alloc] initWithObjc:objc];
    return btn;
}


- (instancetype)initWithObjc:(id)objc
{
    self = [super initWithFrame:k_rect_button];
    if (self) {
        SrcObjc = objc;
        self.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)setSelected:(BOOL)bSlctd
{
    selected = bSlctd;
    if (selected) {
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 3;
    } else {
        self.layer.borderWidth = 0;
    }
}

- (BOOL)isSelected
{
    return selected;
}

- (void)singleTap:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(toolItemTaped:)]) {
        [_delegate toolItemTaped:self];
    }
}

- (id)SrcObjc
{
    return SrcObjc;
}

- (void)drawRect:(CGRect)rect
{
    if ([SrcObjc isKindOfClass:[NSNumber class]]) {
        [self drawLineWidth:rect];
    }
    if ([SrcObjc isKindOfClass:[UIColor class]]) {
        [self drawColor:rect];
    }
}


- (void)drawLineWidth:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor lightGrayColor] setFill];
    CGContextFillEllipseInRect(ctx, CGRectInset(rect, 5, 5));
    
    [[UIColor darkGrayColor] setFill];
    int width = [(NSNumber *)SrcObjc intValue];
    float delta = (rect.size.width - width) / 2.0;
    CGContextFillEllipseInRect(ctx, CGRectInset(rect, delta, delta));
}


- (void)drawColor:(CGRect)rect
{
    UIColor *clr = SrcObjc;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [clr setFill];
    CGContextFillRect(ctx, CGRectInset(rect, 5, 5));
}


@end