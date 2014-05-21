//
//  YYCallSource.m
//  YYYSimultateCall
//
//  Created by YaoMing on 14-5-21.
//  Copyright (c) 2014年 YYY Team. All rights reserved.
//

#import "YYCallSource.h"
#import "YYCall.h"
#define CALL_CACHE_DIR [[[NSHomeDirectory() stringByAppendingPathComponent:@"Library"] stringByAppendingPathComponent:@"Caches"]stringByAppendingPathComponent:@"Call"]
#define CALL_FILE_PATH [CALL_CACHE_DIR stringByAppendingPathComponent:@"call"]


static YYCallSource *instance = nil;
@implementation YYCallSource
+ (YYCallSource *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (nil == instance) {
            instance = [[YYCallSource alloc] init];
            if(![[NSFileManager defaultManager] fileExistsAtPath:CALL_CACHE_DIR])
            {
                NSError *error;
                if(![[NSFileManager defaultManager] createDirectoryAtPath:CALL_CACHE_DIR
                                              withIntermediateDirectories:YES
                                                               attributes:nil
                                                                    error:&error]){
                }
            }
        }
    });
    return instance;
}

- (NSArray *)list
{
    NSString *localPath = CALL_FILE_PATH;
    if (localPath && [[NSFileManager defaultManager] fileExistsAtPath:localPath]) {
        id listData = [NSKeyedUnarchiver  unarchiveObjectWithFile:localPath];
        NSArray *list;
        if ([listData isKindOfClass:[NSArray class]]) {
            list = (NSArray *)listData;
            if ([list count] > 0) {
                return list;
            }
        }
	}
    return nil;
}

- (BOOL)insertCall:(YYCall *)call
{
    if (!call) {
        return NO;
    }
    NSArray *list = [self list];
    NSMutableArray *array;
    if (list) {
        array = [NSMutableArray arrayWithArray:list];
        [array addObject:call];
    }else{
        array = [NSMutableArray arrayWithObject:call];;
    }
    NSData *writeData = [NSKeyedArchiver archivedDataWithRootObject:array];
    [writeData writeToFile:CALL_FILE_PATH atomically:YES];
    return YES;
}


- (BOOL)deleteCall:(YYCall *)call
{
    NSArray *list = [self list];
    if (!list) {
        return NO;
    }
    NSMutableArray *array = [NSMutableArray arrayWithArray:list];
    [array removeObject:call];
    NSData *writeData = [NSKeyedArchiver archivedDataWithRootObject:array];
    [writeData writeToFile:CALL_FILE_PATH atomically:YES];
    return YES;
}


- (BOOL)updateCall:(YYCall *)call
{
    NSArray *list = [self list];
    if (!list) {
        return NO;
    }
    NSMutableArray *array = [NSMutableArray arrayWithArray:list];
    if ([array indexOfObject:call] != NSNotFound) {
        [array replaceObjectAtIndex:[array indexOfObject:call] withObject:call];
    }
    NSData *writeData = [NSKeyedArchiver archivedDataWithRootObject:array];
    [writeData writeToFile:CALL_FILE_PATH atomically:YES];
    return YES;
}

- (YYCall *)callOfId:(NSInteger )callId
{
    NSArray *list = [self list];
    if (!list) {
        return nil;
    }
    
    for (YYCall *call in list) {
        if (call.callId == callId) {
            return call;
        }
    }
    return nil;
}
@end
