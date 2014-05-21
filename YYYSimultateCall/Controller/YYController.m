//
//  YYController.m
//  YYYSimultateCall
//
//  Created by YaoMing on 14-5-21.
//  Copyright (c) 2014年 YYY Team. All rights reserved.
//

#import "YYController.h"
static YYController *instance = nil;

@implementation YYController
+ (YYController *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (nil == instance) {
            instance = [[YYController alloc] init];
        }
    });
    return instance;
}
@end
