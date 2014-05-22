//
//  YYCallListTableViewController.m
//  YYYSimultateCall
//
//  Created by YaoMing on 14-5-22.
//  Copyright (c) 2014年 YYY Team. All rights reserved.
//

#import "YYCallListTableViewController.h"
#import "YYCallSource.h"
#import "YYCall.h"
#import "YYController.h"
@interface YYCallListTableViewController ()

- (IBAction)editList:(id)sender;
@end

@implementation YYCallListTableViewController
- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listChange:) name:YYCallListChange object:nil];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = YES;

    
   
    // Uncomment the following line to preserve selection between presentations.
    
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (IBAction)editList:(id)sender
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    //设置10秒之后
    NSDate *pushDate = [NSDate dateWithTimeIntervalSinceNow:4];
    if (notification != nil) {
        // 设置推送时间
        notification.fireDate = pushDate;
        // 设置时区
        notification.timeZone = [NSTimeZone defaultTimeZone];
        // 设置重复间隔
        notification.repeatInterval = 0;
        // 推送声音
        notification.soundName = @"1.m4r";
        // 推送内容
        notification.alertBody = @"推送内容";
        
        //显示在icon上的红色圈中的数子
        notification.applicationIconBadgeNumber = 1;
        //设置userinfo 方便在之后需要撤销的时候使用
        NSDictionary *info = [NSDictionary dictionaryWithObject:@"name"forKey:@"key"];
        notification.userInfo = info;
        //添加推送到UIApplication
        UIApplication *app = [UIApplication sharedApplication];
        [app scheduleLocalNotification:notification];
        
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)listChange:(id)notif
{
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[YYCallSource shareInstance] list] count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"callList"];
    NSArray *list = [[YYCallSource shareInstance] list];
    if (!list || [list count] <= 0) {
        return cell;
    }
    
    NSInteger index = indexPath.row;
    if (index >= [list count]) {
        return cell;
    }
    
    YYCall *call =  (YYCall *)[list objectAtIndex:index];
    
    UILabel *timeLabel = (UILabel *)[cell viewWithTag:10];
    timeLabel.text = [NSString stringWithFormat:@"%d之后",(int)(call.timestamp/60)];
    
    UILabel *caller = (UILabel *)[cell viewWithTag:11];
    caller.text = call.callName;
    
    UILabel *callSound = (UILabel *)[cell viewWithTag:12];
    callSound.text = call.callSound;
    
    UILabel *ringSound = (UILabel *)[cell viewWithTag:13];
    ringSound.text = call.ringSound;
    
    UILabel *repeatLabel = (UILabel *)[cell viewWithTag:14];
    repeatLabel.text = call.repeatText;
    
    UISwitch *isOpenSwitch = (UISwitch *)[cell viewWithTag:15];
    [isOpenSwitch setOn:call.isOpen];

    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
