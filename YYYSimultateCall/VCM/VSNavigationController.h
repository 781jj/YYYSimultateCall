//
//  VSNavigationController.h
//  Weimei
//
//  Created by Xiang on 14-4-3.
//  Copyright (c) 2014年 Vip. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController(VSNavigationController)<UINavigationControllerDelegate>

@property (strong,nonatomic) NSString *isPop;

- (void)pushVSViewController:(UIViewController *)viewController animated:(BOOL)animated;

- (UIViewController *)popVSViewControllerAnimated:(BOOL)animated;

- (NSArray *)popToVSViewController:(UIViewController *)viewController animated:(BOOL)animated;

- (NSArray *)popToRootVSViewControllerAnimated:(BOOL)animated;

- (id)initWithRootVSViewController:(UIViewController *)rootViewController;

-(void)setNavDelegate:(id<UINavigationControllerDelegate>)delegate;

@end
