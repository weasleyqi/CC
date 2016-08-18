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
#define SOUNDID  1109

@interface UnitConverterViewController ()<UnitSelecteDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIScrollView *unitScrollView;
@property (weak, nonatomic) IBOutlet UnitCell *sbUnitCell;

@property (strong, nonatomic) NSArray *unitTitleArr;
@property (nonatomic) NSInteger currentSelectedIndex;

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

@end

@implementation UnitConverterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    _lengthDataArray = @[@"Meter",@"Kilometer",@"Centimeter",@"Millimeter",@"Micrometer",@"Nanometer",@"Mile",@"Yard",@"Foot",@"Inch",@"Light Year"];
    _tempDataArray = @[@"Celsius",@"Kelvin",@"Farenheit"];
    _areaDataArray = @[@"Square Meter",@"Square Kilometer",@"Square Centimeter",@"Square Millimeter",@"Square Micrometer",@"Hectare",@"Square Mile",@"Square Yard",@"Square Foot",@"Square Inch",@"Acre"];
    _volumeDataArray = @[@"Cubic Meter",@"Cubic Kilometer",@"Cubic Centimeter",@"Cubic Millimeter",@"Liter",@"Milliliter",@"US Gallon",@"US Quart",@"US Pint",@"US Cup",@"US Fluid Ounce",@"US Table Spoon",@"US Tea Spoon",@"Imperial Gallon",@"Imperial Quart",@"Imperial Pint",@"Imperial Fluid Ounce",@"Imperial Tabel Spoon",@"Imperial Tea Spoon",@"Cubic Mile",@"Cubic Yard",@"Cubic Foot",@"Cubic Inch"];
    _weightDataArray = @[@"Kilogarm",@"Gram",@"Milligram",@"Metric Ton",@"Long Ton",@"Short Ton",@"Pound",@"Ounce",@"Carrat",@"Atomic Mass Unit"];
    _timeDataArray = @[@"Second",@"Millisecond",@"Microsecond",@"Nanosecond",@"Picosecond",@"Minute",@"Hour",@"Day",@"Week",@"Month",@"Year"];
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
        x = x + _sbUnitCell.frame.size.width * idx;
        CGRect rect = cell.frame;
        rect.origin.x = x;
        cell.frame = rect;
        [_unitScrollView addSubview:cell];
        
    }];
    _unitScrollView.contentSize = CGSizeMake(500, _sbUnitCell.frame.size.height);
    _currentSelectedIndex = 0;
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
    _fromLabel.text = _currentShowArray[0];
    _toLabel.text = _currentShowArray[1];
    _fromShowLabel.text = _currentShowArray[0];
    _toShowLabel.text = _currentShowArray[1];
    _fromValueLabel.text = @"0";
}

- (IBAction)click1:(id)sender {
    AudioServicesPlaySystemSound(SOUNDID);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}


- (IBAction)resultBtnClicked:(id)sender {
    
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

//UIPickView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [_currentShowArray count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _currentShowArray[row];
}
- (IBAction)pickSelect:(id)sender {
    if (_unitPickView.tag == 1) {//from
        _fromLabel.text = _currentShowArray[[_unitPickView selectedRowInComponent:0]];
        _fromShowLabel.text = _currentShowArray[[_unitPickView selectedRowInComponent:0]];
    }else if (_unitPickView.tag == 2) {//to
        _toLabel.text = _currentShowArray[[_unitPickView selectedRowInComponent:0]];
        _toShowLabel.text = _currentShowArray[[_unitPickView selectedRowInComponent:0]];
    }
    _pickAreaView.hidden = YES;
    _coverView.hidden = YES;
}
- (IBAction)pickUnSelect:(id)sender {
    _pickAreaView.hidden = YES;
    _coverView.hidden = YES;
}
@end
