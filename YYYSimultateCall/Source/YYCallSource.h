//
//  YYCallSource.h
//  YYYSimultateCall
//
//  Created by YaoMing on 14-5-21.
//  Copyright (c) 2014年 YYY Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YYCall;
@interface YYCallSource : NSObject
+ (YYCallSource *)shareInstance;
- (BOOL)insertCall:(YYCall *)call;
- (BOOL)deleteCall:(YYCall *)call;
- (BOOL)updateCall:(YYCall *)call;
- (NSArray *)list;
@end
