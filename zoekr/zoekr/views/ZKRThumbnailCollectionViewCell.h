//
//  ZKRThumbnailCollectionViewCell.h
//  zoekr
//
//  Created by Johan Ten Broeke on 23/05/16.
//  Copyright © 2016 Johan Ten Broeke. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const ZKRThumbnailCollectionViewCellIndentifier;

@interface ZKRThumbnailCollectionViewCell : UICollectionViewCell

- (void)setImageURL:(NSURL *)url;

@end
