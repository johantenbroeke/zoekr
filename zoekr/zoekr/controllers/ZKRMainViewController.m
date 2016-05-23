//
//  ViewController.m
//  zoekr
//
//  Created by Johan Ten Broeke on 21/05/16.
//  Copyright © 2016 Johan Ten Broeke. All rights reserved.
//

#import "ZKRMainViewController.h"
#import "FlickrKit.h"
#import "LayoutHelper.h"
#import "ZKRThumbnailCollectionViewCell.h"
#import "ZKRLoadingCollectionViewCell.h"
#import "ZKRImageDetailViewController.h"
#import "UIColor+ZKRColors.h"
#import "settings.h"


@interface ZKRMainViewController ()<UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSMutableArray *largeImages;

@property (nonatomic, strong) NSString *searchText;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation ZKRMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    // Search Bar
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.translatesAutoresizingMaskIntoConstraints = NO;
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    self.searchBar.delegate = self;
    self.searchBar.showsBookmarkButton = NO;
    self.searchBar.placeholder = @"Zoekr!";
    [self.searchBar becomeFirstResponder];
    [self.searchBar setBarTintColor:[UIColor applicationChromeColor]];
    [self.searchBar setBackgroundColor:[UIColor applicationChromeColor]];
    [self.view addSubview:self.searchBar];
    
    // Collection view
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.itemSize =  CGSizeMake(100.0, 100.0);
    flowLayout.minimumLineSpacing = 5.0;
    flowLayout.minimumInteritemSpacing = 5.0;
    flowLayout.sectionInset = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.collectionView.allowsSelection = YES;
    self.collectionView.allowsMultipleSelection = NO;
    [self.view addSubview:self.collectionView];
    
    // register cells
    [self.collectionView registerClass:ZKRThumbnailCollectionViewCell.class forCellWithReuseIdentifier:ZKRThumbnailCollectionViewCellIndentifier];
    [self.collectionView registerClass:ZKRLoadingCollectionViewCell.class forCellWithReuseIdentifier:ZKRLoadingCollectionViewCellIndentifier];
    
    // auto layout
    LayoutHelper *lh = [[LayoutHelper alloc] initWithContainerView:self.view];
    [lh addSubView:self.searchBar withKey:@"searchBar"];
    [lh addSubView:self.collectionView withKey:@"collectionView"];
    [lh addGuide:self.topLayoutGuide withKey:@"topGuide"];
    [lh setConstraints:@[@"H:|[searchBar]|",
                         @"H:|[collectionView]|",
                         @"V:[topGuide][searchBar(44)][collectionView]|"]];
    
    [[FlickrKit sharedFlickrKit] initializeWithAPIKey:FLICKR_API_KEY sharedSecret:FLICKR_API_SECRET];
    
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    // reset
    self.images = [[NSMutableArray alloc] init];
    self.largeImages = [[NSMutableArray alloc] init];
    self.currentPage = 1;
    [self.collectionView reloadData];
    
    self.searchText = searchBar.text;
    self.currentPage = 1;
    [self loadImages];
}

-(void)showError:(NSString*)message{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error"
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [alertController addAction:actionOk];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)loadImages{
    
    FlickrKit *fk = [FlickrKit sharedFlickrKit];
    FKFlickrPhotosSearch *search = [[FKFlickrPhotosSearch alloc] init];
    search.text = self.searchText;
    search.page = [NSString stringWithFormat:@"%li",(long)self.currentPage];
    search.per_page = [NSString stringWithFormat:@"%i",FLICKR_RESULT_NUM_IMAGES_PER_PAGE];
    
    [fk call:search completion:^(NSDictionary *response, NSError *error) {
        
        // if we catch an error show it to the user
        if(error != nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showError:[error localizedDescription]];
            });
            return;
        }
        
        // we have a response
        if (response) {
            NSMutableArray *photoURLs = [[NSMutableArray alloc] init];
            NSMutableArray *largeURLs = [[NSMutableArray alloc] init];
            NSArray *images = [response valueForKeyPath:@"photos.photo"];
            
            // if we dont't have any images tell the user
            if([images count] == 0){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showError:@"Flickr did not return any images for this search."];
                });
                return;
            }
            
            // create the data to populate the collectionView
            for (NSDictionary *photoData in images) {
                
                NSURL *url = [fk photoURLForSize:FKPhotoSizeLargeSquare150 fromPhotoDictionary:photoData];
                [photoURLs addObject:url];
                
                NSURL *urlLarge = [fk photoURLForSize:FKPhotoSizeLarge1024 fromPhotoDictionary:photoData];
                [largeURLs addObject:urlLarge];
                
            }
            
            // deliver on the main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.images addObjectsFromArray:photoURLs];
                [self.largeImages addObjectsFromArray:largeURLs];
                [self.collectionView reloadData];
            });
            
        }else{
            
            // if we did not get a valid response tell the user
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showError:@"Flickr did not return any images for this search."];
            });
            
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 3 columns on all phones with 5 pix gutter
    CGFloat cellSize = (CGRectGetWidth(self.collectionView.bounds)-20)/3.0;
    return CGSizeMake(cellSize,cellSize);
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 5.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 5.0;
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    // no results dont show the 'next page loader'
    if([self.images count] == 0){
        return 0;
    }
    
    // add one cell to show a simple loader cell in the same section
    return [self.images count] + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row < [self.images count]){
        return [self imageCellForIndexPath:indexPath];
    }else{
        
        // if we need the loader cell
        // we are at the end of the current result set
        // load the next page
        
        self.currentPage ++;
        [self loadImages];
        return [self loadingCellForIndexPath:indexPath];
    }
}

- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if(indexPath.row < [self.images count]){
        ZKRImageDetailViewController *vc = [[ZKRImageDetailViewController alloc] init];
        vc.imageURL = self.largeImages[indexPath.row];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

#pragma mark - create the cells

- (UICollectionViewCell *)imageCellForIndexPath:(NSIndexPath *)indexPath {
    ZKRThumbnailCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:ZKRThumbnailCollectionViewCellIndentifier forIndexPath:indexPath];
    [cell setImageURL:self.images[indexPath.row]];
    return cell;
}

- (UICollectionViewCell *)loadingCellForIndexPath:(NSIndexPath *)indexPath {
    ZKRLoadingCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:ZKRLoadingCollectionViewCellIndentifier forIndexPath:indexPath];
    return cell;
}

@end
