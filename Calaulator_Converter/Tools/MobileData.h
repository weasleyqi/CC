//
//  MobileData.h
//  Calaulator_Converter
//
//  Created by Weasley Qi on 16/8/19.
//  Copyright © 2016年 Weasley Qi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constant.h"

@interface MobileData : NSObject
@property (nonatomic) settingType settingsType;

+ (MobileData *) sharedInstance;
+ (void)checkSettings;
@end
