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

@interface ViewController ()<UITabBarDelegate,UITableViewDataSource>
@property (strong, nonatomic) NSDictionary *dataDict;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (section == 0) {
//        return 1;
//    }
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuCell"];
    if (indexPath.section == 1  ) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"menuCell2"];
    }
    
    
    return cell;
}
@end
