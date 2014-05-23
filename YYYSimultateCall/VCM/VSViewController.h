//
//  VSViewController.h
//  Weimei
//
//  Created by Xiang on 14-4-3.
//  Copyright (c) 2014年 Vip. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController(VSViewController)

-(void)presentVSViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion;

- (void)presentVSModalViewController:(UIViewController *)modalViewController animated:(BOOL)animated;

- (void)dismissVSViewControllerAnimated: (BOOL)flag completion: (void (^)(void))completion;

- (void)dismissVSModalViewControllerAnimated:(BOOL)animated;

@end
