//
//  MenuSearchCell.m
//  Calaulator_Converter
//
//  Created by Weasley Qi on 16/7/26.
//  Copyright © 2016年 Weasley Qi. All rights reserved.
//

#import "MenuSearchCell.h"

@implementation MenuSearchCell
@synthesize delegate;
- (IBAction)search:(id)sender {
    [delegate searchAction:sender];
}

@end
