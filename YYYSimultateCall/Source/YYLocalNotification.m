//
//  YYLocalNotification.m
//  YYYSimultateCall
//
//  Created by YaoMing on 14-5-21.
//  Copyright (c) 2014年 YYY Team. All rights reserved.
//

#import "YYLocalNotification.h"
#import "YYCall.h"
@interface YYLocalNotification ()
@property (nonatomic,strong)YYCall *call;
@property (nonatomic,strong)NSMutableArray *repeatList;
@end

@implementation YYLocalNotification

- (id)initWithCall:(YYCall *)call{
    self = [super init];
    if (self) {
        self.call = call;
        self.repeatList = [NSMutableArray array];
        if (call.repeatType == 0) {
            UILocalNotification *localNoti = [self creatLocationNotification:call interval:0];
            [_repeatList addObject:localNoti];
        }else{
            for (int i = 0; i<5; i++) {
                int minutes = (int )call.repeatType;
                UILocalNotification *localNoti = [self creatLocationNotification:call interval:minutes*60];
                [_repeatList addObject:localNoti];
            }
        }


    }
    return self;
}

- (UILocalNotification *)creatLocationNotification:(YYCall *)call interval:(int)interval
{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    NSDate *pushData = [NSDate dateWithTimeIntervalSinceNow:call.timestamp+interval];
    localNotification.fireDate = pushData;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.repeatInterval = 0;
    localNotification.soundName = call.ringSound;
    localNotification.alertBody = [NSString stringWithFormat:@"%@ %@",call.callName,call.callSound];
    localNotification.alertAction = @"OK";
    localNotification.alertLaunchImage = @"locationDefault.png";
    localNotification.userInfo = @{@"id": [NSString stringWithFormat:@"%d",call.callId]};
    
    localNotification.applicationIconBadgeNumber = 1;
    return localNotification;
}

- (void)start
{
    for (UILocalNotification *localNotification in _repeatList) {
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
}

- (void)stop
{
    //获取本地推送数组
    NSMutableArray *cancleList = [NSMutableArray array];
    NSArray *localArr = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    if (localArr) {
        for (UILocalNotification *noti in localArr) {
            NSDictionary *dict = noti.userInfo;
            if (dict) {
                NSString *inKey = [dict objectForKey:@"id"];
                if (inKey && [inKey integerValue] == _call.callId ) {
                    [cancleList addObject:noti];
                }
            }
        }
    }
    
    for (UILocalNotification *cancleNoti in localArr ) {
          [[UIApplication sharedApplication] cancelLocalNotification:cancleNoti];
    }
    
}

- (void)update:(YYCall *)call
{
    [self stop];
    [_repeatList removeAllObjects];
    self.call = call;
    if (call.repeatType == 0) {
        UILocalNotification *localNoti = [self creatLocationNotification:call interval:0];
        [_repeatList addObject:localNoti];
    }else{
        for (int i = 0; i<5; i++) {
            int minutes = (int )call.repeatType;
            UILocalNotification *localNoti = [self creatLocationNotification:call interval:minutes*60];
            [_repeatList addObject:localNoti];
        }
    }
}

- (void)dealloc
{
    [self stop];
}

@end
