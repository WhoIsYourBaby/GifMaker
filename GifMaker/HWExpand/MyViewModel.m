/*
 作者: 羊羊羊
 描述: 
 时间:
 文件名: MyViewModel.m
 */

#import "MyViewModel.h"

@implementation MyViewModel

+ (id)viewModelWithColor:(UIColor *)color Path:(UIBezierPath *)path Width:(CGFloat)width
{
    MyViewModel *myViewModel = [[MyViewModel alloc] init];
   
    myViewModel.color = color;
    myViewModel.path = path;
    myViewModel.width = width;
    
    return myViewModel;
}
@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
