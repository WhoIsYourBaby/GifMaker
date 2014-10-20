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

- (void)customInit
{
    itemCount = 0;
    self.backgroundColor = [UIColor clearColor];
    self.pagingEnabled = NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)addItems:(NSArray *)aArr
{
    if (aArr == nil || [aArr count] == 0) {
        return ;
    }
    UIView *sv = aArr[0];
    int totalWidth = sv.frame.size.width * [aArr count];
    if (self.frame.size.width < totalWidth) {
        self.contentSize = CGSizeMake(totalWidth, self.frame.size.height);
    }
    for (int i = 0; i < [aArr count]; i ++) {
        UIView *vw = aArr[i];
        vw.frame = CGRectOffset(vw.frame, i * vw.frame.size.width, 0);
        [self addSubview:vw];
    }
}


- (void)addItem:(ToolItemView *)aItem
{
    aItem.frame = CGRectOffset(aItem.frame, itemCount * aItem.frame.size.width, (self.frame.size.height - aItem.frame.size.height) / 2);
    [self addSubview:aItem];
    itemCount ++;
    int totalWidth = aItem.frame.size.width * itemCount;
    if (totalWidth > self.contentSize.width) {
        self.contentSize = CGSizeMake(totalWidth, self.frame.size.height);
    }
}

- (void)toolItemTaped:(ToolItemView *)aItem
{
    NSLog(@"%s -> %@", __FUNCTION__, NSStringFromClass([[aItem SrcObjc] class]));
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