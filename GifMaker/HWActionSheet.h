//
//  HWActionSheet.h
//  GifMaker
//
//  Created by HalloWorld on 14-10-28.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HWActionSheet : UIActionSheet

/*因为是通过给ActionSheet 加 Button来改变ActionSheet, 所以大小要与actionsheet的button数有关
 
 count*height = 84, 134, 184, 234, 284, 334, 384, 434, 484
 
 *如果要用self.view = anotherview.  那么another的大小也必须与view的大小一样
 
 */
- (instancetype)initWithHeight:(CGFloat)height;

@end
