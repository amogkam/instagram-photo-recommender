//
//  AKPhotoController.h
//  Photo Browser
//
//  Created by Amog Kamsetty on 7/13/14.
//  Copyright (c) 2014 Amog Kamsetty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AKPhotoController : NSObject

+(void) imageForPhoto: (NSDictionary *)photo size:(NSString *)size completion:(void(^)(UIImage *image))completion;

@end
