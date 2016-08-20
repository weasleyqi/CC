//
//  MenuSearchCell.h
//  Calaulator_Converter
//
//  Created by Weasley Qi on 16/7/26.
//  Copyright © 2016年 Weasley Qi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchCellDelegate <NSObject>

- (void)searchAction:(UIButton *)sender;

@end
@interface MenuSearchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *menuSearchTextField;

@property (weak, nonatomic) IBOutlet UIButton *searchBtn;

@property (nonatomic, weak) NSObject <SearchCellDelegate>*delegate;
@end
