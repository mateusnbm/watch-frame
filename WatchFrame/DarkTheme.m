//
//  DarkTheme.m
//  WatchFrame
//
//  Created by Mateus Nunes de B Magalhaes on 12/31/17.
//  Copyright © 2017 mateusnbm. All rights reserved.
//

#import "DarkTheme.h"

@implementation DarkTheme

- (void)themeTableView:(UITableView *)tableView {
    
    tableView.tintColor = UIColor.orangeColor;
    tableView.backgroundColor = UIColor.blackColor;
    
}

- (void)themeTableViewCell:(UITableViewCell *)cell {
    
    cell.backgroundColor = [UIColor colorWithRed:20/255.f green:20/255.f blue:20/255.f alpha:1];
    cell.textLabel.textColor = UIColor.whiteColor;
    
}

@end
