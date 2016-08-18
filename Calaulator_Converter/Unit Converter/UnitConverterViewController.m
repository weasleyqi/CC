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

@interface UnitConverterViewController ()<UnitSelecteDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *unitScrollView;
@property (weak, nonatomic) IBOutlet UnitCell *sbUnitCell;

@property (strong, nonatomic) NSArray *unitTitleArr;
@property (nonatomic) NSInteger currentSelectedIndex;
@end

@implementation UnitConverterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _unitTitleArr = @[@"Length",@"Temp",@"Area",@"Volume",@"Weight"];
    
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
}

- (IBAction)click1:(id)sender {
    AudioServicesPlaySystemSound(SOUNDID);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

@end
