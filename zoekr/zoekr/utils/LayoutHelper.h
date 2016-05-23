//
//  LayoutHelper.h
//  AllerhandeApp
//
//  Created by Johan Ten Broeke on 09/08/14.
//  Copyright (c) 2014 Lukkien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//Util to help with auto-layout constraints
//nothing fancy, just saves some typing

@interface LayoutHelper : NSObject

-(id)initWithContainerView:(UIView*)view;
-(void)addSubView:(UIView*)view withKey:(NSString*)key;
-(void)addGuide:(id)layoutSupport withKey:(NSString*)key;
-(void)setConstraints:(NSArray*)constraints;

@end
