//
//  DrawerViewController.m
//  GifMaker
//
//  Created by HalloWorld on 14-10-17.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "DrawerViewController.h"
#import "GifManager.h"
#import "PaintView.h"
#import "UIViewController+ADFlipTransition.h"
#import "SettingBundle.h"

#define k_toolbar_height 30

@interface DrawerViewController ()
{
    IBOutlet UIImageView *imgView;
    IBOutlet PaintView *ptView;
    IBOutlet UIButton *btnDone;
    IBOutlet UIButton *btnGoback;
    IBOutlet UIButton *btnCancel;
    IBOutlet DrawerToolView *lineToolbar;
    IBOutlet DrawerToolView *colorToolbar;
}

@property (strong, nonatomic) UIImage *srcImage;
@property (strong, nonatomic) NSArray *srcNameArray;

@end

@implementation DrawerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"view_bkg"]];
    [self initColorToolbar];
    [self initLineWidthToolbar];
    ptView.lineColor = [UIColor redColor];
    ptView.lineWidth = 3.f;
    
    NSArray *imgArr = [[GifManager shareInterface] bigTempImageArrayWithNames:self.srcNameArray];
    self.srcImage = [UIImage animatedImageWithImages:imgArr duration:[SettingBundle globalSetting].timeInterval * self.srcNameArray.count];
    [imgView setImage:self.srcImage];
}

- (void)initLineWidthToolbar
{
    //初始化线宽toolbar
    NSArray *lines = @[[NSNumber numberWithInt:3],
                        [NSNumber numberWithInt:5],
                        [NSNumber numberWithInt:7],
                        [NSNumber numberWithInt:9],
                        [NSNumber numberWithInt:11],
                        [NSNumber numberWithInt:13],
                        [NSNumber numberWithInt:15],
                        [NSNumber numberWithInt:17],
                        [NSNumber numberWithInt:19],
                        [NSNumber numberWithInt:21],
                        [NSNumber numberWithInt:22],
                        [NSNumber numberWithInt:23]
                        ];
    for (NSNumber *lw in lines) {
        ToolItemView *item = [ToolItemView toolItemViewWithObjc:lw];
        [lineToolbar addItem:item];
    }
    
    __weak PaintView *pt = ptView;
    [lineToolbar setCallbackBlock:^(id objc) {
        __strong PaintView *bValue = pt;
        bValue.lineWidth = [objc floatValue];
    }];
}

- (void)initColorToolbar
{
    //初始化toolbar
    NSArray *colors = @[[UIColor redColor],
                        [UIColor greenColor],
                        [UIColor blueColor],
                        [UIColor cyanColor],
                        [UIColor yellowColor],
                        [UIColor magentaColor],
                        [UIColor orangeColor],
                        [UIColor purpleColor],
                        [UIColor brownColor],
                        [UIColor whiteColor],
                        [UIColor lightGrayColor],
                        [UIColor darkGrayColor],
                        [UIColor grayColor],
                        [UIColor blackColor]
                        ];
    for (UIColor *clr in colors) {
        ToolItemView *item = [ToolItemView toolItemViewWithObjc:clr];
        [colorToolbar addItem:item];
    }
    __weak PaintView *pt = ptView;
    [colorToolbar setCallbackBlock:^(id objc) {
        __strong PaintView *bValue = pt;
        bValue.lineColor = objc;
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setDoodleImgNames:(NSArray *)aNameArr
{
    self.srcNameArray = aNameArr;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - Actions

- (void)saveBackImage
{
    if (![ptView isPaintEmpty]) {
        CGRect rect = imgView.bounds;
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        NSArray *imgs = [self.srcImage images];
        for (int i = 0; i < imgs.count; i ++) {
//            CGContextClearRect(ctx, rect);
            UIImage *aImg = imgs[i];
            [aImg drawAtPoint:CGPointZero];
            [ptView.layer drawInContext:UIGraphicsGetCurrentContext()];
            UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();
            [[GifManager shareInterface] saveEditImage:resultImg withImgName:self.srcNameArray[i]];
        }
        UIGraphicsEndImageContext();
    }
}

- (IBAction)btnDoneTap:(id)sender
{
    [self saveBackImage];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)btnGobackTap:(id)sender
{
    [ptView reverse];
}


- (IBAction)btnCancelTap:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end

