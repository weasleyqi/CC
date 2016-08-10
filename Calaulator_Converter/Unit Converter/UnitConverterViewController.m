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
#define SOUNDID  1109

@interface UnitConverterViewController ()

@end

@implementation UnitConverterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)click1:(id)sender {
    AudioServicesPlaySystemSound(SOUNDID);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

@end
