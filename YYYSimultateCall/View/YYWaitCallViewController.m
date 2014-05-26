//
//  YYWaitCallViewController.m
//  YYYSimultateCall
//
//  Created by YaoMing on 14-5-26.
//  Copyright (c) 2014年 YYY Team. All rights reserved.
//

#import "YYWaitCallViewController.h"
#import "VSViewControllerHolder.h"
@interface YYWaitCallViewController ()


- (void)back:(id)sender;
@end

@implementation YYWaitCallViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)back:(id)sender
{
    [[VSViewControllerHolder shareInstance] goBackanimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
