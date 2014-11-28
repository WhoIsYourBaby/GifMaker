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

@end

@implementation EditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    collctionImgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"view_bkg"]];
    [collctionImgView registerNib:[ImgEditorCell nib] forCellWithReuseIdentifier:[ImgEditorCell identifier]];
    [collctionImgView registerNib:[UINib nibWithNibName:@"EditorFooterView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"EditorFooterView"];
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



#pragma mark - Actions

- (void)initImgNameArray:(NSArray *)aArr
{
    self.imgNameArray = [NSMutableArray arrayWithArray:aArr];
}


- (IBAction)btnPreviewTap:(id)sender
{
    /*
    PreviewViewController *preview = [[UIStoryboard mainStoryBoard] instantiateViewControllerWithIdentifier:@"PreviewViewController"];
    [self.navigationController pushViewController:preview animated:YES];
     */
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
    NSString *srcImgName = self.imgNameArray[indexPath.row];
    drawer.srcImgName = srcImgName;
    [self flipToViewController:drawer fromView:cell.imgView withCompletion:nil];
    editIndexPath = indexPath;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"EditorFooterView" forIndexPath:indexPath];
        reusableview = footerView;
        for (id subv in [footerView subviews]) {
            if ([subv isMemberOfClass:[UIButton class]]) {
                [subv setTitle:NSLocalizedString(@"preview", nil) forState:UIControlStateNormal];
            }
        }
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
    /*
    if (selected) {
        self.backgroundColor = [UIColor redColor];
    } else {
        self.backgroundColor = [UIColor clearColor];
    }
     */
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
