/*
 作者: 羊羊羊
 描述: 
 时间:
 文件名: PaintViewModel.m
 */

#import "PaintViewModel.h"

@implementation PaintViewModel

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

+ (id)viewModelWithColor:(UIColor *)color Path:(UIBezierPath *)path Width:(CGFloat)width
{
    PaintViewModel *model = [[PaintViewModel alloc] init];
    model.color = color;
    model.path = path;
    model.width = width;
    
    return model;
}
@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
