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
        self.callName = @"";
        self.callSound = @"";
        self.ringSound = @"";
    }
    return self;
}



- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:self.callId forKey:@"callId"];
    [aCoder encodeInt:self.timestamp forKey:@"timestamp"];
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
        self.repeatType = [aDecoder decodeIntegerForKey:@"repeatIntrvalMinute"];
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




@end
