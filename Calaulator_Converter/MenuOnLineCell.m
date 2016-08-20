//
//  MenuOnLineCell.m
//  Calaulator_Converter
//
//  Created by Weasley Qi on 16/7/23.
//  Copyright © 2016年 Weasley Qi. All rights reserved.
//

#import "MenuOnLineCell.h"

@implementation MenuOnLineCell
@synthesize delegate;

- (IBAction)btnClicked:(UIButton *)sender {
    [delegate changeStatus:sender];
}

@end
