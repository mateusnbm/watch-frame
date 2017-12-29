//
//  RootViewControllerProtocols.h
//  WatchFrame
//
//  Created by Mateus Nunes de B Magalhaes on 12/27/17.
//  Copyright © 2017 mateusnbm. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RootViewControllerDelegate <NSObject>

- (void)rootViewControllerDidTapSettings;
- (void)rootViewControllerDidTapImageSelection;

@end
