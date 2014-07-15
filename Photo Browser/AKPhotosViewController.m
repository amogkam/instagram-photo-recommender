//
//  AKPhotosViewController.m
//  Photo Browser
//
//  Created by Amog Kamsetty on 7/11/14.
//  Copyright (c) 2014 Amog Kamsetty. All rights reserved.
//

#import "AKPhotosViewController.h"
#import "AKPhotoCell.h"
#import "AKDetailViewController.h"
#import "AKPresentDetailTransition.h"
#import "AKDismissDetailTransition.h"

#import <SimpleAuth/SimpleAuth.h>

@interface AKPhotosViewController () <UIViewControllerTransitioningDelegate>
@property (nonatomic) NSString *accessToken;
@property (nonatomic) NSArray *photos;
@property (nonatomic) UIRefreshControl *refreshControl;
@end

@implementation AKPhotosViewController

- (instancetype)init {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(106.0, 106.0);
    layout.minimumInteritemSpacing = 1.0;
    layout.minimumLineSpacing = 1.0;
    
    return (self = [super initWithCollectionViewLayout:layout]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Photo Recommender";
    
    [self.collectionView registerClass:[AKPhotoCell class] forCellWithReuseIdentifier:@"photo"];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.collectionView addSubview: self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.accessToken = [userDefaults objectForKey:@"accessToken"];
    
    if (self.accessToken == nil) {
        [SimpleAuth authorize:@"instagram" options:@{@"scope": @[@"likes"]} completion:^(NSDictionary *responseObject, NSError *error) {
            
            self.accessToken = responseObject[@"credentials"][@"token"];
            
            [userDefaults setObject:self.accessToken forKey:@"accessToken"];
            [userDefaults synchronize];
            
            [self refresh];
        }];
    } else {
        [self refresh];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Welcome to Photo Recommender!" message:@"Hold to like a photo and scroll down to view your recommendations!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

-(void) refreshView:(UIRefreshControl *)refreshControl
{
    [self refresh];
    [refreshControl endRefreshing];
    [self.collectionView reloadData];
}


- (void)refresh {
    
    NSMutableDictionary *profile = [AKPhotoCell profile];
    int high = 0;
    NSString *pop;
    BOOL isEmpty = ([profile count] == 0);
    
    if (isEmpty)
    {
        NSURLSession *session = [NSURLSession sharedSession];
        NSString *urlString = [[NSString alloc] initWithFormat:@"https://api.instagram.com/v1/media/popular?access_token=%@", self.accessToken];
        NSURL *url = [[NSURL alloc] initWithString:urlString];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            
            NSData *data = [[NSData alloc] initWithContentsOfURL:location];
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            
            self.photos = [responseDictionary valueForKeyPath:@"data"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
        }];
        [task resume];
    }
    
    else
    {
    
    for(NSString *key in [profile allKeys])
    {
        int obj = [[profile objectForKey:key] intValue];
        if(obj > high)
        {
            high = obj;
            pop = key;
        }
            
    }
        
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *urlString = [[NSString alloc] initWithFormat:@"https://api.instagram.com/v1/tags/%@/media/recent?access_token=%@", pop, self.accessToken];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        
        NSData *data = [[NSData alloc] initWithContentsOfURL:location];
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        self.photos = [responseDictionary valueForKeyPath:@"data"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    }];
    [task resume];
    }
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.photos count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AKPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photo" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor lightGrayColor];
    cell.photo = self.photos[indexPath.row];
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *photo = self.photos[indexPath.row];
    AKDetailViewController *viewController = [[AKDetailViewController alloc] init];
    viewController.modalPresentationStyle = UIModalPresentationCustom;
    viewController.transitioningDelegate = self;
    viewController.photo = photo;
    
    [self presentViewController:viewController animated:YES completion:nil];
}


- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [[AKPresentDetailTransition alloc] init];
}


- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[AKDismissDetailTransition alloc] init];
}

@end















