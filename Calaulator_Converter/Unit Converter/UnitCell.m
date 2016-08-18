//
//  UnitCell.m
//  Calaulator_Converter
//
//  Created by Weasley Qi on 16/8/18.
//  Copyright © 2016年 Weasley Qi. All rights reserved.
//

#import "UnitCell.h"

@implementation UnitCell
@synthesize delegate;

- (IBAction)unitSelect:(id)sender {
    [delegate unitSelect:self.tag];
}

@end
