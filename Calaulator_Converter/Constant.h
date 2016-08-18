//
//  Constant.h
//  Calaulator_Converter
//
//  Created by Weasley Qi on 16/8/19.
//  Copyright © 2016年 Weasley Qi. All rights reserved.
//

#ifndef Constant_h
#define Constant_h

#define UIColorFromRGB(rgbValue,alphaValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue]

#endif /* Constant_h */
