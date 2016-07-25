//
//  CALayer+Addition.h
//  Calaulator_Converter
//
//  Created by Weasley Qi on 16/7/25.
//  Copyright © 2016年 Weasley Qi. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface CALayer (Addition)

@property(nonatomic, strong) UIColor *borderColorFromUIColor;

- (void)setBorderColorFromUIColor:(UIColor *)color;

@end
