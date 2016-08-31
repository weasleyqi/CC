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
#import "Constant.h"

@interface ViewController ()<UITabBarDelegate,UITableViewDataSource,pinUnpinChangeDelegate,UITextFieldDelegate,SearchCellDelegate>
@property (strong, nonatomic) NSDictionary *dataDict;
@property (strong, nonatomic) NSArray *offLineData;
@property (strong, nonatomic) NSMutableArray *pinArray;
@property (strong, nonatomic) NSMutableArray *unpinedArray;
@property (strong, nonatomic) NSMutableArray *allDataArray;
@property (strong, nonatomic) NSMutableArray *beforeSearchArray;
@property (strong, nonatomic) NSMutableArray *searchResultArray;
@property (weak, nonatomic) IBOutlet UITableView *menuTableView;

@property (nonatomic) BOOL shouldGo;
@property (nonatomic) MenuSearchCell *searchCell;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pinArray = [NSMutableArray new];
    _unpinedArray = [NSMutableArray new];
    _allDataArray = [NSMutableArray new];
    _beforeSearchArray = [NSMutableArray new];
    _searchResultArray = [NSMutableArray new];
    _shouldGo = YES;
    
    _offLineData = [NSArray arrayWithObjects:@{@"image":@"Scientific Calcuator@2x.png",@"title":@"Scientific Calcuator"},
                                             @{@"image":@"Statistics Calcuator@2x.png",@"title":@"Statistics Calcuator"},
                                             @{@"image":@"Unit-Converter@2x.png",@"title":@"Unit Converter"},
                                             @{@"image":@"Currency-Converter@2x.png",@"title":@"Currency Converter"},
                                             @{@"image":@"Settings-&-About-Us@2x.png",@"title":@"Settings & About Us"},nil];
    _dataDict = [DataHandlerTool getDataFromDisk];
    [_unpinedArray addObjectsFromArray:_dataDict[@"Calculators"]];
    [_unpinedArray addObjectsFromArray:_dataDict[@"Converters"]];
    
    _beforeSearchArray = [_unpinedArray mutableCopy];
    _allDataArray = [_unpinedArray mutableCopy];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *tempArray = [NSMutableArray new];
    tempArray = [[userDefaults arrayForKey:@"unpined"] mutableCopy];
    NSMutableArray *temp2 = [[userDefaults arrayForKey:@"pined"] mutableCopy];
    if ([tempArray count]) {
        _unpinedArray = [tempArray mutableCopy];
        _pinArray = [temp2 mutableCopy];
    }else{
        NSLog(@"no data stored");
    }
    
    if ([self CheckNetWorkStatus]) {
        [self loadData];
    }
    
    _searchCell = [_menuTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    [_searchCell.menuSearchTextField addTarget:self action:@selector(valueChaged:) forControlEvents:UIControlEventEditingChanged];
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
                                       [self reloadTableView];
                                   }];
    // 启动任务
    [task resume];
    
}

- (void)reloadTableView{
    _dataDict = [DataHandlerTool getDataFromDisk];
    _unpinedArray = [NSMutableArray new];
    [_unpinedArray addObjectsFromArray:_dataDict[@"Calculators"]];
    [_unpinedArray addObjectsFromArray:_dataDict[@"Converters"]];
    
    _beforeSearchArray = [_unpinedArray mutableCopy];
    _allDataArray = [_unpinedArray mutableCopy];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *tempArray = [NSMutableArray new];
    tempArray = [[userDefaults arrayForKey:@"unpined"] mutableCopy];
    NSMutableArray *temp2 = [[userDefaults arrayForKey:@"pined"] mutableCopy];
    if ([tempArray count]) {
        _unpinedArray = [tempArray mutableCopy];
        _pinArray = [temp2 mutableCopy];
    }else{
        NSLog(@"no data stored");
    }
    
    [_menuTableView reloadData];
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
        return [_pinArray count] + 1;
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
            cell.delegate = self;
            cell.menuSearchTextField.delegate = self;
            return cell;
            
        }else{
            if ([_pinArray count] != 0) {
                
                MenuOnLineCell *onlineCell = [tableView dequeueReusableCellWithIdentifier:@"menuCell2"];
                NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",_pinArray[indexPath.row-1][@"name"]]];
                NSRange contentRange = {0,[content length]};
                [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
                onlineCell.onLineLabel.attributedText = content;
                onlineCell.delegate = self;
                onlineCell.statusBtn.tag = 1000 + indexPath.row-1;
                return onlineCell;
            }else{
                MenuOnLineCell *onlineCell = [tableView dequeueReusableCellWithIdentifier:@"menuCell2"];
                return onlineCell;
            }
        }
    }else{
        if ([_unpinedArray count] > 0) {
            MenuOnLineCell *onlineCell = [tableView dequeueReusableCellWithIdentifier:@"menuCell3"];
            NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",_unpinedArray[indexPath.row][@"name"]]];
            NSRange contentRange = {0,[content length]};
            [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
            onlineCell.onLineLabel.attributedText = content;
            onlineCell.delegate = self;
            onlineCell.statusBtn.tag = 2000 + indexPath.row;
            onlineCell.backgroundColor = [UIColor whiteColor];
            if ([_unpinedArray[indexPath.row][@"kind"] isEqualToString:@"1"]) {
                onlineCell.backgroundColor = UIColorFromRGB(0xEDEB98, 1);
            }
            return onlineCell;
        }else{
            MenuOnLineCell *onlineCell = [tableView dequeueReusableCellWithIdentifier:@"menuCell3"];
            return onlineCell;
        }
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
        if (indexPath.row == 0) {
            
        }else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_pinArray[indexPath.row-1][@"url"]]];
        }
    }else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_unpinedArray[indexPath.row][@"url"]]];
    }
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}

//search button
- (IBAction)searchCC:(id)sender {
//    [_searchText resignFirstResponder];
    
}

- (void)changeStatus:(UIButton *)sender {
    if (sender.tag >= 2000) {//unpin -> pin
        [_pinArray addObject:_unpinedArray[sender.tag-2000]];
        [_unpinedArray removeObjectAtIndex:(sender.tag -2000)];
        [_menuTableView reloadData];
    }else if (sender.tag >= 1000) {//pin -> unpin
        [_pinArray removeObjectAtIndex:(sender.tag-1000)];
        [self unpinarryModify];
        [_menuTableView reloadData];
    }
    _beforeSearchArray = [_unpinedArray mutableCopy];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:_pinArray forKey:@"pined"];
    [userDefaults setObject:_unpinedArray forKey:@"unpined"];
}

- (void)unpinarryModify{
    [_pinArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [_allDataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj2, NSUInteger idx2, BOOL * _Nonnull stop2) {
            if ([obj2[@"name"] isEqualToString:obj[@"name"]]) {
                NSLog(@"remove name %@",obj[@"name"]);
                [_allDataArray removeObjectAtIndex:idx2];
            }
        }];
    }];
    [_unpinedArray removeAllObjects];
    _unpinedArray = [_allDataArray mutableCopy];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    
    MenuSearchCell *cell = [_menuTableView cellForRowAtIndexPath:indexPath];
    [cell.menuSearchTextField resignFirstResponder];
    if ([cell.menuSearchTextField.text length] <=0) {
        _unpinedArray = [_beforeSearchArray mutableCopy];
        [_menuTableView reloadData];
        return YES;
    }
    [self searchInArray:cell.menuSearchTextField.text];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (_searchCell == nil) {
        _searchCell = [_menuTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    }
    
    if ([_searchCell.menuSearchTextField.text length]+ [string length] <= 0) {
        _unpinedArray = [_beforeSearchArray mutableCopy];
        [_menuTableView reloadSections:[[NSIndexSet alloc] initWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
        return YES;
    }
    
    NSString *resultingString = [textField.text stringByReplacingCharactersInRange: range withString: string];
    [self searchInArray:resultingString];
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
    
    [_menuTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    [_searchCell.menuSearchTextField becomeFirstResponder];
    return YES;
}


- (void)searchAction:(UIButton *)sender {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    
    MenuSearchCell *cell = [_menuTableView cellForRowAtIndexPath:indexPath];
    [cell.menuSearchTextField resignFirstResponder];
    if ([cell.menuSearchTextField.text length] <=0) {
        _unpinedArray = [_beforeSearchArray mutableCopy];
        [_menuTableView reloadData];
        return;
    }
    [self searchInArray:cell.menuSearchTextField.text];
}



- (void)searchInArray:(NSString *)str {
    NSLog(@"search text %@",str);
    if (str.length == 0) {
        _unpinedArray = [_beforeSearchArray mutableCopy];
        [_menuTableView reloadSections:[[NSIndexSet alloc] initWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
        return;
    }
    [_searchResultArray removeAllObjects];
    [_beforeSearchArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj[@"name"] rangeOfString:str].location != NSNotFound) {
            [_searchResultArray addObject:obj];
        }
    }];
    _unpinedArray = [_searchResultArray mutableCopy];
}
@end
