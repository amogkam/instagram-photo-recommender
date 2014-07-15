//
//  AKPhotoCell.m
//  Photo Browser
//
//  Created by Amog Kamsetty on 7/12/14.
//  Copyright (c) 2014 Amog Kamsetty. All rights reserved.
//

#import "AKPhotoCell.h"
#import "AKPhotoController.h"

@implementation AKPhotoCell

static NSMutableDictionary *profile;

- (void)setPhoto:(NSDictionary *)photo {
    _photo = photo;
    
    [AKPhotoController imageForPhoto:_photo size:@"thumbnail" completion:^(UIImage *image) {
        self.imageView.image = image;
    }];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(like)];
        longPress.minimumPressDuration = 1.0f;
        [self addGestureRecognizer:longPress];
        
        [self.contentView addSubview:self.imageView];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = self.contentView.bounds;
}


- (void)like {
    
    if(profile == nil) profile = [[NSMutableDictionary alloc] init];
    
    NSArray *tags = self.photo[@"tags"];
    for (int i = 0; i<tags.count; i++)
    {
        NSString *tag = [tags objectAtIndex:i];
        if ([profile objectForKey:tag] == nil)
        {
            [profile setObject:@1 forKey:tag];
        }
             
        else
        {
            [profile setObject:@([[profile objectForKey:tag] intValue] +1) forKey:tag];
        }
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
    NSString *urlString = [[NSString alloc] initWithFormat:@"https://api.instagram.com/v1/media/%@/likes?access_token=%@", self.photo[@"id"], accessToken];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showLikeCompletion];
        });
    }];
    [task resume];
}


- (void)showLikeCompletion {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Liked!" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [alert show];
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [alert dismissWithClickedButtonIndex:0 animated:YES];
    });
}

+(NSMutableDictionary *) profile
{
    return profile;
}


@end











