//
//  CALayer+Addition.m
//  Calaulator_Converter
//
//  Created by Weasley Qi on 16/7/25.
//  Copyright © 2016年 Weasley Qi. All rights reserved.
//

#import "CALayer+Addition.h"
#import <objc/runtime.h>

@implementation CALayer (Addition)

- (UIColor *)borderColorFromUIColor {
    
    return objc_getAssociatedObject(self, @selector(borderColorFromUIColor));
    
}

-(void)setBorderColorFromUIColor:(UIColor *)color

{
    
    objc_setAssociatedObject(self, @selector(borderColorFromUIColor), color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self setBorderColorFromUI:[self borderColorFromUIColor]];
    
}

- (void)setBorderColorFromUI:(UIColor *)color

{
    
    self.borderColor = color.CGColor;
    
    //    NSLog(@"%@", color);
    
}

@end
