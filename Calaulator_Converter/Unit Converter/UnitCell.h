//
//  UnitCell.h
//  Calaulator_Converter
//
//  Created by Weasley Qi on 16/8/18.
//  Copyright © 2016年 Weasley Qi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBLabelWithFontAdapter.h"

@protocol UnitSelecteDelegate <NSObject>

- (void)unitSelect:(NSInteger)tag;

@end

@interface UnitCell : UIView
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *bottomLine;
@property (weak, nonatomic) IBOutlet MBLabelWithFontAdapter *title1;

@property (weak, nonatomic) NSObject <UnitSelecteDelegate>*delegate;
@end
