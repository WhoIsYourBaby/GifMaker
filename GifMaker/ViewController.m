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
#import "AnimatedGIFImageSerialization.h"

static NSString *GifPlayerCellIdentifier = @"GifPlayerCellIdentifier";

@implementation GifPlayerCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}


- (NSData *)imageDataWithALAssert:(ALAsset *)result
{
    ALAssetRepresentation *assetRep = [result defaultRepresentation];
    long long size = [assetRep size];
    uint8_t *buff = malloc(size);
    NSError *err = nil;
    NSUInteger gotByteCount = [assetRep getBytes:buff fromOffset:0 length:size error:&err];
    return [NSData dataWithBytesNoCopy:buff length:size freeWhenDone:YES];
}


- (void)loadGifWithAsset:(ALAsset *)asset
{
    self.gifImgView.image = [UIImage imageNamed:@"loading"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [self imageDataWithALAssert:asset];
        NSError *err = nil;
        UIImage *img = [AnimatedGIFImageSerialization imageWithData:data error:&err];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.gifImgView.image = img;
        });
    });
}


- (void)loadGifWithLocalName:(NSString *)name
{
    self.gifImgView.image = [UIImage imageNamed:@"loading"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *img = [[GifManager shareInterface] gifImageWithName:name];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.gifImgView.image = img;
        });
    });
}

@end

@interface ViewController ()

@property (strong, nonatomic) NSMutableArray *albumGifAssets;
@property (strong, nonatomic) NSMutableArray *localGifFiles;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSaveInLocal:) name:kNotiSaveLocalGif object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSaveInAlbum:) name:kNotiSaveAlbumGif object:nil];
	// Do any additional setup after loading the view, typically from a nib.
    UIBarButtonItem *test1 = [[UIBarButtonItem alloc] initWithTitle:@"t1" style:UIBarButtonItemStyleBordered target:self action:@selector(test1:)];
    UIBarButtonItem *test2 = [[UIBarButtonItem alloc] initWithTitle:@"t2" style:UIBarButtonItemStyleBordered target:self action:@selector(test2:)];
    UIBarButtonItem *test3 = [[UIBarButtonItem alloc] initWithTitle:@"t3" style:UIBarButtonItemStyleBordered target:self action:@selector(test3:)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:test1, test2, test3, nil];
    
    [gifCollectView registerNib:[UINib nibWithNibName:@"GifPlayerCell" bundle:nil] forCellWithReuseIdentifier:GifPlayerCellIdentifier];
    gifCollectView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"view_bkg"]];
    
    [[GifManager shareInterface] enumerateAlbumGifAssets:^(NSMutableArray *myGifAssets) {
        self.albumGifAssets = myGifAssets;
        [gifCollectView reloadData];
    }];
    
    self.localGifFiles = [NSMutableArray arrayWithArray:[[GifManager shareInterface] localGifFiles]];
    
    [gifCollectView reloadData];
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

- (void)didSaveInAlbum:(NSNotification *)noti
{
    ALAsset *asset = [noti object];
    [self.albumGifAssets addObject:asset];
    [gifCollectView reloadSections:[NSIndexSet indexSetWithIndex:1]];
}


- (void)didSaveInLocal:(NSNotification *)noti
{
    NSString *gifName = [noti object];
    [self.localGifFiles addObject:gifName];
    [gifCollectView reloadSections:[NSIndexSet indexSetWithIndex:0]];
}


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
    if (section == 0) {
        return [self.localGifFiles count];
    }
    if (section == 1) {
        return [self.albumGifAssets count];
    }
    return 0;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GifPlayerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GifPlayerCellIdentifier forIndexPath:indexPath];
    if (indexPath.section == 1) {
        ALAsset *asset = [self.albumGifAssets objectAtIndex:indexPath.row];
        [cell loadGifWithAsset:asset];
    }
    
    if (indexPath.section == 0) {
        [cell loadGifWithLocalName:self.localGifFiles[indexPath.row]];
    }
    
    return cell;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}


@end
