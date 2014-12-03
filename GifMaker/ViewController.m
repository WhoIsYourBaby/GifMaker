//
//  ViewController.m
//  GifMaker
//
//  Created by HalloWorld on 14-9-25.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "ViewController.h"
#import "SquareCamViewController.h"
#import "UIStoryboard+Main.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "GifManager.h"
#import "EditorViewController.h"
#import "DrawerViewController.h"
#import "PreviewViewController.h"

@implementation GifPlayerCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

@end

@interface ViewController ()

@property (strong, nonatomic) NSMutableArray *gifMakerAssets;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIBarButtonItem *test1 = [[UIBarButtonItem alloc] initWithTitle:@"t1" style:UIBarButtonItemStyleBordered target:self action:@selector(test1:)];
    UIBarButtonItem *test2 = [[UIBarButtonItem alloc] initWithTitle:@"t2" style:UIBarButtonItemStyleBordered target:self action:@selector(test2:)];
    UIBarButtonItem *test3 = [[UIBarButtonItem alloc] initWithTitle:@"t3" style:UIBarButtonItemStyleBordered target:self action:@selector(test3:)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:test1, test2, test3, nil];
    
    gifCollectView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"view_bkg"]];
    
    [[GifManager shareInterface] enumerateAlbumGifAssets:^(NSMutableArray *myGifAssets) {
        self.gifMakerAssets = myGifAssets;
        NSLog(@"%s", __func__);
    }];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions



- (IBAction)btnCameraTap
{
    [[GifManager shareInterface] cleanTempDir];
    SquareCamViewController *square = [SquareCamViewController quickInstance];
    [self.navigationController pushViewController:square animated:YES];
}



- (void)test1:(id)sender {
    EditorViewController *test = [EditorViewController quickInstance];
    [self.navigationController pushViewController:test animated:YES];
}
- (void)test2:(id)sender {
    DrawerViewController *test = [DrawerViewController quickInstance];
    [self.navigationController presentViewController:test animated:YES completion:nil];
}

- (void)test3:(id)sender {
    PreviewViewController *test = [PreviewViewController quickInstance];
    [self.navigationController pushViewController:test animated:YES];
}
#pragma mark - Coleect View Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.gifMakerAssets count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GifPlayerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GifPlayerCell" forIndexPath:indexPath];
    ALAsset *asset = [self.gifMakerAssets objectAtIndex:indexPath.row];
    ALAssetRepresentation *rep = [asset defaultRepresentation];
    CGImageRef cgimg = [rep fullResolutionImage];
    cell.gifImgView.image = [UIImage imageWithCGImage:cgimg];
    return cell;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


@end
