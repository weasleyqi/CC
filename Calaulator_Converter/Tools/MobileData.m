//
//  MobileData.m
//  Calaulator_Converter
//
//  Created by Weasley Qi on 16/8/19.
//  Copyright © 2016年 Weasley Qi. All rights reserved.
//

#import "MobileData.h"

@implementation MobileData
@synthesize settingsType;

+ (MobileData *) sharedInstance
{
    static MobileData *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MobileData alloc] init];
    });
    
    return sharedInstance;
}

+ (void)checkSettings {
    switch ([MobileData sharedInstance].settingsType) {
        case SettingType_Sound:
            AudioServicesPlaySystemSound(SOUNDID);
            break;
        case SettingType_vibrate:
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            break;
        case SettingType_none:
            break;
        default:
            break;
    }
}
@end
