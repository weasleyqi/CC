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

@interface ViewController ()<UITabBarDelegate,UITableViewDataSource>
@property (strong, nonatomic) NSDictionary *dataDict;
@property (strong, nonatomic) NSArray *offLineData;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _offLineData = [NSArray arrayWithObjects:@{@"image":@"Scientific Calcuator@2x.png",@"title":@"Scientific Calcuator"},
                                             @{@"image":@"Statistics Calcuator@2x.png",@"title":@"Statistics Calcuator"},
                                             @{@"image":@"Unit-Converter@2x.png",@"title":@"Unit Converter"},
                                             @{@"image":@"Currency-Converter@2x.png",@"title":@"Currency Converter"},
                                             @{@"image":@"Settings-&-About-Us@2x.png",@"title":@"Settings & About Us"},nil];
    // Do any additional setup after loading the view, typically from a nib.
    if ([self CheckNetWorkStatus]) {
        [self loadData];
    }else {
        //load from local
        _dataDict = [DataHandlerTool getDataFromDisk];
        
    }
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
    return 2;
}
//section height
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [_offLineData count];
    }else {
        return 10;
    }
//    return 1;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section ==0) {
        return @"In this App";
    }else{
        return @"Online";
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuCell"];
    if (indexPath.section == 0  ) {
        MenuOffLineCell *offlineCell = [tableView dequeueReusableCellWithIdentifier:@"menuCell"];
        offlineCell.iconImage.image = [UIImage imageNamed:_offLineData[indexPath.row][@"image"]];
        offlineCell.titleLabel.text = _offLineData[indexPath.row][@"title"];
        
        return offlineCell;
    }
    
    
    return cell;
}
@end
