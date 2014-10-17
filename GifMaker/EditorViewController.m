//
//  EditorViewController.m
//  GifMaker
//
//  Created by HalloWorld on 14-10-16.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "EditorViewController.h"
#import "GifManager.h"
#import "DrawerViewController.h"
#import "UIStoryboard+Main.h"
#import "UIViewController+ADFlipTransition.h"

@interface EditorViewController ()

@end

@implementation EditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    collctionImgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"view_bkg"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}


#pragma mark - Actions

- (void)initImgNameArray:(NSArray *)aArr
{
    self.imgNameArray = [NSMutableArray arrayWithArray:aArr];
}

- (UICollectionView *)collectionView
{
    return collctionImgView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.imgNameArray count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImgEditorCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImgEditorCell" forIndexPath:indexPath];
    NSString *jpgName = self.imgNameArray[indexPath.row];
    UIImage *img = [[GifManager shareInterface] littleTempImageWithName:jpgName];
    [cell.imgView setImage:img];
    return cell;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImgEditorCell *cell = (ImgEditorCell *)[collctionImgView cellForItemAtIndexPath:indexPath];
    DrawerViewController *drawer = [[UIStoryboard mainStoryBoard] instantiateViewControllerWithIdentifier:@"DrawerViewController"];
    [self flipToViewController:drawer fromView:cell.imgView withCompletion:^{
        NSLog(@"%s -> ", __FUNCTION__);
    }];
}


@end


@implementation ImgEditorCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}


- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    NSLog(@"%s -> %d", __FUNCTION__, selected);
}


- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    NSLog(@"%s -> %d", __FUNCTION__, highlighted);
    if (highlighted) {
        self.backgroundColor = [UIColor blackColor];
    } else {
        self.backgroundColor = [UIColor redColor];
    }
}

@end
