//
//  UnitConverterViewController.m
//  Calaulator_Converter
//
//  Created by Weasley Qi on 16/7/14.
//  Copyright © 2016年 Weasley Qi. All rights reserved.
//

#import "UnitConverterViewController.h"
#import "MBButtonWithFontAdapter.h"
#import <AudioToolbox/AudioToolbox.h> //声音提示
#import "Constant.h"
#import "UnitCell.h"
#import "MobileData.h"

@interface UnitConverterViewController ()<UnitSelecteDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIScrollView *unitScrollView;
@property (weak, nonatomic) IBOutlet UnitCell *sbUnitCell;

@property (strong, nonatomic) NSArray *unitTitleArr;
@property (nonatomic) NSInteger currentSelectedIndex;//selected category
@property (nonatomic) NSInteger currentSelectedRowIndex;//selected row index from
@property (nonatomic) NSInteger currentSelectedRowIndex2; //selected row index to

@property (weak, nonatomic) IBOutlet MBLabelWithFontAdapter *showText;

@property (weak, nonatomic) IBOutlet MBLabelWithFontAdapter *fromLabel;
@property (weak, nonatomic) IBOutlet MBLabelWithFontAdapter *toLabel;
@property (weak, nonatomic) IBOutlet UIView *fromView;
@property (weak, nonatomic) IBOutlet UIView *toView;

@property (weak, nonatomic) IBOutlet MBLabelWithFontAdapter *fromShowLabel;
@property (weak, nonatomic) IBOutlet MBLabelWithFontAdapter *toShowLabel;
@property (weak, nonatomic) IBOutlet MBLabelWithFontAdapter *fromValueLabel;
@property (weak, nonatomic) IBOutlet MBLabelWithFontAdapter *toValueLabel;

@property (strong, nonatomic) NSArray *lengthDataArray;
@property (strong, nonatomic) NSArray *tempDataArray;
@property (strong, nonatomic) NSArray *areaDataArray;
@property (strong, nonatomic) NSArray *volumeDataArray;
@property (strong, nonatomic) NSArray *weightDataArray;
@property (strong, nonatomic) NSArray *timeDataArray;
@property (strong, nonatomic) NSArray *currentShowArray;
@property (weak, nonatomic) IBOutlet UIPickerView *unitPickView;
@property (weak, nonatomic) IBOutlet UIView *pickAreaView;
@property (weak, nonatomic) IBOutlet UIView *coverView;

@property (strong, nonatomic) NSString *tempStr;
@property (nonatomic) BOOL isTemp;
@property (nonatomic) BOOL isExp;
@property (nonatomic) BOOL expPressed;
@property (strong, nonatomic) NSString *expString;
@property (strong, nonatomic) NSString *expShowString;
@end

@implementation UnitConverterViewController
@synthesize tempStr,expShowString;
@synthesize showText;
@synthesize isExp;
@synthesize expPressed,expString;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    tempStr = @"";
    _isTemp = NO;
    isExp = NO;
    expPressed = NO;
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taptap:)];
    _fromView.userInteractionEnabled = YES;
    _fromView.tag = 1;
    [_fromView addGestureRecognizer:gesture];
    
    UITapGestureRecognizer *gesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taptap:)];
    _toView.userInteractionEnabled = YES;
    _toView.tag = 2;
    [_toView addGestureRecognizer:gesture2];
    
    UITapGestureRecognizer *gesture3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taptap:)];
    _coverView.userInteractionEnabled = YES;
    _coverView.tag = 3;
    [_coverView addGestureRecognizer:gesture3];
    
    _unitTitleArr = @[@"Length",@"Temp.",@"Area",@"Volume",@"Weight",@"Time"];
    _lengthDataArray = @[@{@"Meter":@"1"},@{@"Kilometer":@"0.001"},@{@"Centimeter":@"100"},@{@"Millimeter":@"1000"},@{@"Micrometer":@"1000000"},@{@"Nanometer":@"1000000000"},@{@"Mile":@"0.0006213712"},@{@"Yard":@"1.0936132983"},@{@"Foot":@"3.280839895"},@{@"Inch":@"39.37007874"},@{@"Light Year":@"0.0000000000000001057000834"}];
    _tempDataArray = @[@{@"Celsius":@"-17.222222222"},@{@"Kelvin":@"255.92777778"},@{@"Farenheit":@"1"}];
    _areaDataArray = @[@{@"Square Meter":@"83.612736"},@{@"Square Kilometer":@"0.0000836127"},@{@"Square Centimeter":@"836127.36"},@{@"Square Millimeter":@"83612736"},@{@"Square Micrometer":@"83612735999999"},@{@"Hectare":@"0.0083612736"},@{@"Square Mile":@"0.0000322831"},@{@"Square Yard":@"100"},@{@"Square Foot":@"900"},@{@"Square Inch":@"129600"},@{@"Acre":@"0.0206610744"}];
    _volumeDataArray = @[@{@"Cubic Meter":@"10"},@{@"Cubic Kilometer":@"0.00000001"},@{@"Cubic Centimeter":@"10000000"},@{@"Cubic Millimeter":@"10000000000"},@{@"Liter":@"10000"},@{@"Milliliter":@"10000000"},@{@"US Gallon":@"2641.7205236"},@{@"US Quart":@"10566.882094"},@{@"US Pint":@"21133.764189"},@{@"US Cup":@"42267.528377"},@{@"US Fluid Ounce":@"338140.22702"},@{@"US Table Spoon":@"676280.45404"},@{@"US Tea Spoon":@"2028841.3621"},@{@"Imperial Gallon":@"2199.692483"},@{@"Imperial Quart":@"8798.769932"},@{@"Imperial Pint":@"17597.539864"},@{@"Imperial Fluid Ounce":@"351950.79728"},@{@"Imperial Tabel Spoon":@"563121.27565"},@{@"Imperial Tea Spoon":@"1689363.8269"},@{@"Cubic Mile":@"0.000000002399127585"},@{@"Cubic Yard":@"13.079506193"},@{@"Cubic Foot":@"353.14666721"},@{@"Cubic Inch":@"610237.44095"}];
    _weightDataArray = @[@{@"Kilogarm":@"1"},@{@"Gram":@"1000"},@{@"Milligram":@"1000000"},@{@"Metric Ton":@"0.001"},@{@"Long Ton":@"0.0009842065"},@{@"Short Ton":@"0.0011023113"},@{@"Pound":@"2.2046226218"},@{@"Ounce":@"35.27396195"},@{@"Carrat":@"5000"},@{@"Atomic Mass Unit":@"602213665100000000000000000"}];
    _timeDataArray = @[@{@"Second":@"3600"},@{@"Millisecond":@"3600000"},@{@"Microsecond":@"3600000000"},@{@"Nanosecond":@"3600000000000"},@{@"Picosecond":@"3600000000000000"},@{@"Minute":@"60"},@{@"Hour":@"1"},@{@"Day":@"0.0416666667"},@{@"Week":@"0.005952381"},@{@"Month":@"0.001369863"},@{@"Year":@"0.0001141553"}];
    _currentShowArray = _lengthDataArray;
    
    [_unitTitleArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        float x = 0;
        UnitCell *cell = [[NSBundle mainBundle] loadNibNamed:@"UnitCell" owner:self options:nil][0];
        cell.delegate = self;
        cell.title.text = _unitTitleArr[idx];
        if (idx == 0) {
            cell.bottomLine.hidden = NO;
            cell.title.textColor = UIColorFromRGB(0x047dce, 1);//047DCE
        }
        cell.tag = idx;
        x = (64)* idx;
        NSLog(@"xxxxxx %g",x);
        CGRect rect = cell.frame;
//        rect.size.width = cell.frame.size.width *WIDTH / 375;
        rect.origin.x = x;
        cell.frame = rect;
        cell.title.textAlignment = NSTextAlignmentCenter;
        NSLog(@"yyyyyy %g  %F",cell.frame.origin.x,cell.frame.size.width);
        [_unitScrollView addSubview:cell];

//        UnitCell *cell = [[UnitCell alloc] initWithFrame:CGRectMake(idx*64, 0, 64, _unitScrollView.frame.size.height) tag:idx text:_unitTitleArr[idx]];
//        cell.delegate = self;
//        cell.backgroundColor = [UIColor redColor];
//        [_unitScrollView addSubview:cell];
        
        _unitScrollView.contentSize = CGSizeMake(cell.frame.size.width * [_unitTitleArr count], _unitScrollView.frame.size.height);
    }];
    _unitScrollView.scrollEnabled = YES;

    _currentSelectedIndex = 0;
    _currentSelectedRowIndex = 0;
    _currentSelectedRowIndex2 = 1;
    _fromLabel.text = [_currentShowArray[0] allKeys][0];
    _toLabel.text = [_currentShowArray[1] allKeys][0];
    _fromShowLabel.text = [_currentShowArray[0] allKeys][0];
    _toShowLabel.text = [_currentShowArray[1] allKeys][0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)unitSelect:(NSInteger)tag {
    [[_unitScrollView subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UnitCell class]]) {
            if (obj.tag == _currentSelectedIndex) {
                UnitCell *cell = (UnitCell *)obj;
                cell.title.textColor = UIColorFromRGB(0x94a1ad, 1);//94A1AD
                cell.bottomLine.hidden = YES;
            }
        }
    }];
    [[_unitScrollView subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UnitCell class]]) {
            if (obj.tag == tag) {
                UnitCell *cell = (UnitCell *)obj;
                cell.title.textColor = UIColorFromRGB(0x047dce, 1);//047DCE
                cell.bottomLine.hidden = NO;
                _currentSelectedIndex = tag;
            }
        }
    }];
    _currentShowArray = [NSArray new];
    _currentSelectedRowIndex = 0;
    _currentSelectedRowIndex2 = 1;
    switch (_currentSelectedIndex) {
            
        case 0://length
            _currentShowArray = _lengthDataArray;
            break;
        case 1://temp
            _currentShowArray = _tempDataArray;
            break;
        case 2://area
            _currentShowArray = _areaDataArray;
            break;
        case 3 ://volume
            _currentShowArray = _volumeDataArray;
            break;
        case 4://weight
            _currentShowArray = _weightDataArray;
            break;
        case 5://time
            _currentShowArray = _timeDataArray;
            break;
        default:
            _currentShowArray = _lengthDataArray;
            break;
    }
    
    if (_currentSelectedIndex == 1) {
        _isTemp = YES;
    }else {
        _isTemp = NO;
    }
    _fromLabel.text = [_currentShowArray[0] allKeys][0];
    _toLabel.text = [_currentShowArray[1] allKeys][0];
    _fromShowLabel.text = [_currentShowArray[0] allKeys][0];
    _toShowLabel.text = [_currentShowArray[1] allKeys][0];
    
    [self resultBtnClicked:nil];
    
}

- (IBAction)click1:(id)sender {
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
//    showText.text = tempStr;
    if (isExp) {
        if ([showText.text containsString:@" +"]) {
            NSRange range = [showText.text rangeOfString:@"+"];
            NSString *str = [showText.text substringToIndex:range.location];
            showText.text = [[str stringByAppendingString:@"+"] stringByAppendingString:tempStr];
        }
        //        showText.text = [[showText.text stringByAppendingString:@" +"] stringByAppendingString:tempStr];
        expShowString = tempStr;
    }else {
        showText.text = tempStr;
        [self resultBtnClicked:nil];
    }
}


- (IBAction)resultBtnClicked:(id)sender {
    if (isExp) {
        showText.text = [NSString stringWithFormat:@"%.10g",[expString doubleValue] * pow(10, [expShowString doubleValue])];
//        isExp = NO;
        expString = @"";
    }
    if (_isTemp) {
//        showText.text = [self tempCalWithFirstIndex:_currentSelectedRowIndex secondIndex:_currentSelectedRowIndex2];
        _fromValueLabel.text = showText.text;
        _toValueLabel.text = [self tempCalWithFirstIndex:_currentSelectedRowIndex secondIndex:_currentSelectedRowIndex2];
        //    [_toValueLabel sizeToFit];
        _toValueLabel.textAlignment = NSTextAlignmentCenter;
        return;
//        CKF
        /*
         华氏度 = 32 + 摄氏度 × 1.8
         开氏度=273.16+摄氏度
         摄氏度 = (华氏度 - 32) ÷ 1.8
         */
        
    }
    double result = [showText.text doubleValue] * [[_currentShowArray[_currentSelectedRowIndex2] allValues][0] doubleValue] / [[_currentShowArray[_currentSelectedRowIndex] allValues][0] doubleValue] ;
    _fromValueLabel.text = showText.text;
    _toValueLabel.text = [NSString stringWithFormat:@"%.10g",result];
//    [_toValueLabel sizeToFit];
    _toValueLabel.textAlignment = NSTextAlignmentCenter;
    if (isExp) {
        tempStr = @"";
        isExp = NO;
    }
}

- (void)taptap:(UITapGestureRecognizer *)gesture {
    if (gesture.view.tag == 3) {
        _pickAreaView.hidden = YES;
        _coverView.hidden = YES;
    }else {
        _pickAreaView.hidden = NO;
        _unitPickView.tag = gesture.view.tag;
        [_unitPickView reloadAllComponents];
        _coverView.hidden = NO;
    }
}

- (NSString *)tempCalWithFirstIndex:(NSInteger)fIndex secondIndex:(NSInteger)sIndex {
    /* CKF
     华氏度 = 32 + 摄氏度 × 1.8
     开氏度=273.16+摄氏度
     摄氏度 = (华氏度 - 32) ÷ 1.8
     */
    if (fIndex == 0 ) {
        if (sIndex == 0) {
            return [NSString stringWithFormat:@"%.10g",[showText.text doubleValue] + 0];
        }else if (sIndex == 1) {
            return [NSString stringWithFormat:@"%.10g",[showText.text doubleValue] + 273.16];
        }else if (sIndex == 2) {
            return [NSString stringWithFormat:@"%.10g",([showText.text doubleValue]*1.8 + 32)];
        }
    }else if (fIndex == 1) {
        if (sIndex == 0 ) {
            return [NSString stringWithFormat:@"%.10g",[showText.text doubleValue] - 273.16];
        }else if (sIndex == 1) {
            return [NSString stringWithFormat:@"%.10g",[showText.text doubleValue] + 0];
        }else if (sIndex == 2) {
            return [NSString stringWithFormat:@"%.10g",([showText.text doubleValue] -273.16)*1.8 + 32];
        }
    }else if (fIndex == 2) {
        if (sIndex == 0) {
            return [NSString stringWithFormat:@"%.10g",([showText.text doubleValue] -32)/1.8];
        }else if (sIndex == 1) {
            return [NSString stringWithFormat:@"%.10g",([showText.text doubleValue]- 32)/1.8 + 273.16];
        }else if (sIndex == 2) {
            return [NSString stringWithFormat:@"%.10g",[showText.text doubleValue] + 0];
        }
    }
    return @"1";
}
//UIPickView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [_currentShowArray count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [_currentShowArray[row] allKeys][0];
}
- (IBAction)pickSelect:(id)sender {
    if (_unitPickView.tag == 1) {//from
        _fromLabel.text = [_currentShowArray[[_unitPickView selectedRowInComponent:0]] allKeys][0];
        _fromShowLabel.text = [_currentShowArray[[_unitPickView selectedRowInComponent:0]] allKeys][0];
        _currentSelectedRowIndex = [_unitPickView selectedRowInComponent:0];
    }else if (_unitPickView.tag == 2) {//to
        _toLabel.text = [_currentShowArray[[_unitPickView selectedRowInComponent:0]] allKeys][0];
        _toShowLabel.text = [_currentShowArray[[_unitPickView selectedRowInComponent:0]] allKeys][0];
        _currentSelectedRowIndex2 = [_unitPickView selectedRowInComponent:0];
    }
    _pickAreaView.hidden = YES;
    _coverView.hidden = YES;
    [self resultBtnClicked:nil];
}
- (IBAction)pickUnSelect:(id)sender {
    _pickAreaView.hidden = YES;
    _coverView.hidden = YES;
}

//calcualte
- (IBAction)calculate:(UIButton *)sender {
    [MobileData checkSettings];
    if (isExp && expPressed) {
        showText.text = @"";
        tempStr = @"";
    }
    switch (sender.tag) {
        case 21://+-
            showText.text = [NSString stringWithFormat:@"%.10g",[showText.text doubleValue]*(-1)];
            break;
        case 22://EXP
            if (isExp) {
                showText.text = [NSString stringWithFormat:@"%.10g",[expString doubleValue] * pow(10, [expShowString doubleValue])];
            }
            isExp = YES;
            expPressed = YES;
            expString = showText.text;
            showText.text = [[showText.text stringByAppendingString:@" +"] stringByAppendingString:@"0"];
            
            tempStr = @"";
            break;
        case 23://C
            showText.text = @"0";
            tempStr = @"0";
            _fromValueLabel.text = @"0";
            _toValueLabel.text = @"0";
            break;
        case 24://Go
            [self resultBtnClicked:nil];
            break;
            
        default:
            break;
    }
}

@end
