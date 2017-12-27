//
//  SimpleViewController.h
//  Frame It
//
//  Created by Mateus Nunes de B Magalhaes on 12/21/17.
//  Copyright © 2017 mateusnbm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsViewController.h"

@interface SimpleViewController : UIViewController <
    UINavigationControllerDelegate,
    UIImagePickerControllerDelegate,
    SettingsViewControllerDelegate
    >

@end
