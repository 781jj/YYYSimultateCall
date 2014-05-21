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

@end

@implementation YYLocalNotification

- (id)initWithCall:(YYCall *)call{
    self = [super init];
    if (self) {
//        self.localNotification = [[UILocalNotification alloc] init];
//        
//        // 设置推送时间
//        NSDate *pushDate = [NSDate dateWithTimeIntervalSinceNow:call.timestamp];
//        _localNotification.fireDate = pushDate;
//        
//        // 设置时区
//        _localNotification.timeZone = [NSTimeZone defaultTimeZone];
//        
//        // 设置重复间隔
//        _localNotification.repeatInterval =  0;

    }
    return self;
}
@end
