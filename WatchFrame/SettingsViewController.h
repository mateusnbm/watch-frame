//
//  SettingsViewController.h
//  Frame It
//
//  Created by Mateus Nunes de B Magalhaes on 12/26/17.
//  Copyright © 2017 mateusnbm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WatchKind.h"

@protocol SettingsViewControllerDelegate;

@interface SettingsViewController : UITableViewController

@property (nonatomic) kWatchCase watchCaseKind;
@property (nonatomic, retain) id <SettingsViewControllerDelegate> delegate;

@end

@protocol SettingsViewControllerDelegate <NSObject>

- (void)changedWatchKind:(kWatchCase)kind;

@end
