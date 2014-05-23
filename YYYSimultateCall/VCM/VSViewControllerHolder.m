//
//  VSViewControllerHolder.m
//  Weimei
//
//  Created by Xiang on 14-4-3.
//  Copyright (c) 2014年 Vip. All rights reserved.
//

#import "VSViewControllerHolder.h"
#import "VSViewController.h"
#import "VSWindow.h"
#import <objc/runtime.h>



static VSViewControllerHolder *_holer = nil;


@interface VSViewControllerHolder()

@end

@implementation VSViewControllerHolder

+(instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (nil == _holer) {
            _holer = [[VSViewControllerHolder alloc] init];
        }
    });
    return _holer;
}

- (void)replaceClass:(Class)className newSEL:(SEL)newSEL origSEL:(SEL)origSEL
{
    Method orig = class_getInstanceMethod(className, origSEL);
    Method new = class_getInstanceMethod(className, newSEL);
    if(class_addMethod(className, origSEL, method_getImplementation(new), method_getTypeEncoding(new)))
    {
        class_replaceMethod(className, newSEL, method_getImplementation(orig), method_getTypeEncoding(orig));
    }
    else
    {
        method_exchangeImplementations(orig, new);
    }
}


- (id)init{
    self = [super init];
    if (self) {
      
        [self replaceClass:[UIViewController class] newSEL:@selector(presentVSViewController:animated:completion:) origSEL:@selector(presentViewController:animated:completion:)];
        [self replaceClass:[UIViewController class] newSEL:@selector(presentVSModalViewController:animated:) origSEL:@selector(presentModalViewController:animated:)];
        [self replaceClass:[UIViewController class] newSEL:@selector(dismissVSViewControllerAnimated:completion:) origSEL:@selector(dismissViewControllerAnimated:completion:)];
        [self replaceClass:[UIViewController class] newSEL:@selector(dismissVSModalViewControllerAnimated:) origSEL:@selector(dismissModalViewControllerAnimated:)];

        [self replaceClass:[UIWindow class] newSEL:@selector(setVSRootViewController:) origSEL:@selector(setRootViewController:)];

        
        _viewControllers = [NSMutableArray array];
    }
    return self;
}

#pragma mark - 视图流转

-(BOOL)isFromViewController:(NSString*)className{
    
    for (int i = 0; i<_viewControllers.count; i++) {
        UIViewController *viewController = _viewControllers[i];
        if ([viewController isKindOfClass:[UINavigationController class]]) {
            for (UIViewController *v in ((UINavigationController*)viewController).viewControllers) {
                if ([NSStringFromClass([v class]) isEqualToString:className]) {
                    return YES;
                }
            }
        }else if ([NSStringFromClass([viewController class]) isEqualToString:className]) {
            return YES;
        }
    }
    return NO;
}

-(void)addViewController:(UIViewController*)viewCtrol{
    if (![_viewControllers containsObject:viewCtrol]) {
        [_viewControllers addObject:viewCtrol];
    }
}

-(void)removeAllViewController{
    [_viewControllers removeAllObjects];
}

-(void)goBackanimated:(BOOL)animated{

    if ([[_viewControllers lastObject] isKindOfClass:[UINavigationController class]]) {
        UINavigationController *current = (UINavigationController*)[_viewControllers lastObject];
        if (current.viewControllers.count > 1) {
            [current popViewControllerAnimated:animated];
        }else{
            [current dismissViewControllerAnimated:animated completion:nil];
        }
    }else{
        [[_viewControllers lastObject] dismissViewControllerAnimated:animated completion:nil];
    }
}

-(void)goBackTo:(NSString*)className animated:(BOOL)animated{
    
   for (int i = _viewControllers.count-1;i>=0;i--) {
        UIViewController *viewController = _viewControllers[i];
       if ([_viewControllers[i] isKindOfClass:[UINavigationController class]]) {
           UINavigationController *nav = (UINavigationController*)_viewControllers[i];
           for (UIViewController *v in nav.viewControllers) {
               if ([NSStringFromClass([v class]) isEqualToString:className]){
                   [nav popToViewController:v animated:animated];
                   break;
               }
           }
       }else if ([NSStringFromClass([viewController class]) isEqualToString:className]){
           [viewController dismissViewControllerAnimated:animated completion:nil];
           break;
       }
   }
}

- (void)goTo:(NSString *)className  model:(VSViewControllerAnimationModel)model animated:(BOOL)animated
{
    UIViewController *current = [_viewControllers lastObject];
    
    UIViewController *controller = [[NSClassFromString(className) alloc] init];
    if ([current isKindOfClass:[UINavigationController class]]&& model == VSViewControllerPushModel) {
        [(UINavigationController*)current pushViewController:controller animated:animated];
    }else{
        [current presentViewController:controller animated:animated completion:nil];
    }
}

//viewCtrol被移除
-(void)deleteFromViewControlView:(UIViewController*)viewCtrol{
    int i = _viewControllers.count-1;
    BOOL    found = NO;
    for (;i>=0;i--) {
        UIViewController *viewController = _viewControllers[i];
        if (viewController == viewCtrol) {
            found = YES;
            break;
        }
    }
    if (found) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:_viewControllers];
        [_viewControllers removeObjectsInRange:NSMakeRange(i, _viewControllers.count-i)];
        [array removeObjectsInArray:_viewControllers];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"VIEWCONTROLLERREMOVE" object:array];
    }
}

//viewCtrol位于最上层(自己保留)
-(void)deleteToViewControlView:(UIViewController*)viewCtrol{
    int i = _viewControllers.count-1;
    BOOL    found = NO;
    for (;i>=0;i--) {
        UIViewController *viewController = _viewControllers[i];
        if (viewController == viewCtrol) {
            found = YES;
            break;
        }
    }
    if (found) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:_viewControllers];
        [_viewControllers removeObjectsInRange:NSMakeRange(i+1, _viewControllers.count-i-1)];
        [array removeObjectsInArray:_viewControllers];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"VIEWCONTROLLERREMOVE" object:array];
    }
}

-(UIViewController*)getCurrentViewController{
    UIViewController *vc = [_viewControllers lastObject];
    if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController*)vc;
        return nav.topViewController;
    }
    return vc;
}

-(UIViewController*)getViewControllerbyClassName:(NSString*)className{
    int i = _viewControllers.count-1;
    for (;i>=0;i--) {
        UIViewController *viewController = _viewControllers[i];
        if ([viewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nav = (UINavigationController*)viewController;
            for (UIViewController *v in nav.viewControllers) {
                if ([v isKindOfClass:NSClassFromString(className)]) {
                    return v;
                }
            }
        }else if([viewController isKindOfClass:NSClassFromString(className)]) {
            return viewController;
        }
    }
    return nil;
}

@end
