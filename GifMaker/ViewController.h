//
//  ViewController.h
//  GifMaker
//
//  Created by HalloWorld on 14-9-25.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GifPlayerCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *gifImgView;

@end


@interface ViewController : HWViewController <UICollectionViewDataSource, UICollectionViewDelegate>
{
    IBOutlet UICollectionView *gifCollectView;
}

@end

