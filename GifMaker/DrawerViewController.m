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

#define k_toolbar_height 40

@interface DrawerViewController ()
{
    UIImageView *imgView;
    PaintView *ptView;
    UIButton *btnDone;
    UIButton *btnGoback;
    UIButton *btnCancel;
}

@property (strong, nonatomic) UIImage *srcImage;

@end

@implementation DrawerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"view_bkg"]];
    [self initColorToolbar];
    [self initLineWidthToolbar];
}

- (void)initLineWidthToolbar
{
    //初始化线宽toolbar
    DrawerToolView *toolbar = [[DrawerToolView alloc] initWithFrame:CGRectMake(0, k_toolbar_height, self.view.frame.size.width, k_toolbar_height + 3)];
    [self.view addSubview:toolbar];
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
                        [NSNumber numberWithInt:23],
                        [NSNumber numberWithInt:25]
                        ];
    for (NSNumber *lw in lines) {
        ToolItemView *item = [ToolItemView toolItemViewWithObjc:lw];
        [toolbar addItem:item];
    }
    [toolbar setCallbackBlock:^(id objc) {
        ptView.lineWidth = [objc floatValue];
    }];
}

- (void)initColorToolbar
{
    //初始化toolbar
    DrawerToolView *toolbar = [[DrawerToolView alloc] initWithFrame:CGRectMake(0, 3, self.view.frame.size.width, k_toolbar_height)];
    [self.view addSubview:toolbar];
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
        [toolbar addItem:item];
    }
    [toolbar setCallbackBlock:^(id objc) {
        ptView.lineColor = objc;
    }];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    float btnOriginY = k_toolbar_height * 2;
    float btnOriginX = 140;
    
    if (imgView == nil) {
        //生成imgView和ptView
        imgView = [[UIImageView alloc] initWithImage:self.srcImage];
        [self.view addSubview:imgView];
        imgView.center = self.view.center;
        imgView.frame = CGRectOffset(imgView.frame, 0, 20);
        
        ptView = [[PaintView alloc] initWithFrame:imgView.frame];
        [self.view addSubview:ptView];
        btnOriginY = imgView.frame.size.height + imgView.frame.origin.y + 7;
        ptView.lineColor = [UIColor redColor];
        ptView.lineWidth = 3.f;
    }
    
    if (btnDone == nil) {
        btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnDone setFrame:CGRectMake(btnOriginX, btnOriginY, 30, 30)];
        [btnDone setImage:[UIImage imageNamed:@"done"] forState:UIControlStateNormal];
        [self.view addSubview:btnDone];
        [btnDone addTarget:self action:@selector(btnDoneTap:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (btnGoback == nil) {
        btnGoback = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnGoback setFrame:CGRectMake(btnOriginX + 60, btnOriginY, 30, 30)];
        [btnGoback setImage:[UIImage imageNamed:@"goback"] forState:UIControlStateNormal];
        [self.view addSubview:btnGoback];
        [btnGoback addTarget:self action:@selector(btnGobackTap:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (btnCancel == nil) {
        btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnCancel setFrame:CGRectMake(btnOriginX + 120, btnOriginY, 30, 30)];
        [btnCancel setImage:[UIImage imageNamed:@"off"] forState:UIControlStateNormal];
        [self.view addSubview:btnCancel];
        [btnCancel addTarget:self action:@selector(btnCancelTap:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setDoodleImgNames:(NSArray *)aNameArr
{
    NSArray *imgArr = [[GifManager shareInterface] bigTempImageArrayWithNames:aNameArr];
    self.srcImage = [UIImage animatedImageWithImages:imgArr duration:[SettingBundle globalSetting].timeInterval];
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
    /*
    UIGraphicsBeginImageContext(imgView.frame.size);
    [imgView.image drawAtPoint:CGPointZero];
    [ptView.layer drawInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [[GifManager shareInterface] saveEditImage:img withImgName:self.srcImgName];
     */
}

- (void)btnDoneTap:(id)sender
{
    [self saveBackImage];
    [self dismissFlipWithCompletion:nil];
}


- (void)btnGobackTap:(id)sender
{
    [ptView reverse];
}


- (void)btnCancelTap:(id)sender
{
    [self dismissFlipWithCompletion:nil];
}


@end
