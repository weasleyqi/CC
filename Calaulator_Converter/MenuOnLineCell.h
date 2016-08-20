//
//  MenuOnLineCell.h
//  Calaulator_Converter
//
//  Created by Weasley Qi on 16/7/23.
//  Copyright © 2016年 Weasley Qi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol pinUnpinChangeDelegate <NSObject>

- (void)changeStatus:(UIButton *)sender;

@end
@interface MenuOnLineCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *onLineLabel;
@property (weak, nonatomic) IBOutlet UIButton *statusBtn;

@property (weak, nonatomic) NSObject <pinUnpinChangeDelegate>*delegate;
@end
