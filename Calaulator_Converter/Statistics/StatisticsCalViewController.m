//
//  StatisticsCalViewController.m
//  Calaulator_Converter
//
//  Created by Weasley Qi on 16/7/14.
//  Copyright © 2016年 Weasley Qi. All rights reserved.
//

#import "StatisticsCalViewController.h"
#import "AddedView.h"
#import "MobileData.h"

@interface StatisticsCalViewController ()<DeleteNumDelegate>
@property (weak, nonatomic) IBOutlet AddedView *addedView;
@property (strong, nonatomic) NSMutableArray *addedarr;
@property (strong, nonatomic) NSMutableArray *addedNumArr;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) NSString *tempStr;
@property (weak, nonatomic) IBOutlet UILabel *showText;

@property (nonatomic) BOOL isExp;
@property (nonatomic) BOOL expPressed;
@property (strong, nonatomic) NSString *expString;
@property (strong, nonatomic) NSString *expShowString;
@end

@implementation StatisticsCalViewController
@synthesize tempStr,expShowString;
@synthesize showText;
@synthesize isExp;
@synthesize expString;
@synthesize expPressed;

- (void)viewDidLoad {
    [super viewDidLoad];
    tempStr = @"";
    _addedarr = [NSMutableArray new];
    _addedNumArr = [NSMutableArray new];
    isExp = NO;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)add:(id)sender {
    [MobileData checkSettings];
    if (isExp) {
        if ([showText.text containsString:@" -"]) {
            showText.text = [NSString stringWithFormat:@"%.10g",[expString doubleValue] * pow(10, -[expShowString doubleValue])];
        }else {
            showText.text = [NSString stringWithFormat:@"%.10g",[expString doubleValue] * pow(10, [expShowString doubleValue])];
        }
        isExp = NO;
        expString = @"";
    }
    float x = 15;
    float y = -80   ;
    NSInteger count = [_addedarr count];
    if (count % 2 == 0) {
        x = 15;
        y = 40*(count / 2)-60;
    }else {
        x = 15+10 + _addedView.frame.size.width;
        y = 40*(count / 2)-60;
    }

    _addedView = [[NSBundle mainBundle]loadNibNamed:@"AddedView" owner:self options:nil][0];
    _addedView.frame = CGRectMake(x, y, _addedView.frame.size.width, 40);
    _addedView.tag = [_addedarr count];
    [_addedNumArr addObject:[NSNumber numberWithDouble:[showText.text doubleValue]]];
    _addedView.labelNum.text = showText.text;
    _addedView.delegate = self;
    [_scrollView addSubview:_addedView];
    [_addedarr addObject:[NSString stringWithFormat:@"%ld",_addedView.tag]];
    
    _scrollView.showsVerticalScrollIndicator = NO;
    if (count/2*40 > _scrollView.frame.size.height) {
        _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, count/2*40);
    }
    _countLabel.text = [NSString stringWithFormat:@"Count=%lu",(unsigned long)[_addedarr count]];
    showText.text = @"0";
    tempStr = @"0";
}

- (void)deletenum:(NSInteger)tag {
    [_addedarr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj intValue] == tag) {
            [_addedarr removeObjectAtIndex:idx];
            [_addedNumArr removeObjectAtIndex:idx];
        }
    }];
    [self refreshscrollview];
    NSLog(@"count %ld",[_addedarr count]);
}

- (void)refreshscrollview {
    [[_scrollView subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [(AddedView*)obj removeFromSuperview];
    }];
    NSLog(@"%ld",[[_scrollView subviews]count]);
    
    __block NSMutableArray *tmp = [NSMutableArray new];
    [_addedarr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        float x = 15;
        float y = -80   ;
        NSInteger count = [tmp count];
        if (count % 2 == 0) {
            x = 15;
            y = 40*(count / 2)-60;
        }else {
            x = 15+10 + _addedView.frame.size.width;
            y = 40*(count / 2)-60;
        }
        
        _addedView = [[NSBundle mainBundle]loadNibNamed:@"AddedView" owner:self options:nil][0];
        _addedView.frame = CGRectMake(x, y, _addedView.frame.size.width, 40);
        _addedView.tag = [tmp count];
        _addedView.labelNum.text = [NSString stringWithFormat:@"%@",_addedNumArr[count] ];
        _addedView.delegate = self;
        [_scrollView addSubview:_addedView];
        [tmp addObject:[NSString stringWithFormat:@"%ld",_addedView.tag]];
        
        _scrollView.showsVerticalScrollIndicator = NO;
        if (count/2*40 > _scrollView.frame.size.height) {
            _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, count/2*40);
        }
    }];
    _addedarr = tmp;
    
    _countLabel.text = [NSString stringWithFormat:@"Count=%lu",(unsigned long)[_addedarr count]];
}

- (IBAction)calculate:(UIButton *)sender {
    [MobileData checkSettings];
    if (isExp && [sender tag] != 108) {
        if ([showText.text containsString:@" -"]) {
            showText.text = [NSMutableString stringWithFormat:@"%.10g",[expString doubleValue] * pow(10, -[expShowString doubleValue])];
        }else {
            showText.text = [NSMutableString stringWithFormat:@"%.10g",[expString doubleValue] * pow(10, [expShowString doubleValue])];
        }
        
        isExp = NO;
//        showText.text = [NSString stringWithFormat:@"%.10g",[expString doubleValue] * pow(10, [expShowString doubleValue])];
//        isExp = NO;
        expString = @"";
    }else if (isExp && [sender tag] == 19) {
        if ([showText.text containsString:@" -"]) {
            showText.text = [NSMutableString stringWithFormat:@"%.10g",[expString doubleValue] * pow(10, -[expShowString doubleValue])];
        }else {
            showText.text = [NSMutableString stringWithFormat:@"%.10g",[expString doubleValue] * pow(10, [expShowString doubleValue])];
        }
        isExp = NO;
    }
    switch (sender.tag) {
        case 100://x average
            if ([_addedNumArr count] > 0) {
                __block double sum = 0.0;
                [_addedNumArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    sum = sum + [obj doubleValue];
                }];
                showText.text = [NSString stringWithFormat:@"%.10g",sum / [_addedNumArr count]];
                _countLabel.text = [NSString stringWithFormat:@"Count=%ld, Mean (Avergae) ",[_addedarr count]];
            }else {
                [self showAttributedLabel];
            }
            break;
        case 101://x2 average
            if ([_addedNumArr count] > 0) {
                __block double sum = 0.0;
                [_addedNumArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    sum = sum + [obj doubleValue] * [obj doubleValue];
                }];
                showText.text = [NSString stringWithFormat:@"%.10g",sum / [_addedNumArr count]];
                _countLabel.text = [NSString stringWithFormat:@"Count=%ld, Mean of the Square of the Values ",[_addedarr count]];
            }else {
                [self showAttributedLabel];
            }
            break;
        case 102://x求和
            if ([_addedNumArr count] > 0) {
                __block double sum = 0.0;
                [_addedNumArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    sum = sum + [obj doubleValue];
                }];
                showText.text = [NSString stringWithFormat:@"%.10g",sum];
                _countLabel.text = [NSString stringWithFormat:@"Count=%ld, Sum ",[_addedarr count]];
            }else {
                [self showAttributedLabel];
            }
            break;
        case 103://x2 求和
            if ([_addedNumArr count] > 0) {
                __block double sum = 0.0;
                [_addedNumArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    sum = sum + [obj doubleValue] * [obj doubleValue];
                }];
                showText.text = [NSString stringWithFormat:@"%.10g",sum];
                _countLabel.text = [NSString stringWithFormat:@"Count=%ld, Sum of the Square of the Values ",[_addedarr count]];
            }else {
                [self showAttributedLabel];
            }
            break;
        case 104://标准差
            if ([_addedNumArr count] > 0) {
                __block double sum = 0.0;
                [_addedNumArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    sum = sum + [obj doubleValue];
                }];
                double average = sum / [_addedNumArr count];
                sum = 0;
                [_addedNumArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    sum = sum + ([obj doubleValue] - average) * ([obj doubleValue] - average);
                }];
                
                double std = sqrt(sum/[_addedNumArr count]);
                showText.text = [NSString stringWithFormat:@"%.10g",std];
                _countLabel.text = [NSString stringWithFormat:@"Count=%ld, Population Standard Deviation",[_addedarr count]];
            }else {
                [self showAttributedLabel];
            }
            break;
        case 105://方差
            if ([_addedNumArr count] > 0) {
                __block double sum = 0.0;
                [_addedNumArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    sum = sum + [obj doubleValue];
                }];
                double average = sum / [_addedNumArr count];
                sum = 0;
                [_addedNumArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    sum = sum + ([obj doubleValue] - average) * ([obj doubleValue] - average);
                }];
                
                showText.text = [NSString stringWithFormat:@"%.10g",sum/[_addedNumArr count]];
                _countLabel.text = [NSString stringWithFormat:@"Count=%ld, Population Standard Variance",[_addedarr count]];
            }else {
                [self showAttributedLabel];
            }
            break;
        case 106://样本标准差
            if ([_addedNumArr count] > 1) {
                __block double sum = 0.0;
                [_addedNumArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    sum = sum + [obj doubleValue];
                }];
                double average = sum / [_addedNumArr count];
                sum = 0;
                [_addedNumArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    sum = sum + ([obj doubleValue] - average) * ([obj doubleValue] - average);
                }];
                double std = sqrt(sum/([_addedNumArr count]-1));
                showText.text = [NSString stringWithFormat:@"%.10g",std];
                _countLabel.text = [NSString stringWithFormat:@"Count=%ld, Simple Standard Deviation ",[_addedarr count]];
            }else {
                [self showAttributedLabel];
            }
            
            break;
        case 107://方差
            if ([_addedNumArr count] > 1) {
                __block double sum = 0.0;
                [_addedNumArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    sum = sum + [obj doubleValue];
                }];
                double average = sum / [_addedNumArr count];
                sum = 0;
                [_addedNumArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    sum = sum + ([obj doubleValue] - average) * ([obj doubleValue] - average);
                }];
                
                showText.text = [NSString stringWithFormat:@"%.10g",sum/([_addedNumArr count]-1)];
                _countLabel.text = [NSString stringWithFormat:@"Count=%ld, Simple Standard Variance ",[_addedarr count]];
            }else {
                [self showAttributedLabel];
            }
            break;
        case 108://正负
            if (isExp) {
                if ([showText.text containsString:@" +"]) {
                    showText.text = [showText.text stringByReplacingOccurrencesOfString:@" +" withString:@" -"];
                }else if ([showText.text containsString:@" -"]) {
                    showText.text = [showText.text stringByReplacingOccurrencesOfString:@" -" withString:@" +"];
                }
            }else {
                showText.text =[NSString stringWithFormat:@"%.10g",([showText.text doubleValue] *(-1))];
            }
            tempStr = showText.text;
            break;
            
        case 109://GM几何平均
            if ([_addedNumArr count] > 0) {
                __block double sum = 1.0;
                [_addedNumArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    sum = sum * [obj doubleValue];
                }];
                showText.text =[NSString stringWithFormat:@"%.10g",pow(sum , 1.0/[_addedNumArr count])];
                _countLabel.text = [NSString stringWithFormat:@"Count=%ld, Geometric Mean ",[_addedarr count]];
            }else {
                [self showAttributedLabel];
            }
            break;
            
        case 201://cad
            [[_scrollView subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [(AddedView*)obj removeFromSuperview];
            }];
            [_addedNumArr removeAllObjects];
            [_addedarr removeAllObjects];
            showText.text = @"0";
            tempStr = @"0";
            break;
            
        case 202://exp
            if (isExp) {
                showText.text = [NSString stringWithFormat:@"%.10g",[expString doubleValue] * pow(10, [expShowString doubleValue])];
            }
            expString = showText.text;
            showText.text = [[showText.text stringByAppendingString:@" +"] stringByAppendingString:@"0"];
            isExp = YES;
            expPressed = YES;
            
            tempStr = @"";
            break;
        case 18: // C
            showText.text = @"0";
            tempStr = @"0";
            break;
        default:
            break;
    }
    
}

- (void)showAttributedLabel {
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:@"Count=0, Please provide 1 or more values."];
    [attriString addAttribute:(NSString *)NSForegroundColorAttributeName
                        value:(id)[UIColor redColor].CGColor
                        range:NSMakeRange(9, 32)];
    _countLabel.attributedText = attriString;
}

- (IBAction)inputNum:(UIButton *)sender {
    [MobileData checkSettings];
//    if (isExp && expPressed) {
//        showText.text = @"";
//        tempStr = @"";
//        expPressed = NO;
//    }
    if ([tempStr hasPrefix:@"0"] && [sender tag] > 0 && [sender tag] <10 && ![tempStr hasPrefix:@"0."]) {
        tempStr = @"";
    } else if ([tempStr hasPrefix:@"0"] && [sender tag] == 0 && ![tempStr hasPrefix:@"0."]) {
        //如果是以0开头，但是不是以0.开头，则直接返回
        return;
    }else if (isExp) {
        NSRange range = [showText.text rangeOfString:@"-"];
        if (range.length == 0) {
            
        }else {
            tempStr = [showText.text substringFromIndex:range.location+1];
        }
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
    if (isExp) {
        if ([showText.text containsString:@" +"]) {
            NSRange range = [showText.text rangeOfString:@"+"];
            NSString *str = [showText.text substringToIndex:range.location];
            showText.text = [[str stringByAppendingString:@"+"] stringByAppendingString:tempStr];
        }else if ([showText.text containsString:@" -"]) {
            NSRange range = [showText.text rangeOfString:@"-"];
            NSString *str = [showText.text substringToIndex:range.location];
            showText.text = [[str stringByAppendingString:@"-"] stringByAppendingString:tempStr];
        }
        //        showText.text = [[showText.text stringByAppendingString:@" +"] stringByAppendingString:tempStr];
        expShowString = tempStr;
    }else {
        showText.text = tempStr;
    }
}

@end
