//
//  StatisticsCalViewController.m
//  Calaulator_Converter
//
//  Created by Weasley Qi on 16/7/14.
//  Copyright © 2016年 Weasley Qi. All rights reserved.
//

#import "StatisticsCalViewController.h"
#import "AddedView.h"

@interface StatisticsCalViewController ()<DeleteNumDelegate>
@property (weak, nonatomic) IBOutlet AddedView *addedView;
@property (strong, nonatomic) NSMutableArray *addedarr;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@end

@implementation StatisticsCalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _addedarr = [NSMutableArray new];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)add:(id)sender {
    float x = 15;
    float y = -80   ;
    NSInteger count = [_addedarr count];
    if (count % 2 == 0) {
        x = 15;
        y = 40*(count / 2)-60;
    }else {
        x = 15+10 + _addedView.frame.size.width;
        y = 40*(count / 2)-60;
    }

    _addedView = [[NSBundle mainBundle]loadNibNamed:@"AddedView" owner:self options:nil][0];
    _addedView.frame = CGRectMake(x, y, _addedView.frame.size.width, 40);
    _addedView.tag = [_addedarr count];
    _addedView.delegate = self;
    [_scrollView addSubview:_addedView];
    [_addedarr addObject:[NSString stringWithFormat:@"%ld",_addedView.tag]];
    
    _scrollView.showsVerticalScrollIndicator = NO;
    if (count/2*40 > _scrollView.frame.size.height) {
        _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, count/2*40);
    }
    _countLabel.text = [NSString stringWithFormat:@"Count=%lu",(unsigned long)[_addedarr count]];
}

- (void)deletenum:(NSInteger)tag {
    [_addedarr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj intValue] == tag) {
            [_addedarr removeObjectAtIndex:idx];
            
        }
    }];
    [self refreshscrollview];
    NSLog(@"count %ld",[_addedarr count]);
}

- (void)refreshscrollview {
    [[_scrollView subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [(AddedView*)obj removeFromSuperview];
    }];
    NSLog(@"%ld",[[_scrollView subviews]count]);
    
    __block NSMutableArray *tmp = [NSMutableArray new];
    [_addedarr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        float x = 15;
        float y = -80   ;
        NSInteger count = [tmp count];
        if (count % 2 == 0) {
            x = 15;
            y = 40*(count / 2)-60;
        }else {
            x = 15+10 + _addedView.frame.size.width;
            y = 40*(count / 2)-60;
        }
        
        _addedView = [[NSBundle mainBundle]loadNibNamed:@"AddedView" owner:self options:nil][0];
        _addedView.frame = CGRectMake(x, y, _addedView.frame.size.width, 40);
        _addedView.tag = [tmp count];
        _addedView.delegate = self;
        [_scrollView addSubview:_addedView];
        [tmp addObject:[NSString stringWithFormat:@"%ld",_addedView.tag]];
        
        _scrollView.showsVerticalScrollIndicator = NO;
        if (count/2*40 > _scrollView.frame.size.height) {
            _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, count/2*40);
        }
    }];
    _addedarr = tmp;
    
    
    _countLabel.text = [NSString stringWithFormat:@"Count=%lu",(unsigned long)[_addedarr count]];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
