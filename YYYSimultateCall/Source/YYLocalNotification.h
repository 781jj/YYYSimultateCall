//
//  YYLocalNotification.h
//  YYYSimultateCall
//
//  Created by YaoMing on 14-5-21.
//  Copyright (c) 2014年 YYY Team. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YYCall;
@interface YYLocalNotification : NSObject
+ (YYLocalNotification *)localNotificationWithCall:(YYCall *)call;
- (id)initWithCall:(YYCall *)call;
- (void)start;
- (void)stop;
- (void)update:(YYCall *)call;
@end
