//
//  ZKRLoadingCollectionViewCell.m
//  zoekr
//
//  Created by Johan Ten Broeke on 23/05/16.
//  Copyright © 2016 Johan Ten Broeke. All rights reserved.
//

#import "ZKRLoadingCollectionViewCell.h"
#import "UIColor+ZKRColors.h"
#import "LayoutHelper.h"

NSString *const ZKRLoadingCollectionViewCellIndentifier = @"ZKRLoadingCollectionViewCellIndentifier";

@implementation ZKRLoadingCollectionViewCell

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


    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [spinner startAnimating];
    
    // auto layout
    LayoutHelper *lh = [[LayoutHelper alloc] initWithContainerView:self];
    [lh addSubView:spinner withKey:@"spinner"];
    [lh setConstraints:@[@"H:|[spinner]|",@"V:|[spinner]|"]];
    
}

@end
