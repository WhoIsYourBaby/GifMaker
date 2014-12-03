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
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"save_to", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Album", nil), NSLocalizedString(@"Local", nil), nil];
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //album
        [[GifManager shareInterface] makeGifInAlbum:previewImgView.image];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    if (buttonIndex == 1) {
        //local
        [[GifManager shareInterface] makeGifInLocal:previewImgView.image];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


@end
