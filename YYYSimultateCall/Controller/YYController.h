//
//  YYController.h
//  YYYSimultateCall
//
//  Created by YaoMing on 14-5-21.
//  Copyright (c) 2014年 YYY Team. All rights reserved.
//


#define YYCallListChange @"CallListChange"
#import <Foundation/Foundation.h>
@class YYCall;
@interface YYController : NSObject
+ (YYController *)shareInstance;
- (void)back:(BOOL)animation;
- (void)addCall:(YYCall *)call;
- (void)deleteCall:(YYCall *)call;
- (void)openCall:(YYCall *)call;
- (void)closeCall:(YYCall *)call;
- (void)editCall:(YYCall *)call;
- (void)goToWaitPage;
- (void)goToReplayPage;

@end
