//
//  main.m
//  YYYSimultateCall
//
//  Created by YaoMing on 14-5-20.
//  Copyright (c) 2014年 YYY Team. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import "VSViewControllerHolder.h"

int main(int argc, char * argv[])
{
    @autoreleasepool {
        [VSViewControllerHolder shareInstance];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
