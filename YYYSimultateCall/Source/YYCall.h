//
//  YYCall.h
//  YYYSimultateCall
//
//  Created by YaoMing on 14-5-21.
//  Copyright (c) 2014年 YYY Team. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    YYThreeMinuteRepeat = 0,
    YYFiveMinuteRepeat = 1,
    YYTenMinuteRepeat = 2,
    YYQuarterHourRepeat = 3,
    YYHalfHourRepeat = 4,
    YYThreeQuartersHourRepeat = 5,
    YYHourRepeat = 6,
    YYTwoHoursRepeat = 7,
}YYCallRepeatType;

@interface YYCall : NSObject


@property (nonatomic,assign,readonly)NSInteger callId;
@property (nonatomic,assign)NSInteger timestamp;
@property (nonatomic,strong)NSString *callName;
@property (nonatomic,strong)NSString *callSound;
@property (nonatomic,strong)NSString *ringSound;

//repeatIntrval 单位分钟,为0表示不重复
@property (nonatomic,assign)YYCallRepeatType repeatIntrvalMinute;
@property (nonatomic,assign)BOOL isOpen;





@end
