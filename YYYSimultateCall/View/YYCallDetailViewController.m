//
//  YYCallDetailViewController.m
//  YYYSimultateCall
//
//  Created by YaoMing on 14-5-22.
//  Copyright (c) 2014年 YYY Team. All rights reserved.
//

#import "YYCallDetailViewController.h"
#import "YYCall.h"
#import "YYController.h"
#import "VSViewControllerHolder.h"
#import <AddressBook/AddressBook.h>
@interface YYCallDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSArray *_hourList;
    NSArray *_minuteList;
}
@property (nonatomic,strong)IBOutlet UIPickerView *pickView;
@property (nonatomic,strong)IBOutlet UITableView *tableView;
@property (nonatomic,strong)YYCall *call;

// add, edit
@property (nonatomic,strong)NSString *type;

- (IBAction)saveCall:(id)sender;
- (IBAction)back:(id)sender;
@end

@implementation YYCallDetailViewController


- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        _hourList = @[@"0小时",@"1小时",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24"];
        _minuteList = @[ @"1分钟",@"2分钟",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59"];
        self.call = [[YYCall alloc]init];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        //获取通讯录权限
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveCall:(id)sender
{

    NSInteger hourIndex = [_pickView selectedRowInComponent:0];
    NSInteger mimuteIndex = [_pickView selectedRowInComponent:1]+1;
    _call.timestamp = hourIndex*3600+mimuteIndex*60;
    
    [[YYController shareInstance] addCall:_call];
}


- (IBAction)back:(id)sender
{
    [[YYController shareInstance] back:YES];
}

#pragma mark pick deletegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return [_hourList count];
    }else if(component == 1){
        return [_minuteList count];
    }
    return 0;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return [_hourList objectAtIndex:row];
    }else if(component == 1){
        return [_minuteList objectAtIndex:row];
    }
    return nil;
}


#pragma mark tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if ([_type isEqualToString:@"edit"]) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section==1) {
        return 1;
    }
    return 4;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int index = indexPath.row;
    UITableViewCell *cell ;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"addCell%d",index]];
        
        switch (index) {
            case 0:
                cell.detailTextLabel.text = _call.repeatText;
                break;
            case 1:
                cell.detailTextLabel.text = _call.callName;
                break;
            case 2:
                cell.detailTextLabel.text = _call.callSound;
                break;
            case 3:
                cell.detailTextLabel.text = _call.ringSound;
                break;
            default:
                break;
        }
    }else{
        static NSString *reuseIdetify = @"taleViewCell";
        cell = [tableView dequeueReusableCellWithIdentifier:reuseIdetify];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdetify];

            cell.textLabel.text = @"Delete";
            cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
            cell.textLabel.textColor = [UIColor redColor];
            cell.textLabel.textAlignment = 1;
        }
    }

    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 0) {
        [[YYController shareInstance] deleteCall:_call];
        [[VSViewControllerHolder shareInstance] goBackanimated:YES];
    }
}

//获取通讯录


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation


@end
