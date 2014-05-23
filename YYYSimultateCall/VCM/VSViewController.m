//
//  VSViewController.m
//  Weimei
//
//  Created by Xiang on 14-4-3.
//  Copyright (c) 2014年 Vip. All rights reserved.
//

#import "VSViewController.h"
#import "VSViewControllerHolder.h"

@implementation UIViewController(VSViewController)

-(void)presentVSViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion{
    [self presentVSViewController:viewControllerToPresent animated:flag completion:completion];
    if (![viewControllerToPresent isKindOfClass:NSClassFromString(@"_UIModalItemsPresentingViewController")]) {
        //alertview的controller不需要加入vcm中
        [[VSViewControllerHolder shareInstance] addViewController:viewControllerToPresent];
    }
}

- (void)presentVSModalViewController:(UIViewController *)modalViewController animated:(BOOL)animated{
    [self presentVSModalViewController:modalViewController animated:animated];
    if (![modalViewController isKindOfClass:NSClassFromString(@"_UIModalItemsPresentingViewController")]) {
        //alertview的controller不需要加入vcm中
        [[VSViewControllerHolder shareInstance] addViewController:modalViewController];
    }
}

- (void)dismissVSViewControllerAnimated: (BOOL)flag completion: (void (^)(void))completion{
    [self dismissVSViewControllerAnimated:flag completion:completion];
    
    //坑爹模式删除法
    if ([self.childViewControllers count]>0) {
        //你是老爸，儿子坑你
        [[VSViewControllerHolder shareInstance] deleteToViewControlView:self];
    }else{
        //你是儿子，坑老爸
        [[VSViewControllerHolder shareInstance] deleteToViewControlView:self.presentingViewController];
    }
}

- (void)dismissVSModalViewControllerAnimated:(BOOL)animated{
    [self dismissVSModalViewControllerAnimated:animated];
    //坑爹模式删除法
    if ([self.childViewControllers count]>0) {
        //你是老爸，儿子坑你
        [[VSViewControllerHolder shareInstance] deleteToViewControlView:self];
    }else{
        //你是儿子，坑老爸
        [[VSViewControllerHolder shareInstance] deleteToViewControlView:self.presentingViewController];
    }
}

@end
