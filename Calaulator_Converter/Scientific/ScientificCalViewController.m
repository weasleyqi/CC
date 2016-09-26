//
//  ScientificCalViewController.m
//  Calaulator_Converter
//
//  Created by Weasley Qi on 16/7/14.
//  Copyright © 2016年 Weasley Qi. All rights reserved.
//

#import "ScientificCalViewController.h"
#import "Math.h"
#import "Constant.h"
#import "MobileData.h"

typedef enum {
    Mode_RAD = 1,
    Mode_DEG = 2
    
} CalculatorMode;

@interface ScientificCalViewController ()
@property (strong, nonatomic) NSString *tempStr;
@property (strong, nonatomic) IBOutlet UILabel *showText;
@property (nonatomic) int count;
@property (nonatomic) NSNumber *cal;
@property (strong, nonatomic) NSMutableString *num1;
@property (strong, nonatomic) NSMutableString *num2;
@property (weak, nonatomic) IBOutlet UIView *DEG_View;
@property (weak, nonatomic) IBOutlet UIImageView *DEG_image;
@property (weak, nonatomic) IBOutlet UIView *RAD_View;
@property (weak, nonatomic) IBOutlet UIImageView *RAD_image;
@property (assign) CalculatorMode calculateMode;


@property (nonatomic) double mp1;//M+
@property (nonatomic) double mp2;//m+
@property (nonatomic) double mm1;//M-
@property (nonatomic) double mm2;//M-

@property (nonatomic) double resultValue;

@end

@implementation ScientificCalViewController
@synthesize showText;
@synthesize tempStr;
@synthesize resultValue;

- (void)viewDidLoad {
    [super viewDidLoad];
    tempStr = @"";
    _DEG_View.userInteractionEnabled = YES;
    _RAD_View.userInteractionEnabled = YES;
    _DEG_View.tag = 9001;
    _RAD_View.tag = 9002;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeRadAndDeg:)];
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeRadAndDeg:)];
    [_DEG_View addGestureRecognizer:tapGesture];
    [_RAD_View addGestureRecognizer:tapGesture2];
    
    _calculateMode = Mode_DEG;
    
    _mp1 = 0.00;
    _mp2 = 0.00;
    _mm1 = 0.00;
    _mm2 = 0.00;
    resultValue = 0;
}

- (void)changeRadAndDeg:(UITapGestureRecognizer *)sender {
    if (sender.view.tag == 9001) {
        _DEG_image.image = [UIImage imageNamed:@"scheck@2x.png"];
        _RAD_image.image = [UIImage imageNamed:@"suncheck@2x.png"];
        _calculateMode = Mode_DEG;
    }else {
        _DEG_image.image = [UIImage imageNamed:@"suncheck@2x.png"];
        _RAD_image.image = [UIImage imageNamed:@"scheck@2x.png"];
        _calculateMode = Mode_RAD;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//输入数字0-9还有小数点
- (IBAction)pressNumbers:(id)sender {
    [MobileData checkSettings];
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
    [MobileData checkSettings];
    //清空tempStr
    
    self.tempStr = [NSMutableString stringWithString:@""];
    
    if(0 == _count) {//如果是第一次输入
        _cal = [NSNumber numberWithLong:[sender tag]];
        self.num1 = [NSMutableString stringWithFormat:@"%@",showText.text];
//        switch ([_cal intValue]) {
//            case 111://x的3次方
//                showText.text =[NSString stringWithFormat:@"%g",pow([self.num1 doubleValue], 3)];
//                break;
//            case 112://x的2次方
//                showText.text =[NSString stringWithFormat:@"%g",pow([self.num1 doubleValue], 2)];
//                
//            default:
//                break;
//        }
    } else{ //不是第一次输入，则计算
        
        self.num2 = [NSMutableString stringWithFormat:@"%@", showText.text];
        int calculate = [_cal intValue];
        
        NSDecimalNumber *a1 =[NSDecimalNumber decimalNumberWithString:self.num1];
        NSDecimalNumber *a2 =[NSDecimalNumber decimalNumberWithString:self.num2];
        
        
        switch (calculate) {
            case 12://将加后的结果显示
                showText.text =[NSString stringWithFormat:@"%g",[self.num1 doubleValue] + [self.num2 doubleValue]];
                break;
            case 13://将减后的结果显示
                showText.text =[NSString stringWithFormat:@"%g",[self.num1 doubleValue] - [self.num2 doubleValue]];
                break;
            case 14://将乘后的结果显示
                showText.text =[NSString stringWithFormat:@"%g",[self.num1 doubleValue] * [self.num2 doubleValue]];
                break;
            case 15://将除后的结果显示
                showText.text =[NSString stringWithFormat:@"%g",[self.num1 doubleValue] / [self.num2 doubleValue]];
                break;
            case 110://x的y次幂
                showText.text =[NSString stringWithFormat:@"%g",pow([self.num1 doubleValue], [self.num2 doubleValue])];
                break;
            case 213:
                showText.text =[NSString stringWithFormat:@"%g",pow([self.num1 doubleValue], 1.0 / [self.num2 doubleValue])];
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
                showText.text =[NSString stringWithFormat:@"%g",([self.num1 doubleValue] *(-1))];
                break;
            case 17://将取百分后的结果显示
                showText.text =[NSString stringWithFormat:@"%g",([self.num1 doubleValue] / 100)];
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
        NSDecimalNumber *a1 =[NSDecimalNumber decimalNumberWithString:self.num1];
        NSDecimalNumber *a2 =[NSDecimalNumber decimalNumberWithString:self.num2];
        
        switch (calculate) {
            case 12://将加后的结果显示
                
                showText.text =[NSString stringWithFormat:@"%g",[self.num1 doubleValue] + [self.num2 doubleValue]];
                break;
            case 13://将减后的结果显示
                showText.text =[NSString stringWithFormat:@"%g",[self.num1 doubleValue] - [self.num2 doubleValue]];
                break;
            case 14://将乘后的结果显示
                showText.text =[NSString stringWithFormat:@"%g",[self.num1 doubleValue] * [self.num2 doubleValue]];
                break;
            case 15://将除后的结果显示
                showText.text =[NSString stringWithFormat:@"%g",[self.num1 doubleValue] / [self.num2 doubleValue]];
                break;
            default:
                break;
        }
    }
    
}

- (IBAction)advancedCalculate:(id)sender {
    [MobileData checkSettings];
    /*
     sin 20
     cos 21
     tan 22
     sin-1 23
     cos-1 24
     tan-1 25
     pi 26
     e 27
     */
    //RAD 弧度 DEG角度
    //1角度=（PI/180）弧度 sin计算的值是弧度，需要转换成角度 360°角=2π弧度
    double calculateValue = [showText.text doubleValue];
    tempStr = @"0";
    if (_calculateMode == Mode_DEG) {
        calculateValue = (M_PI/180)*([showText.text doubleValue]);
    }
    switch ([sender tag]) {
        case 20:
            showText.text = [NSString stringWithFormat:@"%g",sin(calculateValue)];
            if ([showText.text isEqualToString:@"nan"]) {
                showText.text = @"ERROR";
            }
            break;
        case 21:
            showText.text = [NSString stringWithFormat:@"%g",cos(calculateValue)];
            if ([showText.text isEqualToString:@"nan"]) {
                showText.text = @"ERROR";
            }
            break;
        case 22:
            showText.text = [NSString stringWithFormat:@"%g",tan(calculateValue)];
            if ([showText.text isEqualToString:@"nan"]) {
                showText.text = @"ERROR";
            }
            break;
        case 23:
            showText.text = [NSString stringWithFormat:@"%g",asin([showText.text doubleValue])*180/M_PI];
            if ([showText.text isEqualToString:@"nan"]) {
                showText.text = @"ERROR";
            }
            break;
        case 24:
            showText.text = [NSString stringWithFormat:@"%g",acos([showText.text doubleValue])*180/M_PI];
            if ([showText.text isEqualToString:@"nan"]) {
                showText.text = @"ERROR";
            }
            break;
        case 25:
            showText.text = [NSString stringWithFormat:@"%g",atan([showText.text doubleValue])*180/M_PI];
            if ([showText.text isEqualToString:@"nan"]) {
                showText.text = @"ERROR";
            }
            break;
        case 26://pi
            showText.text = [NSString stringWithFormat:@"%g",M_PI];
            break;
        case 27://e
            showText.text = [NSString stringWithFormat:@"%g",M_E];
            break;
        case 111://x的3次方
            showText.text = [NSString stringWithFormat:@"%g",pow([showText.text doubleValue], 3)];
            break;
        case 112://x的2次方
            showText.text =[NSString stringWithFormat:@"%g",pow([showText.text doubleValue], 2)];
            break;
        case 210://e x
            showText.text =[NSString stringWithFormat:@"%g",pow(M_E, [showText.text doubleValue])];
            if ([showText.text isEqualToString:@"nan"]) {
                showText.text = @"ERROR";
            }
            break;
        case 211://10 x
            showText.text =[NSString stringWithFormat:@"%g",pow(10, [showText.text doubleValue])];
            if ([showText.text isEqualToString:@"nan"]) {
                showText.text = @"ERROR";
            }
            break;
        case 212:
            showText.text =[NSString stringWithFormat:@"%g",sqrt([showText.text doubleValue])];
            if ([showText.text isEqualToString:@"nan"]) {
                showText.text = @"ERROR";
            }
            break;
        case 214://开3次方
            showText.text =[NSString stringWithFormat:@"%g",pow([showText.text doubleValue], 1.0/3)];
            if ([showText.text isEqualToString:@"nan"]) {
                showText.text = @"ERROR";
            }
            break;
        case 215://in
            showText.text = [NSString stringWithFormat:@"%g",log10([showText.text doubleValue]) / log10(M_E)];
            if ([showText.text isEqualToString:@"nan"]) {
                showText.text = @"ERROR";
            }
            break;
        case 216://log10
            showText.text = [NSString stringWithFormat:@"%g",log10([showText.text doubleValue])];
            if ([showText.text isEqualToString:@"nan"]) {
                showText.text = @"ERROR";
            }
            break;
        case 217://1/x
            showText.text = [NSString stringWithFormat:@"%g",1/ [showText.text doubleValue]];
            if ([showText.text isEqualToString:@"nan"]) {
                showText.text = @"ERROR";
            }
            break;
        case 218://n!
            if ([showText.text intValue] != 0) {
                showText.text = [NSString stringWithFormat:@"%g",[self fac]];
                if ([showText.text isEqualToString:@"0"]) {
                    showText.text = @"ERROR";
                }
            }
            
            break;
        case 219:
            showText.text = [NSString stringWithFormat:@"%g",exp([showText.text doubleValue])];
            break;
        case 220:
            showText.text = [NSString stringWithFormat:@"%g",(double)(arc4random()%10000) /10000];
            break;
        case 221://M+
            if (_mp1 == 0.00) {
                _mp1 = _mp1 + [showText.text doubleValue];
            }else {
                _mp2 = _mp2 + [showText.text doubleValue];
            }
            break;
        case 222://M-
            if (_mm1 == 0.00) {
                _mm1 = _mm1 - [showText.text doubleValue];
            }else {
                _mm2 = _mm2 - [showText.text doubleValue];
            }
            break;
        case 223://MR
            if (_mp1 != 0.00 & _mp2 != 0.00) {
                showText.text = [NSString stringWithFormat:@"%g",(_mp1 + _mp2)];
                _mp1 = 0.00;
                _mp2 = 0.00;
                _mm1 = 0.00;
                _mm2 = 0.00;
            }else if(_mp1 != 0.00 & _mm1 != 0.00) {
                showText.text = [NSString stringWithFormat:@"%g",(_mp1 + _mm1)];
                _mp1 = 0.00;
                _mp2 = 0.00;
                _mm1 = 0.00;
                _mm2 = 0.00;
            }else if(_mp1 != 0.00 & _mm2 != 0.00) {
                showText.text = [NSString stringWithFormat:@"%g",(_mp1 + _mm2)];
                _mp1 = 0.00;
                _mp2 = 0.00;
                _mm1 = 0.00;
                _mm2 = 0.00;
            }else if(_mp2 != 0.00 & _mm1 != 0.00) {
                showText.text = [NSString stringWithFormat:@"%g",(_mp2 + _mm1)];
                _mp1 = 0.00;
                _mp2 = 0.00;
                _mm1 = 0.00;
                _mm2 = 0.00;
            }else if(_mp2 != 0.00 & _mm2 != 0.00) {
                showText.text = [NSString stringWithFormat:@"%g",(_mp2 + _mm2)];
                _mp1 = 0.00;
                _mp2 = 0.00;
                _mm1 = 0.00;
                _mm2 = 0.00;
            }else if(_mm1 != 0.00 & _mm2 != 0.00) {
                showText.text = [NSString stringWithFormat:@"%g",(_mm1 + _mm2)];
                _mp1 = 0.00;
                _mp2 = 0.00;
                _mm1 = 0.00;
                _mm2 = 0.00;
            }
            break;
        case 224://MC
            _mp1 = 0.00;
            _mp2 = 0.00;
            _mm1 = 0.00;
            _mm2 = 0.00;
            showText.text = @"0";
            break;
        default:
            break;
    }
}

- (double)fac {
    double v = 1;
    int a = [showText.text intValue];
    if (a != [showText.text doubleValue]) {
        
    }else {
        if (a < 0) {
            v =0;
        }else if (a ==0 || a==1) {
            v = 1;
        }else {
            for (int b = 1 ; b <= a; b ++) {
                v = v*b;
            }
        }
    }
    return v;
}

@end
