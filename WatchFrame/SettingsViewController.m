//
//  SettingsViewController.m
//  Frame It
//
//  Created by Mateus Nunes de B Magalhaes on 12/26/17.
//  Copyright © 2017 mateusnbm. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

#pragma mark -
#pragma mark - Lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"Settings";
    
    UIBarButtonItem *doneBarButtonItem =
        [[UIBarButtonItem alloc]
         initWithBarButtonSystemItem:UIBarButtonSystemItemDone
         target:self
         action:@selector(dismissController)];
    
    self.navigationItem.rightBarButtonItem = doneBarButtonItem;
    
}

#pragma mark -
#pragma mark - Private

- (void)dismissController {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (NSString *)caseNameForKind:(kWatchCase)kind {
    
    NSString *name;
    
    switch (kind) {
        
        case kWatchCaseGoldAluminum: name = @"Gold Aluminum"; break;
        case kWatchCaseRoseAluminum: name = @"Rose Aluminum"; break;
        case kWatchCaseSilverAluminum: name = @"Silver Aluminum"; break;
        case kWatchCaseSpaceGrayAluminum: name = @"Space Gray Aluminum"; break;
        case kWatchCaseStainlessSteel: name = @"Stainless Steel"; break;
        case kWatchCaseBlackStainlessSteel: name = @"Black Stainless Steel"; break;
        default: name = @"Gold Aluminum"; break;
            
    }
    
    return name;
    
}

- (void)purchaseAllCases {
    
    //
    
}

- (void)restorePurchases {
    
    //
    
}

#pragma mark -
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return section == 0 ? 1 : (section == 1 ? kWatchCaseCount : 2);
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *title = @"";
    
    switch (section) {
        
        case 0: title = @""; break;
        case 1: title = @"Case Selection"; break;
        case 2: title = @"In-App Purchases"; break;
        
    }
    
    return title;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * const defaultCellIdentifier = @"default-cell-identifier";
    static NSString * const accessoryLabelCellIdentifier = @"accessory-label-cell-identifier";
    
    UILabel *label;
    UITableViewCell *cell;
    
    if (indexPath.section == 0) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:accessoryLabelCellIdentifier];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:accessoryLabelCellIdentifier];
            
            label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
            label.textAlignment = NSTextAlignmentRight;
            label.textColor = UIColor.darkTextColor;
            cell.accessoryView = label;
            
        }else{
            
            label = (UILabel *) cell.accessoryView;
            
        }
        
        cell.textLabel.text = @"Version";
        label.text = @"v1.0";
        
    }else{
        
        cell = [tableView dequeueReusableCellWithIdentifier:defaultCellIdentifier];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultCellIdentifier];
            
        }
        
        if (indexPath.section == 1) {
            
            cell.textLabel.text = [self caseNameForKind:indexPath.row];
            cell.accessoryType = (indexPath.row == self.watchCaseKind ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone);
            
            if (indexPath.row > 1) {
                
                cell.userInteractionEnabled = cell.textLabel.enabled = cell.detailTextLabel.enabled = NO;
            }
            
        }else{
            
            if (indexPath.row == 0) {
                
                cell.textLabel.text = @"Unlock All Cases for $0.99";
                cell.accessoryType = UITableViewCellAccessoryNone;
                
            }else{
                
                cell.textLabel.text = @"Restore Purchases";
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            
        }
        
    }
    
    return cell;
    
}

#pragma mark -
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1 && indexPath.row != self.watchCaseKind) {
        
        // Change case selection, switch checkmarks.
        
        NSIndexPath *previousIndexPath = [NSIndexPath indexPathForRow:self.watchCaseKind inSection:1];
        UITableViewCell *previousCell = [tableView cellForRowAtIndexPath:previousIndexPath];
        UITableViewCell *currentCell = [tableView cellForRowAtIndexPath:indexPath];
        
        self.watchCaseKind = indexPath.row;
        
        previousCell.accessoryType = UITableViewCellAccessoryNone;
        currentCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        // Tell the root controller to update the displayed watch image.
        
        if ([self.delegate respondsToSelector:@selector(changedWatchKind:)]) {
            
            [self.delegate changedWatchKind:indexPath.row];
            
        }
        
    }else if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {
            
            [self purchaseAllCases];
            
        }else {
            
            [self restorePurchases];
            
        }
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
