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
#import "PreviewViewController.h"
#import "ExportViewController.h"
#import <QuartzCore/QuartzCore.h>


#pragma mark - EditorViewController
@interface EditorViewController ()
{
    int *selectIndexArr;    //值为1的index为选中
}

@end

@implementation EditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    collctionImgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"view_bkg"]];
    [collctionImgView registerNib:[ImgEditorCell nib] forCellWithReuseIdentifier:[ImgEditorCell identifier]];
    [collctionImgView registerNib:[EditorFooterView nib] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:[EditorFooterView identifier]];
    selectIndexArr = (int *)calloc(self.imgNameArray.count, sizeof(int));
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(btnTrashTap:)];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    if (editIndexPath) {
        [collctionImgView reloadItemsAtIndexPaths:@[editIndexPath]];
        editIndexPath = nil;
    }
}



- (void)dealloc
{
    free(selectIndexArr);
}

#pragma mark - Actions

- (void)initImgNameArray:(NSArray *)aArr
{
    self.imgNameArray = [NSMutableArray arrayWithArray:aArr];
}


- (IBAction)btnPreviewTap:(id)sender
{
}


/**
 *  删除、垃圾箱
 *
 */
- (void)btnTrashTap:(id)sender
{
    int length = self.imgNameArray.count;
    for (int i = 0; i < length; i ++) {
        if (selectIndexArr[i] == 1) {
            NSString *name = self.imgNameArray[i];
            [[GifManager shareInterface] removeImageWithName:name];
        }
    }
    
    self.imgNameArray = [NSMutableArray arrayWithArray:[[GifManager shareInterface] imageNameArrayInTemp]];
    
    memset(selectIndexArr, 0, length);
    [collctionImgView reloadData];
}


/**
 *  全选
 *
 */
- (void)btnSelectAllTap:(id)sender
{
    int length = self.imgNameArray.count;
    for (int i = 0; i < length; i ++) {
        selectIndexArr[i] = 1;
    }
    
    [collctionImgView reloadData];
}


/**
 *  反选
 *
 */
- (void)btnSelectReverseTap:(id)sender
{
    int arrLongth = self.imgNameArray.count;
    for (int i = 0; i < arrLongth; i ++) {
        int v = selectIndexArr[i];
        selectIndexArr[i] = !v;
    }
    [collctionImgView reloadData];
}

/**
 *  涂鸦
 *
 */
- (void)btnDoodleTap:(id)sender
{
    int length = self.imgNameArray.count;
    NSMutableArray *tempNameArr = [NSMutableArray arrayWithCapacity:100];
    for (int i = 0; i < length; i ++) {
        if (selectIndexArr[i] == 1) {
            NSString *name = self.imgNameArray[i];
            [tempNameArr addObject:name];
        }
    }
    if ([tempNameArr count] == 0) {
        //提示--先选中一些图片
        return ;
    }
    
    DrawerViewController *drawer = [DrawerViewController quickInstance];
    [drawer setDoodleImgNames:tempNameArr];
    [self flipToViewController:drawer fromView:self.view withCompletion:nil];
}


/**
 *  制作GIF
 */
- (void)btnMakeGifTap:(id)sender
{
    NSString *fp = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    fp = [fp stringByAppendingPathComponent:@"test.gif"];
    ExportViewController *export = [[ExportViewController alloc] initWithImages:[[GifManager shareInterface] imageArrayInTemp]];
    [self.navigationController presentViewController:export animated:YES completion:nil];
    [export encodeToFile:fp callback:^(NSString *file) {
        NSLog(@"%s -> %@", __FUNCTION__, file);
        [export dismissViewControllerAnimated:YES completion:nil];
    }];
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
    BOOL isSelected = selectIndexArr[indexPath.row];
    [cell setSelected:isSelected];
    return cell;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    int slctd = !(selectIndexArr[indexPath.row]);
    selectIndexArr[indexPath.row] = slctd;
    ImgEditorCell *cell = (ImgEditorCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell setSelected:slctd];
    [collctionImgView reloadData];
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionFooter) {
        EditorFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:[EditorFooterView identifier] forIndexPath:indexPath];
        [footerView.btnSelectAll addTarget:self action:@selector(btnSelectAllTap:) forControlEvents:UIControlEventTouchUpInside];
        [footerView.btnSelectReverse addTarget:self action:@selector(btnSelectReverseTap:) forControlEvents:UIControlEventTouchUpInside];
        [footerView.btnDoodle addTarget:self action:@selector(btnDoodleTap:) forControlEvents:UIControlEventTouchUpInside];
        [footerView.btnMakeGif addTarget:self action:@selector(btnMakeGifTap:) forControlEvents:UIControlEventTouchUpInside];
        reusableview = footerView;
    }
    return reusableview;
}


@end



#pragma mark - ImgEditorCell
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
    if (selected) {
        self.backgroundColor = [UIColor redColor];
    } else {
        self.backgroundColor = [UIColor clearColor];
    }
}

+ (NSString *)identifier
{
    static NSString *ImgEditorCellIdentifier = @"ImgEditorCell";
    return ImgEditorCellIdentifier;
}

+ (UINib *)nib
{
    return [UINib nibWithNibName:@"ImgEditorCell" bundle:nil];
}

@end


@implementation EditorFooterView

+ (NSString *)identifier
{
    static NSString *EditorFooterViewIdentifier = @"EditorFooterView";
    return EditorFooterViewIdentifier;
}


+ (UINib *)nib
{
    return [UINib nibWithNibName:@"EditorFooterView" bundle:nil];
}


+ (NSString *)kind
{
    return UICollectionElementKindSectionFooter;
}


- (void)awakeFromNib
{
    [super awakeFromNib];
}


@end
