//
//  ZKRThumbnailCollectionViewCell.m
//  zoekr
//
//  Created by Johan Ten Broeke on 23/05/16.
//  Copyright © 2016 Johan Ten Broeke. All rights reserved.
//

#import "ZKRThumbnailCollectionViewCell.h"
#import "UIColor+ZKRColors.h"
#import "LayoutHelper.h"
#import <SDWebImage/UIImageView+WebCache.h>

NSString *const ZKRThumbnailCollectionViewCellIndentifier = @"ZKRThumbnailCollectionViewCell";


@interface ZKRThumbnailCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ZKRThumbnailCollectionViewCell

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    [self _init];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (!self) {
        return nil;
    }
    [self _init];
    return self;
}

- (void)_init {
    
    [self setBackgroundColor:[UIColor applicationChromeColor]];
    
    self.contentView.backgroundColor = [UIColor applicationChromeColor];
    self.clipsToBounds = YES;
    self.imageView = [[UIImageView alloc] init];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.imageView];
    
    // auto layout
    LayoutHelper *lh = [[LayoutHelper alloc] initWithContainerView:self];
    [lh addSubView:self.imageView withKey:@"imageView"];
    [lh setConstraints:@[@"H:|[imageView]|",@"V:|[imageView]|"]];
    
    
}

- (void)prepareForReuse {
    self.imageView.image = nil;
}

#pragma mark - image url setter

- (void)setImageURL:(NSURL *)url {
    [self.imageView sd_setImageWithURL:url];
}


@end
