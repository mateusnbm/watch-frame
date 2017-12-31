//
//  LightTheme.m
//  WatchFrame
//
//  Created by Mateus Nunes de B Magalhaes on 12/31/17.
//  Copyright © 2017 mateusnbm. All rights reserved.
//

#import "LightTheme.h"

@implementation LightTheme

- (void)themeTableView:(UITableView *)tableView {
    
    tableView.tintColor = [UIColor colorWithRed:0 green:122/255.f blue:1 alpha:1];
    tableView.backgroundColor = UIColor.whiteColor;
    
}

- (void)themeTableViewCell:(UITableViewCell *)cell {
    
    cell.backgroundColor = UIColor.whiteColor;
    cell.textLabel.textColor = UIColor.blackColor;
    
}

@end
