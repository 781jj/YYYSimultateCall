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

+ (YYLocalNotification *)localNotificationWithCall:(YYCall *)call
{
    return [[YYLocalNotification alloc] initWithCall:call];
}

- (UILocalNotification *)creatLocationNotification:(YYCall *)call interval:(int)interval
{
 /*
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    NSDate *pushData = [NSDate dateWithTimeIntervalSinceNow:4];
    localNotification.fireDate = pushData;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.repeatInterval = 0;
    localNotification.soundName = call.ringSound;
    localNotification.alertBody = [NSString stringWithFormat:@"%@ %@",call.callName,call.callSound];
    localNotification.alertAction = @"OK";
    localNotification.alertLaunchImage = @"locationDefault.png";
    localNotification.userInfo = @{@"id": [NSString stringWithFormat:@"%d",call.callId]};
    
    localNotification.applicationIconBadgeNumber = 0;
*/
    NSArray *localArr = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *cancleNoti in localArr ) {
        [[UIApplication sharedApplication] cancelLocalNotification:cancleNoti];
    }
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    //设置10秒之后
    NSDate *pushDate = [NSDate dateWithTimeIntervalSinceNow:4];
    if (notification != nil) {
        // 设置推送时间
        notification.fireDate = pushDate;
        // 设置时区
        notification.timeZone = [NSTimeZone defaultTimeZone];
        // 设置重复间隔
        notification.repeatInterval = 0;
        // 推送声音
        notification.soundName = @"1.m4r";
        // 推送内容
        notification.alertBody = @"推送内容";
        
        //显示在icon上的红色圈中的数子
        notification.applicationIconBadgeNumber = 1;
        //设置userinfo 方便在之后需要撤销的时候使用
        NSDictionary *info = [NSDictionary dictionaryWithObject:@"name"forKey:@"key"];
        notification.userInfo = info;
        //添加推送到UIApplication
        UIApplication *app = [UIApplication sharedApplication];
        [app scheduleLocalNotification:notification];
        
    }
    return notification;
}

- (void)start
{
   // [self stop];
    for (UILocalNotification *localNotification in _repeatList) {
       // [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
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
