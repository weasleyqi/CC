//
//  ScientificCalViewController.m
//  Calaulator_Converter
//
//  Created by Weasley Qi on 16/7/14.
//  Copyright © 2016年 Weasley Qi. All rights reserved.
//

#import "ScientificCalViewController.h"
#import "Math.h"

@interface ScientificCalViewController ()
@property (strong, nonatomic) NSString *tempStr;
@property (strong, nonatomic) IBOutlet UILabel *showText;
@property (nonatomic) int count;
@property (nonatomic) NSNumber *cal;
@property (strong, nonatomic) NSMutableString *num1;
@property (strong, nonatomic) NSMutableString *num2;
@end

@implementation ScientificCalViewController
@synthesize showText;
@synthesize tempStr;

- (void)viewDidLoad {
    [super viewDidLoad];
    tempStr = @"";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//输入数字0-9还有小数点
- (IBAction)pressNumbers:(id)sender {
    //处理0的问题
    //以零开头，下次输入的非0，则清空0
    //如果以0.开头，则不清空
    
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
}

- (IBAction)basicCalculate:(id)sender {
    //清空tempStr
    
    self.tempStr = [NSMutableString stringWithString:@""];
    
    if(0 == _count) {//如果是第一次输入
        _cal = [NSNumber numberWithLong:[sender tag]];
        self.num1 = [NSMutableString stringWithFormat:@"%@",showText.text];
    } else{ //不是第一次输入，则计算
        self.num2 = [NSMutableString stringWithFormat:@"%@", showText.text];
        int calculate = [_cal intValue];
        switch (calculate) {
            case 12://将加后的结果显示
                showText.text =[NSString stringWithFormat:@"%lf",([self.num1 doubleValue] + [self.num2 doubleValue])];
                break;
            case 13://将减后的结果显示
                showText.text =[NSString stringWithFormat:@"%lf",([self.num1 doubleValue] - [self.num2 doubleValue])];
                break;
            case 14://将乘后的结果显示
                showText.text =[NSString stringWithFormat:@"%lf",([self.num1 doubleValue] * [self.num2 doubleValue])];
                break;
            case 15://将除后的结果显示
                showText.text =[NSString stringWithFormat:@"%lf",([self.num1 doubleValue] / [self.num2 doubleValue])];
                break;
            default:
                break;
        }
        self.num1 = [NSMutableString stringWithFormat:@"%@", showText.text];
        _cal = [NSNumber numberWithLong:[sender tag]];
        
    }
    _count = @1;
    if ([sender tag] == 16 || [sender tag] == 17) {//单目运算正负和%
        switch ([sender tag]) {
            case 16://将乘负后的结果显示
                showText.text =[NSString stringWithFormat:@"%f",([self.num1 doubleValue] *(-1))];
                break;
            case 17://将取百分后的结果显示
                showText.text =[NSString stringWithFormat:@"%f",([self.num1 doubleValue] / 100)];
                break;
            default:
                break;
        }
        self.num1 = [NSMutableString stringWithFormat:@"%@", showText.text];
    }
    if ([sender tag] == 18) { //Clear
        showText.text = @"0";
        _cal = [NSNumber numberWithLong:@"0"];
        _count = @0;
    }
    if ([sender tag] == 19) { //等于
        int calculate = [_cal intValue];
        switch (calculate) {
            case 12://将加后的结果显示
                showText.text =[NSString stringWithFormat:@"%lf",([self.num1 doubleValue] + [self.num2 intValue])];
                break;
            case 13://将减后的结果显示
                showText.text =[NSString stringWithFormat:@"%lf",([self.num1 doubleValue] - [self.num2 intValue])];
                break;
            case 14://将乘后的结果显示
                showText.text =[NSString stringWithFormat:@"%lf",([self.num1 doubleValue] * [self.num2 intValue])];
                break;
            case 15://将除后的结果显示
                showText.text =[NSString stringWithFormat:@"%lf",([self.num1 doubleValue] / [self.num2 intValue])];
                break;
            default:
                break;
        }
    }
    
}

- (IBAction)advancedCalculate:(id)sender {
    /*
     sin 20
     cos 21
     tan 22
     sin-1 23
     cos-1 24
     tan-1 25
     */
    //RAD 弧度 DEG角度
    //1角度=（PI/180）弧度 sin计算的值是弧度，需要转换成角度
    double hudu = (M_PI/180)*([showText.text doubleValue]);
    showText.text = [NSString stringWithFormat:@"%f",sin(hudu)];

}

@end
