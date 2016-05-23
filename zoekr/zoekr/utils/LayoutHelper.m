//
//  LayoutHelper.m
//  AllerhandeApp
//
//  Created by Johan Ten Broeke on 09/08/14.
//  Copyright (c) 2014 Lukkien. All rights reserved.
//

#import "LayoutHelper.h"

@interface LayoutHelper ()

@property (nonatomic,strong) UIView *containerView;
@property (nonatomic,strong) NSMutableDictionary *viewDict;

@end

@implementation LayoutHelper

-(id)initWithContainerView:(UIView*)view{
    self = [super init];
    if(self){
        self.containerView = view;
        self.viewDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void)addSubView:(UIView*)view withKey:(NSString*)key{
    self.viewDict[key] = view;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:view];
}

-(void)addGuide:(id)layoutSupport withKey:(NSString*)key{
    self.viewDict[key] = layoutSupport;
}

-(void)setConstraints:(NSArray*)constraints{
    for (NSString *v in constraints) {
        [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:v options:0 metrics:nil views:self.viewDict]];
    }
}

@end
