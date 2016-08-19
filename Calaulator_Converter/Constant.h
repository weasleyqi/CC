//
//  Constant.h
//  Calaulator_Converter
//
//  Created by Weasley Qi on 16/8/19.
//  Copyright © 2016年 Weasley Qi. All rights reserved.
//

#ifndef Constant_h
#define Constant_h

#import <AudioToolbox/AudioToolbox.h> //声音提示
//#import "MobileData.h"

#define SOUNDID  1103

#define UIColorFromRGB(rgbValue,alphaValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue]

typedef enum {
    SettingType_Sound = 0,
    SettingType_vibrate = 1,
    SettingType_none = 2
}settingType;

#endif /* Constant_h */
