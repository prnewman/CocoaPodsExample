//
//  CMTableViewController.h
//  CityMaps
//
//  Created by Paul Newman on 12/4/12.
//  Copyright (c) 2012 CityMaps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMViewController.h"

@interface CMTableViewController : CMViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, strong) NSArray *dataProvider;
@property (nonatomic, strong) UITableView *tableView;

- (id)initWithTableStyle:(UITableViewStyle)style;
- (void)layoutSubviews;
- (UIView *)headerViewWithTitle:(NSString *)title;

@end
