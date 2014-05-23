//
//  YYCall.m
//  YYYSimultateCall
//
//  Created by YaoMing on 14-5-21.
//  Copyright (c) 2014年 YYY Team. All rights reserved.
//

#import "YYCall.h"

@interface YYCall ()<NSCoding>
@property (nonatomic,assign)NSInteger callId;

@end

@implementation YYCall

- (id)init
{
    self = [super init];
    if (self) {
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        self.callId = (NSInteger)time;
        self.callName = @"老妈";
        self.callSound = @"hoyou";
        self.ringSound = @"seaside";
        self.isOpen = YES;
    }
    return self;
}



- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.callId forKey:@"callId"];
    [aCoder encodeInteger:self.timestamp forKey:@"timestamp"];
    [aCoder encodeObject:self.callName forKey:@"callName"];
    [aCoder encodeObject:self.callSound forKey:@"callSound"];
    [aCoder encodeObject:self.ringSound forKey:@"ringSound"];
    [aCoder encodeInt:self.repeatType forKey:@"repeatIntrvalMinute"];
    [aCoder encodeBool:self.isOpen forKey:@"isOpen"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.callId = [aDecoder decodeIntegerForKey:@"callId"];
        self.timestamp = [aDecoder decodeIntegerForKey:@"timestamp"];
        self.repeatType = [aDecoder decodeIntForKey:@"repeatIntrvalMinute"];
        self.isOpen = [aDecoder decodeBoolForKey:@"isOpen"];
        self.callName = [aDecoder decodeObjectForKey:@"callName"];
        self.callSound = [aDecoder decodeObjectForKey:@"callSound"];
        self.ringSound = [aDecoder decodeObjectForKey:@"ringSound"];
    }
    return self;
}

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[YYCall class]]) {
        YYCall *first = (YYCall *)object;
        if (self.callId == first.callId) {
            return YES;
        }
        return NO;
    }
    return NO;
}


- (NSString *)repeatText
{
    switch (self.repeatType) {
        case YYNoRepeat:
            return @"不重复";
            break;
        case YYThreeMinuteRepeat:
            return @"3分钟一次";
            break;
        case YYFiveMinuteRepeat:
            return @"5分钟一次";
            break;
        case YYTenMinuteRepeat:
            return @"10分钟一次";
            break;
        case YYQuarterHourRepeat:
            return @"15分钟一次";
            break;
        case YYHalfHourRepeat:
            return @"30分钟一次";
            break;
        case YYThreeQuartersHourRepeat:
            return @"45分钟一次";
            break;
        case YYHourRepeat:
            return @"1小时一次";
            break;
        case YYTwoHoursRepeat:
            return @"2小时一次";
            break;
        default:
            break;
    }
    return nil;
}



@end
