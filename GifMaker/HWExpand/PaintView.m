//
//  PaintView.m
//  画图
//
//  Created by mj on 14-9-4.
//  Copyright (c) 2014年 Mr.Li. All rights reserved.
//

#import "PaintView.h"
#import "PaintViewModel.h"

@interface PaintView ()

@property (assign, nonatomic) CGMutablePathRef path;
@property (strong, nonatomic) NSMutableArray *pathArray;
@property (assign, nonatomic) BOOL isHavePath;

@end

@implementation PaintView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _lineWidth = 3.f;
        _lineColor = [UIColor redColor];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
}

- (void)reverse
{
    if ([_pathArray count] > 0) {
        [_pathArray removeLastObject];
        [self setNeedsDisplay];
    }
}

- (BOOL)isPaintEmpty
{
    return ![_pathArray count];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawView:context];
}
- (void)drawView:(CGContextRef)context
{
    for (PaintViewModel *PaintViewModel in _pathArray) {
        CGContextAddPath(context, PaintViewModel.path.CGPath);
        [PaintViewModel.color set];
        CGContextSetLineWidth(context, PaintViewModel.width);
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextDrawPath(context, kCGPathStroke);
    }
    if (_isHavePath) {
        CGContextAddPath(context, _path);
        [_lineColor set];
        CGContextSetLineWidth(context, _lineWidth);
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextDrawPath(context, kCGPathStroke);
    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location =[touch locationInView:self];
    _path = CGPathCreateMutable();
    _isHavePath = YES;
    CGPathMoveToPoint(_path, NULL, location.x, location.y);
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    CGPathAddLineToPoint(_path, NULL, location.x, location.y);
    [self setNeedsDisplay];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_pathArray == nil) {
        _pathArray = [NSMutableArray array];
    }
 
    UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:_path];
    PaintViewModel *model = [PaintViewModel viewModelWithColor:_lineColor Path:path Width:_lineWidth];
    [_pathArray addObject:model];
    
    CGPathRelease(_path);
    _isHavePath = NO;
}

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
