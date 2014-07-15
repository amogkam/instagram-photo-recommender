//
//  AKDismissDetailTransition.m
//  Photo Browser
//
//  Created by Amog Kamsetty on 7/13/14.
//  Copyright (c) 2014 Amog Kamsetty. All rights reserved.
//

#import "AKDismissDetailTransition.h"

@implementation AKDismissDetailTransition

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *detail = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [UIView animateWithDuration:0.3 animations:^{
        detail.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [detail.view removeFromSuperview];
        [transitionContext completeTransition:YES];
    }];
}


- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

@end

