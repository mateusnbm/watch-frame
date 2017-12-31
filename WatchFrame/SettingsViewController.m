//
//  SettingsViewController.m
//  Frame It
//
//  Created by Mateus Nunes de B Magalhaes on 12/26/17.
//  Copyright © 2017 mateusnbm. All rights reserved.
//

#import "SettingsViewController.h"
#import "ThemeManager.h"

@interface SettingsViewController ()

@property (nonatomic) BOOL shouldLockPremiumCases;
@property (nonatomic) BOOL shouldShowProductAccessoryLabel;
@property (nonatomic) BOOL shouldShowProductActivityIndicator;
@property (nonatomic) BOOL shouldShowRestoreActivityIndicator;

@property (nonatomic, retain) NSString *productAccessoryLabelText;

@property (nonatomic, retain) UISelectionFeedbackGenerator *tapticGenerator;

@end

@implementation SettingsViewController

#pragma mark -
#pragma mark - Lifecycle

- (id)initWithStyle:(UITableViewStyle)style {
    
    self = [super initWithStyle:style];
    
    if (self) {
        
        self.shouldLockPremiumCases = YES;
        self.shouldShowProductAccessoryLabel = NO;
        self.shouldShowProductActivityIndicator = YES;
        self.shouldShowRestoreActivityIndicator = NO;
        
        [[ThemeManager theme] themeTableView:self.tableView];
        
        if (UIFeedbackGenerator.class) {
            
            self.tapticGenerator = [[UISelectionFeedbackGenerator alloc] init];
            
            [self.tapticGenerator prepare];
            
        }
        
    }
    
    return self;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [[ThemeManager theme] themeTableViewCell:cell];
    
}

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
    
    if ([self.delegate respondsToSelector:@selector(settingsViewControllerDidTapDone)]) {
        
        [self.delegate settingsViewControllerDidTapDone];
        
    }
    
}

- (void)purchaseAllCases {
    
    if ([self.delegate respondsToSelector:@selector(settingsViewControllerDidTapUnlockAllCases)]) {
        
        [self.delegate settingsViewControllerDidTapUnlockAllCases];
        
    }
    
}

- (void)restorePurchases {
    
    if ([self.delegate respondsToSelector:@selector(settingsViewControllerDidTapRestorePurchases)]) {
        
        [self.delegate settingsViewControllerDidTapRestorePurchases];
        
    }
    
}

#pragma mark -
#pragma mark - Public

- (void)lockPremiumCases {
    
    self.shouldLockPremiumCases = YES;
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

- (void)unlockPremiumCases {
    
    self.shouldLockPremiumCases = NO;
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

- (void)showProductActivityIndicator {
    
    self.shouldShowProductAccessoryLabel = NO;
    self.shouldShowProductActivityIndicator = YES;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

- (void)showProductAccessoryLabelWithText:(NSString *)text {
    
    self.productAccessoryLabelText = text;
    self.shouldShowProductAccessoryLabel = YES;
    self.shouldShowProductActivityIndicator = NO;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

- (void)showRestoreActivityIndicator {
    
    self.shouldShowRestoreActivityIndicator = YES;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

- (void)hideRestoreActivityIndicator {
    
    self.shouldShowRestoreActivityIndicator = NO;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

#pragma mark -
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return section == 0 ? WatchCases.count : (section == 1 ? 2 : 1);
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *title = @"";
    
    switch (section) {
        
        case 0: title = @"Case Selection"; break;
        case 1: title = @"In-App Purchases"; break;
        case 2: title = @"About"; break;
        
    }
    
    return title;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * const cellIdentifierDefault = @"ci-default";
    static NSString * const cellIdentifierAccessoryLabel = @"ci-accessory-label";
    static NSString * const cellIdentifierActivityIndicator = @"ci-activity-indicator";
    
    UITableViewCell *cell;
    UILabel *label;
    UIActivityIndicatorView *indicator;
    
    BOOL cellDisabled = NO;
    NSString *cellIdentifier;
    NSString *cellTextLabelText;
    NSString *cellAccessoryLabelText;
    UIColor *cellAccessoryLabelTextColor = [UIColor blackColor];
    UITableViewCellAccessoryType cellAccessoryType = UITableViewCellAccessoryNone;
    
    if (indexPath.section == 0) {
        
        cellDisabled = (indexPath.row > 0 && self.shouldLockPremiumCases == YES) ? YES : NO;
        cellIdentifier = cellIdentifierDefault;
        cellTextLabelText = [WatchCases nameForWatchCase:indexPath.row];
        cellAccessoryType = (indexPath.row == self.selectedCase ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone);
        
    }else if (indexPath.section == 1 && indexPath.row == 0) {
        
        if (self.shouldShowProductActivityIndicator == YES) {
            
            cellIdentifier = cellIdentifierActivityIndicator;
            cellTextLabelText = @"Unlock All Cases";
            
        }else{
            
            cellIdentifier = cellIdentifierAccessoryLabel;
            cellTextLabelText = @"Unlock All Cases";
            cellAccessoryLabelText = self.productAccessoryLabelText;
            cellAccessoryLabelTextColor = UIColor.darkGrayColor;
            
        }
        
    }else if (indexPath.section == 1 && indexPath.row == 1) {
        
        if (self.shouldShowRestoreActivityIndicator == YES) {
            
            cellIdentifier = cellIdentifierActivityIndicator;
            cellTextLabelText = @"Restore Purchases";
            
        }else{
            
            cellIdentifier = cellIdentifierDefault;
            cellTextLabelText = @"Restore Purchases";
            cellAccessoryType = UITableViewCellAccessoryNone;
            
        }
        
    }else{
        
        cellIdentifier = cellIdentifierAccessoryLabel;
        cellTextLabelText = @"Version";
        cellAccessoryLabelText = @"v1.0";
        
    }
    
    if ([cellIdentifier isEqualToString:cellIdentifierDefault]) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierDefault];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierDefault];
            
        }
        
        cell.textLabel.text = cellTextLabelText;
        cell.accessoryType = cellAccessoryType;
        
    }
    
    if ([cellIdentifier isEqualToString:cellIdentifierAccessoryLabel]) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierAccessoryLabel];
        
        if (cell == nil) {
            
            label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
            label.textAlignment = NSTextAlignmentRight;
            label.textColor = UIColor.darkTextColor;
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierAccessoryLabel];
            cell.accessoryView = label;
            
        }else{
            
            label = (UILabel *) cell.accessoryView;
            
        }
        
        cell.textLabel.text = cellTextLabelText;
        label.text = cellAccessoryLabelText;
        label.textColor = cellAccessoryLabelTextColor;
        
    }
    
    if ([cellIdentifier isEqualToString:cellIdentifierActivityIndicator]) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierActivityIndicator];
        
        if (cell == nil) {
            
            indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            indicator.hidesWhenStopped = NO;
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierActivityIndicator];
            cell.accessoryView = indicator;
            
        }else{
            
            indicator = (UIActivityIndicatorView *) cell.accessoryView;
            
        }
        
        cell.textLabel.text = cellTextLabelText;
        [indicator startAnimating];
        
    }
    
    if (cellDisabled == YES) {
        
        cell.userInteractionEnabled = cell.textLabel.enabled = cell.detailTextLabel.enabled = NO;
    }
    
    return cell;
    
}

#pragma mark -
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && indexPath.row != self.selectedCase) {
        
        if (UIFeedbackGenerator.class) [self.tapticGenerator selectionChanged];
        
        // Change case selection, switch checkmarks.
        
        NSIndexPath *previousIndexPath = [NSIndexPath indexPathForRow:self.selectedCase inSection:0];
        UITableViewCell *previousCell = [tableView cellForRowAtIndexPath:previousIndexPath];
        UITableViewCell *currentCell = [tableView cellForRowAtIndexPath:indexPath];
        
        self.selectedCase = indexPath.row;
        
        previousCell.accessoryType = UITableViewCellAccessoryNone;
        currentCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        // Tell the root controller to update the displayed watch image.
        
        if ([self.delegate respondsToSelector:@selector(settingsViewControllerDidSelectNewWatchCase:)]) {
            
            [self.delegate settingsViewControllerDidSelectNewWatchCase:indexPath.row];
            
        }
        
    }else if (indexPath.section == 1 && indexPath.row == 0) {
        
        [self purchaseAllCases];
        
    }else if (indexPath.section == 1 && indexPath.row == 1) {
        
        [self restorePurchases];
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
