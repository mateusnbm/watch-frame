//
//  Theme.h
//  WatchFrame
//
//  Created by Mateus Nunes de B Magalhaes on 12/31/17.
//  Copyright © 2017 mateusnbm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol Theme <NSObject>

- (void)themeTableView:(UITableView *)tableView;
- (void)themeTableViewCell:(UITableViewCell *)cell;

@end
