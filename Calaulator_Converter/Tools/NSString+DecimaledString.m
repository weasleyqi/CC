//
//  NSString+DecimaledString.m
//  Calaulator_Converter
//
//  Created by Weasley Qi on 16/9/6.
//  Copyright © 2016年 Weasley Qi. All rights reserved.
//

#import "NSString+DecimaledString.h"

@implementation NSString (DecimaledString)
- (NSString *)decimaledString{
    NSDecimalNumber *a = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *b = [NSDecimalNumber decimalNumberWithString:@"1"];
    NSString *rst = [NSString stringWithFormat:@"%@",[a decimalNumberByMultiplyingBy:b]];
    return rst;
}
@end
