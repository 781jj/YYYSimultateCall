//
//  VSNavigationController.m
//  Weimei
//
//  Created by Xiang on 14-4-3.
//  Copyright (c) 2014年 Vip. All rights reserved.
//

#import "VSNavigationController.h"
#import "VSViewControllerHolder.h"
#import <objc/runtime.h>



static const char *interceptor = "interceptor";

@interface Interceptor:NSObject {
    
}
@property (nonatomic,assign) id <UINavigationControllerDelegate> receiver;
@property (nonatomic,assign) UINavigationController *navigationController;
@end


@implementation Interceptor

//快速转发函数，在此实现函数拦截，实现自己功能后再转发给原代理
- (id)forwardingTargetForSelector:(SEL)aSelector {
    NSString *selectorName = NSStringFromSelector(aSelector);
    
    if ([selectorName isEqualToString:NSStringFromSelector(@selector(navigationController:didShowViewController:animated:))]) {
        [self removeViewController];
    }
    
    if ([self.receiver respondsToSelector:aSelector]) {
        return self.receiver;
    }
    if ([self.navigationController respondsToSelector:aSelector]) {
        return self.navigationController;
    }
    return [super forwardingTargetForSelector:aSelector];
}

-(void)removeViewController
{
    if ([self.navigationController.isPop isEqualToString:@"YES"]) {
        UIViewController *lastViewController = [[VSViewControllerHolder shareInstance].viewControllers lastObject];
        [[VSViewControllerHolder shareInstance] deleteFromViewControlView:lastViewController];
        self.navigationController.isPop = @"NO";
    }
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    if ([self.receiver respondsToSelector:aSelector]) {
        return YES;
    }
    if ([self.navigationController respondsToSelector:aSelector]) {
        return YES;
    }
    return [super respondsToSelector:aSelector];
}

@end



@interface UINavigationController (Private)

@property (strong,nonatomic) Interceptor *interceptor;

@end

@implementation UINavigationController (Private)
@dynamic interceptor;

- (void)setInterceptor:(id)messageInterceptor {
    //使用associative来扩展属性
    objc_setAssociatedObject(self, &interceptor, messageInterceptor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)interceptor {
    //获取属性
    return objc_getAssociatedObject(self, &interceptor);
}

@end

static const void *popKey = &popKey;

@implementation UINavigationController(VSNavigationController)
@dynamic isPop;

#pragma mark -

- (NSString*)isPop {
    return objc_getAssociatedObject(self, popKey);
}

- (void)setIsPop:(NSString*)pop{
    objc_setAssociatedObject(self, popKey, pop, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)setNavDelegate:(id<UINavigationControllerDelegate>)delegate{
    Interceptor *tmpInterceptor = [[Interceptor alloc] init];
    self.interceptor = tmpInterceptor;
    self.interceptor.navigationController = self;
    self.interceptor.receiver = delegate;
    [self setNavDelegate:(id)self.interceptor];
}


- (void)pushVSViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [self pushVSViewController:viewController animated:animated];
    [[VSViewControllerHolder shareInstance] addViewController:viewController];
}

- (UIViewController *)popVSViewControllerAnimated:(BOOL)animated{
    self.isPop = @"YES";
    UIViewController *viewController = [self popVSViewControllerAnimated:animated];
    return viewController;
}

- (NSArray *)popToVSViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [[VSViewControllerHolder shareInstance] deleteToViewControlView:viewController];
    return [self popToVSViewController:viewController animated:animated];
}

- (NSArray *)popToRootVSViewControllerAnimated:(BOOL)animated{
    [[VSViewControllerHolder shareInstance] deleteToViewControlView:[self viewControllers][0]];
    return [self popToRootVSViewControllerAnimated:animated];
}

- (id)initWithRootVSViewController:(UIViewController *)rootViewController{
//    [[VSViewControllerHolder shareInstance] addViewController:rootViewController];
    [self setDelegate:nil];
    return [self initWithRootVSViewController:rootViewController];
}

#pragma mark - delegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{

}

@end
