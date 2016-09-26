//
//  CurrencyConverterViewController.m
//  Calaulator_Converter
//
//  Created by Weasley Qi on 16/7/14.
//  Copyright © 2016年 Weasley Qi. All rights reserved.
//

#import "CurrencyConverterViewController.h"
#import "MBLabelWithFontAdapter.h"
#import "DataHandlerTool.h"
#import "MobileData.h"

@interface CurrencyConverterViewController (){
    
}
@property (strong, nonatomic) NSString *tempStr;
@property (weak, nonatomic) IBOutlet MBLabelWithFontAdapter *showText;
@property (strong, nonatomic) NSDictionary *currencyDict;
@property (strong, nonatomic) NSMutableArray *currencyArray;

@property (strong, nonatomic) NSMutableArray *selectShowArray;
@property (strong, nonatomic) NSMutableArray *pickShowArray;

@property (strong, nonatomic) NSMutableArray *majorDataArray;
@property (strong, nonatomic) NSMutableArray *majorSelectArray;
@property (strong, nonatomic) NSMutableArray *majorPickArray;

@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet UIView *pickAreaView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickView;
@property (weak, nonatomic) IBOutlet UISwitch *majorSwitch;

@property (weak, nonatomic) IBOutlet UIView *fromExView;
@property (weak, nonatomic) IBOutlet UIView *toExView;
@property (weak, nonatomic) IBOutlet UILabel *fromExLabel;
@property (weak, nonatomic) IBOutlet UILabel *toExLabel;
@property (weak, nonatomic) IBOutlet MBLabelWithFontAdapter *fromShowLabel;
@property (weak, nonatomic) IBOutlet MBLabelWithFontAdapter *toShowLabel;
@property (weak, nonatomic) IBOutlet MBLabelWithFontAdapter *fromValueLabel;
@property (weak, nonatomic) IBOutlet MBLabelWithFontAdapter *toValueLabel;

@property (nonatomic) NSInteger fromSelectedIndex;
@property (nonatomic) NSInteger toSelectedIndex;

@property (strong, nonatomic) NSString *timestamp;
@property (weak, nonatomic) IBOutlet MBLabelWithFontAdapter *timestampLabel;

@end

@implementation CurrencyConverterViewController
@synthesize tempStr,showText;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _selectShowArray = [NSMutableArray new];
    _pickShowArray = [NSMutableArray new];
    _currencyArray = [NSMutableArray new];
    _majorDataArray = [NSMutableArray new];
    _majorSelectArray = [NSMutableArray new];
    _majorPickArray = [NSMutableArray new];
    
    _currencyDict = [[DataHandlerTool getDataFromDisk] objectForKey:@"Exchange Rates"];;
    _timestamp = _currencyDict[@"timestamp"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[_timestamp longLongValue]];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:confromTimesp];
    _timestampLabel.text = [NSString stringWithFormat:@"Exchage Rate Updated at:%@",currentDateStr];
    NSArray *majorArray = @[@"AUD",@"BRL",@"CAD",@"CHF",@"CNY",@"EUR",@"GBP",@"HKD",@"INR",@"JPY",@"KRW",@"MXN",@"RUB",@"SGD",@"USD",@"ZAR"];
    _currencyArray = _currencyDict[@"rates"];
    [_currencyArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [_selectShowArray addObject:obj[@"shortName"]];
        [_pickShowArray addObject:[[obj[@"shortName"] stringByAppendingString:@":"] stringByAppendingString:obj[@"fullName"]]];
        [majorArray enumerateObjectsUsingBlock:^(id  _Nonnull obj2, NSUInteger idx, BOOL * _Nonnull stop) {
            if([obj2 isEqualToString:obj[@"shortName"]]) {
                [_majorDataArray addObject:obj];
                [_majorSelectArray addObject:obj[@"shortName"]];
                [_majorPickArray addObject:[[obj[@"shortName"] stringByAppendingString:@":"] stringByAppendingString:obj[@"fullName"]]];
            }
        }];
    }];
    
    UITapGestureRecognizer *gesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taptap:)];
    _fromExView.tag = 1;
    [_fromExView addGestureRecognizer:gesture1];
    
    UITapGestureRecognizer *gesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taptap:)];
    _toExView.tag = 2;
    [_toExView addGestureRecognizer:gesture2];
    
    UITapGestureRecognizer *gesture3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taptap:)];
    _coverView.tag = 3;
    [_coverView addGestureRecognizer:gesture3];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL isM = [userDefaults boolForKey:@"major"];
    if (isM) {
        _fromExLabel.text = @"USD";
        _toExLabel.text = @"EUR";
        [_majorSelectArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isEqualToString:@"USD"]) {
                _fromSelectedIndex = idx;
            }
            if ([obj isEqualToString:@"EUR"]) {
                _toSelectedIndex = idx;
            }
        }];
        _majorSwitch.on = YES;
    }else {
        _fromExLabel.text = @"USD";
        _toExLabel.text = @"EUR";
        [_selectShowArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isEqualToString:@"USD"]) {
                _fromSelectedIndex = idx;
            }
            if ([obj isEqualToString:@"EUR"]) {
                _toSelectedIndex = idx;
            }
        }];
        _majorSwitch.on = NO;
    }
    _fromShowLabel.text = _fromExLabel.text;
    _toShowLabel.text = _toExLabel.text;
    tempStr = @"0";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)inputNumbers:(id)sender {
    [MobileData checkSettings];
    if ([tempStr hasPrefix:@"0"] && [sender tag] > 0 && [sender tag] <10 && ![tempStr hasPrefix:@"0."]) {
        tempStr = @"";
    } else if ([tempStr hasPrefix:@"0"] && [sender tag] == 0 && ![tempStr hasPrefix:@"0."]) {
        //如果是以0开头，但是不是以0.开头，则直接返回
        return;
    }
    
    //处理小数点的问题
    //如果小数点是第一输入的数字
    if ([sender tag] == 10 && tempStr.length == 0) {
        tempStr = @"0";
    }
    //每输入一次，拼接一次字符串
    
    if([sender tag] == 10 ) { //取小数点
        //小数点只允许输入一次
        //遍历字符串tempStr，如果有小数点，则直接return
        for (int i = 0; i < tempStr.length ; i++) {
            char c = [tempStr characterAtIndex:i];
            if (c == '.') {
                return;
            }
        }
        tempStr = [tempStr stringByAppendingString:@"."];
    }else {
        tempStr = [tempStr stringByAppendingString:[NSString stringWithFormat:@"%ld",[sender tag]]];
    }
    showText.text = tempStr;
    [self resultGet:nil];
}
- (IBAction)resultGet:(id)sender {
    if (_majorSwitch.isOn) {
        double result = [showText.text doubleValue] * [_majorDataArray[_toSelectedIndex][@"value"] doubleValue] / [_majorDataArray[_fromSelectedIndex][@"value"] doubleValue] ;
        _fromValueLabel.text = showText.text;
        _toValueLabel.text = [NSString stringWithFormat:@"%g",result];
    }else {
        double result = [showText.text doubleValue] * [_currencyArray[_toSelectedIndex][@"value"] doubleValue] / [_currencyArray[_fromSelectedIndex][@"value"] doubleValue] ;
        _fromValueLabel.text = showText.text;
        _toValueLabel.text = [NSString stringWithFormat:@"%g",result];
    }
}

- (IBAction)simpleCalculate:(UIButton *)sender {
    switch (sender.tag) {
        case 11://+-
            showText.text = [NSString stringWithFormat:@"%g",[showText.text doubleValue]*(-1)];
            break;
            
        case 12://exp
            
            break;
            
        case 13://c
            showText.text = @"0";
            tempStr = @"0";
            _fromValueLabel.text = @"0";
            _toValueLabel.text = @"0";
            break;
        case 14://go
            [self resultGet:nil];
            break;
            
        default:
            break;
    }
}

//taptap
- (void)taptap:(UITapGestureRecognizer *)gesture {
    if (gesture.view.tag == 3) {
        _coverView.hidden = YES;
        _pickAreaView.hidden = YES;
        return;
    }
    _pickAreaView.hidden = NO;
    _pickView.tag = gesture.view.tag;
    [_pickView reloadAllComponents];
    _coverView.hidden = NO;
}

//pickView
//UIPickView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (_majorSwitch.on) {
        return [_majorDataArray count];
    }else {
        return [_currencyArray count];
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (_majorSwitch.isOn) {
        return _majorPickArray[row];
    }else {
        return _pickShowArray[row];
    }
}

- (IBAction)pickSelected:(id)sender {
    if (_pickView.tag == 1) {//from
        if (_majorSwitch.isOn) {
            _fromExLabel.text = _majorSelectArray[[_pickView selectedRowInComponent:0]];
            _fromSelectedIndex= [_pickView selectedRowInComponent:0];
        }else {
            _fromExLabel.text = _selectShowArray[[_pickView selectedRowInComponent:0]];
            _fromSelectedIndex= [_pickView selectedRowInComponent:0];
        }
    }else if (_pickView.tag == 2) {//to
        if (_majorSwitch.isOn) {
            _toExLabel.text = _majorSelectArray[[_pickView selectedRowInComponent:0]];
            _toSelectedIndex= [_pickView selectedRowInComponent:0];
        }else {
            _toExLabel.text = _selectShowArray[[_pickView selectedRowInComponent:0]];
            _toSelectedIndex= [_pickView selectedRowInComponent:0];
        }
    }
    _fromShowLabel.text = _fromExLabel.text;
    _toShowLabel.text = _toExLabel.text;
    _pickAreaView.hidden = YES;
    _coverView.hidden = YES;
    [self resultGet:nil];
    
}
- (IBAction)pickUnSelect:(id)sender {
    _pickAreaView.hidden = YES;
    _coverView.hidden = YES;
}

- (IBAction)switchAction:(id)sender {
    if (_majorSwitch.isOn) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setBool:YES forKey:@"major"];
        _fromExLabel.text = _majorSelectArray[0];
        _toExLabel.text = _majorSelectArray[1];
    }else {
        _fromExLabel.text = _selectShowArray[0];
        _toExLabel.text = _selectShowArray[1];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setBool:NO forKey:@"major"];
    }
    [_pickView reloadAllComponents];
}

@end
