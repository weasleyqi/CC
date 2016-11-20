//
//  UnitCell.m
//  Calaulator_Converter
//
//  Created by Weasley Qi on 16/8/18.
//  Copyright © 2016年 Weasley Qi. All rights reserved.
//

#import "UnitCell.h"

@interface UnitCell() {
    UIView *view;
    UIButton *btn;
    UILabel *label;
    
}

@end
@implementation UnitCell
@synthesize delegate;

- (IBAction)unitSelect:(id)sender {
    [delegate unitSelect:self.tag];
}

- (id)initWithFrame:(CGRect)frame tag:(NSInteger) tag text:(NSString *)txt{
    self = [super initWithFrame:frame];
    if (self) {
        view = [[UIView alloc] initWithFrame:CGRectMake(frame.origin.x, 0, frame.size.width, frame.size.height)];
        [self addSubview:view];
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = view.frame;
        btn.tag = tag;
        [btn addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = txt;
        [view addSubview:label];
    }
    return self;
}

- (void)tap:(UIButton *)sender {
    [delegate unitSelect:self.tag];
}
@end
