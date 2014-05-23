//
//  VSWindow.m
//  VCMDemo
//
//  Created by xiangying on 14-5-4.
//  Copyright (c) 2014年 Vip. All rights reserved.
//

#import "VSWindow.h"
#import "VSViewControllerHolder.h"

@implementation UIWindow(VSWindow)

-(void)setVSRootViewController:(UIViewController *)rootViewController{
    [self setVSRootViewController:rootViewController];
    if ([[UIApplication sharedApplication].delegate window] == self) {
        [[VSViewControllerHolder shareInstance] removeAllViewController];
        [[VSViewControllerHolder shareInstance] addViewController:rootViewController];
    }
}

@end
