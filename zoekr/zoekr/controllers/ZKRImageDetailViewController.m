//
//  FSImageDetailViewController.m
//  zoekr
//
//  Created by Johan Ten Broeke on 22/05/16.
//  Copyright © 2016 Johan Ten Broeke. All rights reserved.
//

#import "ZKRImageDetailViewController.h"
#import "UIColor+ZKRColors.h"
#import "LayoutHelper.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ZKRImageDetailViewController ()

@end

@implementation ZKRImageDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor modalBackgroundColor]];
    
    // Image view
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [imageView setBackgroundColor:[UIColor modalBackgroundColor]];
    [self.view addSubview:imageView];
    
    // auto layout
    LayoutHelper *lh = [[LayoutHelper alloc] initWithContainerView:self.view];
    [lh addSubView:imageView withKey:@"imageView"];
    [lh setConstraints:@[@"H:|[imageView]|",@"V:|[imageView]|"]];
    
    // load image
    [imageView sd_setImageWithURL:self.imageURL];
    
    // tap to close
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
    
}

-(void)tap:(UITapGestureRecognizer*)tapGestureRecognizer{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
