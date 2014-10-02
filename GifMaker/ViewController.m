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

@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) ALAssetsGroup *gifMakerGroup;
@property (strong, nonatomic) NSMutableArray *gifMakerAssets;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIBarButtonItem *itemCamera = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(btnCameraTap)];
    UIBarButtonItem *itemAlbum = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(btnAlbumTap)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:itemAlbum, itemCamera, nil];
    
    gifCollectView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"view_bkg"]];
    
    [self enumerateAssetsGroup];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions


- (ALAssetsLibrary *)assetsLibrary
{
    if (_assetsLibrary == nil) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    return _assetsLibrary;
}

- (NSMutableArray *)gifMakerAssets
{
    if (_gifMakerAssets == nil) {
        _gifMakerAssets = [[NSMutableArray alloc] initWithCapacity:100];
    }
    return _gifMakerAssets;
}

- (void)enumerateAssetsGroup
{
    // setup our failure view controller in case enumerateGroupsWithTypes fails
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
        NSString *errorMessage = nil;
        switch ([error code]) {
            case ALAssetsLibraryAccessUserDeniedError:
            case ALAssetsLibraryAccessGloballyDeniedError:
                errorMessage = @"The user has declined access to it.";
                break;
            default:
                errorMessage = @"Reason unknown.";
                break;
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    };
    
    // emumerate through our groups and only add groups that contain photos
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        NSString *groupName = [group valueForProperty:ALAssetsGroupPropertyName];
        if ([groupName isEqualToString:kGifGroupName]) {
            ALAssetsFilter *allFilter = [ALAssetsFilter allAssets];
            [group setAssetsFilter:allFilter];
            self.gifMakerGroup = group;
            //停止遍历
            *stop = YES;
        }
        //遍历group完成后开始遍历Assets
        if (group == nil) {
            [self enumerateAssetsInGifGroup];
        }
    };
    
    // enumerate photos
    NSUInteger groupTypes = ALAssetsGroupAlbum | ALAssetsGroupSavedPhotos;
    [self.assetsLibrary enumerateGroupsWithTypes:groupTypes usingBlock:listGroupBlock failureBlock:failureBlock];
}

- (void)enumerateAssetsInGifGroup
{
    //如果不存在
    ALAssetsLibraryGroupResultBlock blcresult = ^(ALAssetsGroup *group) {
        //success
        self.gifMakerGroup = group;
    };
    ALAssetsLibraryAccessFailureBlock failure = ^(NSError *error) {
        NSLog(@"%s -> %@", __FUNCTION__, error);
    };
    if (self.gifMakerGroup == nil) {
        [self.assetsLibrary addAssetsGroupAlbumWithName:kGifGroupName resultBlock:blcresult failureBlock:failure];
    }
    
    if ([self.gifMakerGroup numberOfAssets] > 0) {
        [self.gifMakerGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result == nil) {
                //遍历完成
                [gifCollectView reloadData];
            } else {
                [self.gifMakerAssets addObject:result];
            }
        }];
    } else {
        NSLog(@"%s -> No Assets in GifMaker", __FUNCTION__);
    }
    
}

- (void)btnCameraTap
{
    SquareCamViewController *square = [[UIStoryboard mainStoryBoard] instantiateViewControllerWithIdentifier:@"SquareCamViewController"];
    UINavigationController *squareNav = [[UINavigationController alloc] initWithRootViewController:square];
    squareNav.navigationBarHidden = YES;
    square.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:squareNav animated:YES completion:nil];
}


- (void)btnAlbumTap
{
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
