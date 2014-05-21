//
//  YYCall.h
//  YYYSimultateCall
//
//  Created by YaoMing on 14-5-21.
//  Copyright (c) 2014年 YYY Team. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    YYNoRepeat = 0,
    YYThreeMinuteRepeat = 3,
    YYFiveMinuteRepeat = 5,
    YYTenMinuteRepeat = 10,
    YYQuarterHourRepeat = 15,
    YYHalfHourRepeat = 30,
    YYThreeQuartersHourRepeat = 45,
    YYHourRepeat = 60,
    YYTwoHoursRepeat = 120,
}YYCallRepeatType;

@interface YYCall : NSObject


@property (nonatomic,assign,readonly)NSInteger callId;
@property (nonatomic,assign)NSInteger timestamp;
@property (nonatomic,strong)NSString *callName;
@property (nonatomic,strong)NSString *callSound;
@property (nonatomic,strong)NSString *ringSound;

//repeatIntrval 单位分钟,为0表示不重复
@property (nonatomic,assign)YYCallRepeatType repeatType;
@property (nonatomic,assign)BOOL isOpen;





@end
