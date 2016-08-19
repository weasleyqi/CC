//
//  ViewController.m
//  Calaulator_Converter
//
//  Created by Weasley Qi on 16/7/10.
//  Copyright © 2016年 Weasley Qi. All rights reserved.
//

#import "ViewController.h"
#import "Reachability.h"
#import "DataHandlerTool.h"
#import "MenuOnLineCell.h"
#import "MenuOffLineCell.h"
#import "MenuSearchCell.h"

@interface ViewController ()<UITabBarDelegate,UITableViewDataSource>
@property (strong, nonatomic) NSDictionary *dataDict;
@property (strong, nonatomic) NSArray *offLineData;
@property (strong, nonatomic) NSMutableArray *pinArray;
@property (strong, nonatomic) NSMutableArray *unpinedArray;

@property (nonatomic) BOOL shouldGo;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pinArray = [NSMutableArray new];
    _unpinedArray = [NSMutableArray new];
    _shouldGo = YES;
    
    _offLineData = [NSArray arrayWithObjects:@{@"image":@"Scientific Calcuator@2x.png",@"title":@"Scientific Calcuator"},
                                             @{@"image":@"Statistics Calcuator@2x.png",@"title":@"Statistics Calcuator"},
                                             @{@"image":@"Unit-Converter@2x.png",@"title":@"Unit Converter"},
                                             @{@"image":@"Currency-Converter@2x.png",@"title":@"Currency Converter"},
                                             @{@"image":@"Settings-&-About-Us@2x.png",@"title":@"Settings & About Us"},nil];
    _dataDict = [DataHandlerTool getDataFromDisk];
    [_unpinedArray addObjectsFromArray:_dataDict[@"Calculators"]];
    [_unpinedArray addObjectsFromArray:_dataDict[@"Converters"]];
    
    if ([self CheckNetWorkStatus]) {
        [self loadData];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    if (!_shouldGo) {
        return;
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *stMenu = [userDefaults stringForKey:@"startMenu"];
    switch ([stMenu intValue]) {
        case 0:
            break;
        case 1:
            [self performSegueWithIdentifier:@"ScientificCalculator" sender:nil];
            break;
        case 2:
            [self performSegueWithIdentifier:@"statisticsCalculator" sender:nil];
            break;
        case 3:
            [self performSegueWithIdentifier:@"unitConverter" sender:nil];
            break;
        case 4:
            [self performSegueWithIdentifier:@"currencyConverter" sender:nil];
            break;
        default:
            break;
    }
    _shouldGo = NO;
}


//Check NetWork Status
- (BOOL)CheckNetWorkStatus {
    BOOL isNetConnected = YES;
    Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
            // No NetWork Connected
            isNetConnected = NO;
            break;
        case ReachableViaWWAN:
            // Use Wan data
            break;
        case ReachableViaWiFi:
            // Use WiFi
            break;
    }
    return isNetConnected;
}

//Load Data from Server
- (void)loadData {
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:@"http://www.calculator.net/api/list.php?source=ios"];
    // 通过URL初始化task,在block内部可以直接对返回的数据进行处理
    NSURLSessionTask *task = [session dataTaskWithURL:url
                                   completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//                                       NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                                       NSString *respString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                       _dataDict = [DataHandlerTool dataHandlerWithResponseString:respString];
                                       [DataHandlerTool saveToDisk:respString];
                                   }];
    // 启动任务
    [task resume];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
//section height
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        return 10;
    }
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return 70;
        }
    }
    return 45;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [_offLineData count];
    }else if(section == 1){
        return 10;
    }else {
        return [_unpinedArray count];
    }
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section ==0) {
        return @"In this App";
    }else if(section == 1){
        return @"Online";
    }else{
        return @"";
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0  ) {
        MenuOffLineCell *offlineCell = [tableView dequeueReusableCellWithIdentifier:@"menuCell"];
        offlineCell.iconImage.image = [UIImage imageNamed:_offLineData[indexPath.row][@"image"]];
        offlineCell.titleLabel.text = _offLineData[indexPath.row][@"title"];
        
        return offlineCell;
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            MenuSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell"];
            return cell;
            
        }else{
            if ([_unpinedArray count] != 0) {
                
                MenuOnLineCell *onlineCell = [tableView dequeueReusableCellWithIdentifier:@"menuCell2"];
                NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",_unpinedArray[indexPath.row+1][@"name"]]];
                NSRange contentRange = {0,[content length]};
                [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
                onlineCell.onLineLabel.attributedText = content;
                
                return onlineCell;
            }else{
                MenuOnLineCell *onlineCell = [tableView dequeueReusableCellWithIdentifier:@"menuCell2"];
                return onlineCell;
            }
        }
    }else{
        MenuOnLineCell *onlineCell = [tableView dequeueReusableCellWithIdentifier:@"menuCell3"];
        NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",_unpinedArray[indexPath.row][@"name"]]];
        NSRange contentRange = {0,[content length]};
        [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
        onlineCell.onLineLabel.attributedText = content;
        return onlineCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                [self performSegueWithIdentifier:@"ScientificCalculator" sender:nil];
                break;
            case 1:
                [self performSegueWithIdentifier:@"statisticsCalculator" sender:nil];
                break;
            case 2:
                [self performSegueWithIdentifier:@"unitConverter" sender:nil];
                break;
            case 3:
                [self performSegueWithIdentifier:@"currencyConverter" sender:nil];
                break;
            case 4:
                [self performSegueWithIdentifier:@"settings" sender:nil];
                break;
            default:
                break;
        }
    }else if (indexPath.section == 1) {
        
    }else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_unpinedArray[indexPath.row][@"url"]]];
    }
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}

//search button
- (IBAction)searchCC:(id)sender {
//    [_searchText resignFirstResponder];
    
}

@end
