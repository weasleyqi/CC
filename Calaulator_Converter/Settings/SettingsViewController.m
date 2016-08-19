//
//  SettingsViewController.m
//  Calaulator_Converter
//
//  Created by Weasley Qi on 16/7/14.
//  Copyright © 2016年 Weasley Qi. All rights reserved.
//

#import "SettingsViewController.h"
#import "Constant.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet UIView *pickAreaView;
@property (weak, nonatomic) IBOutlet UIPickerView *startMenuPickView;

@property (weak, nonatomic) IBOutlet UIView *soundView;
@property (weak, nonatomic) IBOutlet UIView *vibrateView;
@property (weak, nonatomic) IBOutlet UIView *effectNoneView;

@property (weak, nonatomic) IBOutlet UIView *startMenuView;
@property (weak, nonatomic) IBOutlet UILabel *soundLabel;
@property (weak, nonatomic) IBOutlet UIImageView *soundImage;
@property (weak, nonatomic) IBOutlet UILabel *vibrateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *vibrateImage;
@property (weak, nonatomic) IBOutlet UILabel *effectNoneLabel;
@property (weak, nonatomic) IBOutlet UIImageView *effectNoneImage;

@property (weak, nonatomic) IBOutlet UILabel *startMenuLabel;
@property (strong, nonatomic) NSArray *startMenuArray;
@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taptap:)];
    UITapGestureRecognizer *gesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taptap:)];
    UITapGestureRecognizer *gesture3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taptap:)];
    UITapGestureRecognizer *gesture4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taptap:)];
    _soundView.tag = 1001;
    _vibrateView.tag = 1002;
    _effectNoneView.tag = 1003;
    _startMenuView.tag = 1004;
    [_soundView addGestureRecognizer:gesture];
    [_vibrateView addGestureRecognizer:gesture2];
    [_effectNoneView addGestureRecognizer:gesture3];
    [_startMenuView addGestureRecognizer:gesture4];
    
    _startMenuArray = @[@"Menu",@"Scientific Calculator",@"Statistics Calculator",@"Unit Converter",@"Currency Converter"];
    [self sectionSelected:_soundView isSelected:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *settings = [userDefaults stringForKey:@"settings"];
    switch ([settings integerValue]) {
        case 1:
            [self sectionSelected:_soundView isSelected:YES];
            break;
        case 2:
            [self sectionSelected:_vibrateView isSelected:YES];
            break;
        case 3:
            [self sectionSelected:_effectNoneView isSelected:YES];
            break;
            
        default:
            break;
    }
    
    NSUserDefaults *userDefaults2 = [NSUserDefaults standardUserDefaults];
    NSString *stMenu = [userDefaults2 stringForKey:@"startMenu"];
    _startMenuLabel.text = _startMenuArray[[stMenu integerValue]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)taptap:(UITapGestureRecognizer *)gesture {
    NSInteger selectedSection = 0;
    switch (gesture.view.tag) {
        case 1001:
            [self sectionSelected:_soundView isSelected:YES];
            selectedSection = 1;
            break;
        case 1002:
            [self sectionSelected:_vibrateView isSelected:YES];
            selectedSection = 2;
            break;
        case 1003:
            [self sectionSelected:_effectNoneView isSelected:YES];
            selectedSection = 3;
            break;
        case 1004:
            _pickAreaView.hidden = NO;
            [_startMenuPickView reloadAllComponents];
            _coverView.hidden = NO;
            break;
            
        default:
            break;
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithInteger:selectedSection] forKey:@"settings"];
}

- (void)sectionSelected:(UIView *)view isSelected:(BOOL)isSelected {
    if (isSelected) {
        if (view.tag == 1001) {
            _soundLabel.textColor = UIColorFromRGB(0x2485C9, 1);
            _soundImage.image = [UIImage imageNamed:@"check.png"];
            _vibrateLabel.textColor = UIColorFromRGB(0x293645, 1);
            _vibrateImage.image = [UIImage imageNamed:@"unchecked.png"];
            _effectNoneLabel.textColor = UIColorFromRGB(0x293645, 1);
            _effectNoneImage.image = [UIImage imageNamed:@"unchecked.png"];
        }
        if (view.tag == 1002) {
            _vibrateLabel.textColor = UIColorFromRGB(0x2485C9, 1);
            _vibrateImage.image = [UIImage imageNamed:@"check.png"];
            _soundLabel.textColor = UIColorFromRGB(0x293645, 1);
            _soundImage.image = [UIImage imageNamed:@"unchecked.png"];
            _effectNoneLabel.textColor = UIColorFromRGB(0x293645, 1);
            _effectNoneImage.image = [UIImage imageNamed:@"unchecked.png"];
        }
        if (view.tag == 1003) {
            _effectNoneLabel.textColor = UIColorFromRGB(0x2485C9, 1);
            _effectNoneImage.image = [UIImage imageNamed:@"check.png"];
            _vibrateLabel.textColor = UIColorFromRGB(0x293645, 1);
            _vibrateImage.image = [UIImage imageNamed:@"unchecked.png"];
            _soundLabel.textColor = UIColorFromRGB(0x293645, 1);
            _soundImage.image = [UIImage imageNamed:@"unchecked.png"];
        }
    }
}

- (IBAction)pickSelect:(id)sender {
    _startMenuLabel.text = _startMenuArray[[_startMenuPickView selectedRowInComponent:0]] ;
    _pickAreaView.hidden = YES;
    _coverView.hidden = YES;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithInteger:[_startMenuPickView selectedRowInComponent:0]] forKey:@"startMenu"];
    
}

- (IBAction)pickUnSelect:(id)sender {
    _pickAreaView.hidden = YES;
    _coverView.hidden = YES;
}

//pickView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [_startMenuArray count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _startMenuArray[row];
}

@end
