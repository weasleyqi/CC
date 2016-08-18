//
//  AddedView.m
//  Calaulator_Converter
//
//  Created by Weasley Qi on 16/8/18.
//  Copyright © 2016年 Weasley Qi. All rights reserved.
//

#import "AddedView.h"

@implementation AddedView
@synthesize delegate;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)deletea:(id)sender {
    [delegate deletenum:self.tag];
    NSLog(@"delegate %ld",self.tag);
}
@end
