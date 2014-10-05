//
//  UIImage+Expand.h
//  MyDemo
//
//  Created by Kira on 11/7/12.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (Expand)
+ (UIImage *)imageWithView:(UIView *)view;          //从UIview生成UIImage
+ (UIImage *)imageWithLayer:(CALayer *)layer;

- (UIImage *)imageAtRect:(CGRect)rect;              //图片裁剪
- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize;  //按原始比例最小尺寸缩放
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;         //按原始比例最大尺寸缩放
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;                       //非原始比例缩放
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;                        //按PI旋转
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;                        //按角度旋转

@end