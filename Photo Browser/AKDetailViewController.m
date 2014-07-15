//
//  AKDetailViewController.m
//  Photo Browser
//
//  Created by Amog Kamsetty on 7/13/14.
//  Copyright (c) 2014 Amog Kamsetty. All rights reserved.
//

#import "AKDetailViewController.h"
#import "AKPhotoController.h"
#import "AKMetadataView.h"

@interface AKDetailViewController ()

@property(nonatomic) UIImageView *imageView;
@property(nonatomic) UIDynamicAnimator *animator;

@end

@implementation AKDetailViewController

static BOOL firstTime = false;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.95];
	
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, -320.0, 320.0f, 320.0f)];
    [self.view addSubview:self.imageView];
    
    [AKPhotoController imageForPhoto:self.photo size:@"standard_resolution" completion:^(UIImage *image) {
        self.imageView.image = image;
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    [self.view addGestureRecognizer:tap];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    if(!firstTime)
    {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Welcome to Detail View!" message:@"Tap to escape from detail view and go back to the collection view!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                firstTime = true;
    [alert show];
    }
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:self.imageView snapToPoint:self.view.center];
    [self.animator addBehavior:snap];
}


- (void)close {
    [self.animator removeAllBehaviors];
    
    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:self.imageView snapToPoint:CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMaxY(self.view.bounds) + 180.0f)];
    [self.animator addBehavior:snap];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end










