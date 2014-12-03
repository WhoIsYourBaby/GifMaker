//
//  PreviewViewController.m
//  GifMaker
//
//  Created by HalloWorld on 14-10-17.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "PreviewViewController.h"
#import "GifManager.h"
#import "SettingBundle.h"
#import "AnimatedGIFImageSerialization.h"

@interface PreviewViewController ()

@end

@implementation PreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"view_bkg"]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(btnSaveTap:)];
    NSArray *arr = [[GifManager shareInterface] imageArrayInTemp];
    UIImage *img = [UIImage animatedImageWithImages:arr duration:arr.count * [SettingBundle globalSetting].timeInterval];
    [previewImgView setImage:img];
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

- (void)btnSaveTap:(id)sender
{
    NSString *fp = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString *name = [NSString stringWithFormat:@"%d.gif", (int)time];
    fp = [fp stringByAppendingPathComponent:name];
    
    NSArray *imgArr = [[GifManager shareInterface] imageArrayInTemp];
    NSTimeInterval duration = [[SettingBundle globalSetting] timeInterval] * imgArr.count;
    UIImage *gifImage = [UIImage animatedImageWithImages:imgArr duration:duration];
    NSError *err = nil;
    NSData *gifData = [AnimatedGIFImageSerialization animatedGIFDataWithImage:gifImage duration:duration loopCount:0 error:&err];
    [gifData writeToFile:fp atomically:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
