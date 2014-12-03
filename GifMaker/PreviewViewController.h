//
//  PreviewViewController.h
//  GifMaker
//
//  Created by HalloWorld on 14-10-17.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASValueTrackingSlider.h"

@interface PreviewViewController : HWViewController <UIActionSheetDelegate>
{
    IBOutlet UIImageView *previewImgView;
    IBOutlet ASValueTrackingSlider *speedSlider;
}



@end
