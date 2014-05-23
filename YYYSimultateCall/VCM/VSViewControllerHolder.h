//
//  VSViewControllerHolder.h
//  Weimei
//
//  Created by Xiang on 14-4-3.
//  Copyright (c) 2014年 Vip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    VSViewControllerPushModel = 0,
    VSViewControllerPresenteModel = 1
}VSViewControllerAnimationModel;
@interface VSViewControllerHolder : NSObject
@property(strong,nonatomic)NSMutableArray *viewControllers;

+(instancetype)shareInstance;

-(void)addViewController:(UIViewController*)viewCtrol;

-(void)removeAllViewController;

-(void)deleteFromViewControlView:(UIViewController*)viewCtrol;

-(void)deleteToViewControlView:(UIViewController*)viewCtrol;


#pragma mark - user methodes

-(void)goBackanimated:(BOOL)animated;

-(BOOL)isFromViewController:(NSString*)className;

-(void)goBackTo:(NSString*)className animated:(BOOL)animated;

- (void)goTo:(NSString *)className  model:(VSViewControllerAnimationModel)model animated:(BOOL)animated;

-(UIViewController*)getCurrentViewController;

-(UIViewController*)getViewControllerbyClassName:(NSString*)className;

@end
