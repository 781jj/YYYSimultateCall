//
//  YYContactListTableViewController.m
//  YYYSimultateCall
//
//  Created by YaoMing on 14-5-23.
//  Copyright (c) 2014年 YYY Team. All rights reserved.
//

#import "YYContactListTableViewController.h"
#import <AddressBook/AddressBook.h>
#import "YYController.h"

@interface YYContactListTableViewController ()
{
    NSInteger _selectedRow;
}
@property (nonatomic,strong)NSMutableArray *contactList;
- (IBAction)back:(id)sender;

@end

@implementation YYContactListTableViewController

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        self.contactList = [[NSMutableArray alloc] init];
        _selectedRow = -1;
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    ABAddressBookRef ab = NULL;
    // ABAddressBookCreateWithOptions is iOS 6 and up.
    if (&ABAddressBookCreateWithOptions) {
        CFErrorRef error = nil;
        ab = ABAddressBookCreateWithOptions(NULL, &error);
        
        if (error) { NSLog(@"%@", error); }
    }
    if (ab == NULL) {
        ab = ABAddressBookCreate();
    }
    if (ab) {
        // ABAddressBookRequestAccessWithCompletion is iOS 6 and up. 适配IOS6以上版本
        if (&ABAddressBookRequestAccessWithCompletion) {
            ABAddressBookRequestAccessWithCompletion(ab,
                                                     ^(bool granted, CFErrorRef error) {
                                                         if (granted) {
                                                             // constructInThread: will CFRelease ab.
                                                             [self constructInThread:(__bridge ABAddressBookRef)(CFBridgingRelease(ab)) ];
                                                             
                                                         } else {
                                                             //                                                             CFRelease(ab);
                                                             // Ignore the error
                                                         }
                                                     });
        } else {
            // constructInThread: will CFRelease ab.
            [self constructInThread:(__bridge ABAddressBookRef)(CFBridgingRelease(ab)) ];
            
        }
    }
}



-(void)constructInThread:(ABAddressBookRef) ab
{
    NSLog(@"we got the access right");
    CFArrayRef results = ABAddressBookCopyArrayOfAllPeople(ab);
    NSMutableArray* contactArray = [[NSMutableArray alloc]init];
    for(int i = 0; i < CFArrayGetCount(results); i++)
    {
        ABRecordRef person = CFArrayGetValueAtIndex(results, i);
        NSString *firstName = (NSString*)CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNameProperty));
        NSString *lastname = (NSString*)CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty));
        NSString *name = @"无名字";
        if (firstName) {
            if (lastname) {
                name  = [NSString stringWithFormat:@"%@ %@",firstName,lastname];
            }else{
                name  = [NSString stringWithFormat:@"%@",firstName];
            }
        }else{
            if (lastname) {
                name  = [NSString stringWithFormat:@"%@",lastname];
            }
        }
        //读取电话多值
        NSString *phone = (NSString*)CFBridgingRelease(ABRecordCopyValue(person, kABPersonPhoneProperty));
        [_contactList addObject:@{@"name": name,@"phone":phone}];
    }
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)back:(id)sender
{
    [[YYController shareInstance] back:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [_contactList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactCell"];
    
    int index = indexPath.row;
    if (index>= [_contactList count]) {
        return cell;
    }
    
    if (_selectedRow == index){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    NSDictionary *dic = [_contactList objectAtIndex:index];
    NSString *name = [dic objectForKey:@"name"];
    cell.textLabel.text = name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectedRow!=-1) {
        NSIndexPath *path  = [NSIndexPath indexPathForRow:_selectedRow inSection:0];
        UITableViewCell *cell0 = [tableView cellForRowAtIndexPath:path];
        cell0.accessoryType = UITableViewCellAccessoryNone;
    }

    
    UITableViewCell *cell1 = [tableView cellForRowAtIndexPath:indexPath];
    cell1.accessoryType = UITableViewCellAccessoryCheckmark;
    _selectedRow = indexPath.row;
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
