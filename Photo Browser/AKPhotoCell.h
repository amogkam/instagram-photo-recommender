//
//  AKPhotoCell.h
//  Photo Browser
//
//  Created by Amog Kamsetty on 7/12/14.
//  Copyright (c) 2014 Amog Kamsetty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AKPhotoCell : UICollectionViewCell

@property (nonatomic) UIImageView *imageView;
@property (nonatomic) NSDictionary *photo;

+(NSMutableDictionary *) profile;

@end
