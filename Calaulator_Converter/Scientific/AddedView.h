//
//  AddedView.h
//  Calaulator_Converter
//
//  Created by Weasley Qi on 16/8/18.
//  Copyright © 2016年 Weasley Qi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DeleteNumDelegate <NSObject>

- (void)deletenum:(NSInteger)tag;

@end
@interface AddedView : UIView
@property (weak, nonatomic) IBOutlet UILabel *labelNum;

@property (nonatomic, weak) NSObject<DeleteNumDelegate>* delegate;
@end
