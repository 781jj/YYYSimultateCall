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

@property (nonatomic,strong)IBOutlet UIBarButtonItem *rightItem;
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

}

- (IBAction)editList:(id)sender
{
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    
    if(self.tableView.editing)
    {
        [_rightItem setTitle:@"Done"];
    }
    else
    {
        [_rightItem setTitle:@"Edit"];
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



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
    timeLabel.text = [NSString stringWithFormat:@"%d分钟之后",(int)(call.timestamp/60)];
    
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
    [isOpenSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];


    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return @"删除";
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.row;

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *list = [[YYCallSource shareInstance] list];
        if (index >= [list count]) {
            return ;
        }
        YYCall *call =  (YYCall *)[list objectAtIndex:index];
        [[YYController shareInstance] deleteCall:call];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }

  
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *list = [[YYCallSource shareInstance] list];
    NSInteger index = indexPath.row;
    if (index>= [list count]) {
        return;
    }
    YYCall *call =  (YYCall *)[list objectAtIndex:index];

    [self performSegueWithIdentifier:@"detailCall" sender:call];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"detailCall"]) //"goView2"是SEGUE连线的标识
    {
        id viewController = segue.destinationViewController;
        if ([sender isKindOfClass:[YYCall class]]) {
            [viewController setValue:@"edit" forKey:@"type"];
            [viewController setValue:sender  forKey:@"call"];
        }else{
            [viewController setValue:@"add" forKey:@"type"];
        }
    }
}

#pragma mark switch
- (void)switchAction:(UISwitch *)view
{
    UITableViewCell *cell = (UITableViewCell *)[view superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSArray *list = [[YYCallSource shareInstance] list];
    NSInteger index = indexPath.row;
    if (index >= [list count]) {
        return;
    }
    YYCall *call =  (YYCall *)[list objectAtIndex:index];
    if (view.isOn) {
        call.isOpen  = YES;
        [[YYController shareInstance] editCall:call];
    }else{
        call.isOpen = NO;
        [[YYController shareInstance] editCall:call];

    }
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
