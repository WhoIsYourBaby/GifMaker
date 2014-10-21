//
//  PreviewViewController.m
//  GifMaker
//
//  Created by HalloWorld on 14-10-17.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "PreviewViewController.h"
#import "GifManager.h"

@interface PreviewViewController ()

@end

@implementation PreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"view_bkg"]];
    [previewImgView setAnimationImages:self.imgArray];
    [previewImgView setAnimationDuration:1.0];
    [previewImgView startAnimating];
    
    [speedSlider setMaximumValue:3.f];
    speedSlider.popUpViewColor = [UIColor colorWithHue:0.55 saturation:0.8 brightness:0.9 alpha:0.7];
    speedSlider.popUpViewAnimatedColors = @[[UIColor orangeColor], [UIColor magentaColor], [UIColor redColor]];
    speedSlider.textColor = [UIColor colorWithHue:0.55 saturation:1.0 brightness:0.5 alpha:1];
}

- (NSArray *)imgArray
{
    if (_imgArray == nil) {
        return [[GifManager shareInterface] previewImageArray];
    } else {
        return _imgArray;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
