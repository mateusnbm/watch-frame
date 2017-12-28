//
//  RootViewController.h
//  WatchFrame
//
//  Created by Mateus Nunes de B Magalhaes on 12/27/17.
//  Copyright © 2017 mateusnbm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WatchCases.h"
#import "RootViewControllerProtocols.h"

@interface RootViewController : UIViewController <
    UINavigationControllerDelegate,
    UIImagePickerControllerDelegate
    >

@property (nonatomic, retain) id <RootViewControllerDelegate> delegate;

- (void)changeWatchCase:(kWatchCase)watchCase;

@end