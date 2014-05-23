//
//  YYController.m
//  YYYSimultateCall
//
//  Created by YaoMing on 14-5-21.
//  Copyright (c) 2014年 YYY Team. All rights reserved.
//

#import "YYController.h"
#import "YYCall.h"
#import "YYCallSource.h"
#import "YYLocalNotification.h"
#import "VSViewControllerHolder.h"
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

- (void)back:(BOOL)animation
{
    [[VSViewControllerHolder shareInstance] goBackanimated:animation];

}

- (void)addCall:(YYCall *)call
{

   
    [[YYCallSource shareInstance] insertCall:call];
    [[YYLocalNotification localNotificationWithCall:call] start];
    [self notificationChage];
    [[VSViewControllerHolder shareInstance] goBackanimated:YES];
}

- (void)deleteCall:(YYCall *)call
{
    [[YYCallSource shareInstance] deleteCall:call];
    [[YYLocalNotification localNotificationWithCall:call] stop];
    [self notificationChage];

}

- (void)openCall:(YYCall *)call
{
    [[YYLocalNotification localNotificationWithCall:call] start];
}

- (void)closeCall:(YYCall *)call
{
    [[YYLocalNotification localNotificationWithCall:call] stop];
}

- (void)editCall:(YYCall *)call
{
    YYCall *originCall = [[YYCallSource shareInstance] callOfId:call.callId];
    if (!originCall) {
        return;
    }
    [[YYCallSource shareInstance] updateCall:call];
    YYLocalNotification *notif = [[YYLocalNotification alloc]initWithCall:originCall];
    [notif update:call];
    [notif start];
    [self notificationChage];

}

- (void)notificationChage
{
    [[NSNotificationCenter defaultCenter] postNotificationName:YYCallListChange object:nil];


}
@end
