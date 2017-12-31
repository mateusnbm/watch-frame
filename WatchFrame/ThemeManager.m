//
//  ThemeManager.m
//  WatchFrame
//
//  Created by Mateus Nunes de B Magalhaes on 12/31/17.
//  Copyright © 2017 mateusnbm. All rights reserved.
//

#import "ThemeManager.h"
#import "DarkTheme.h"
#import "LightTheme.h"

@implementation ThemeManager

+ (id <Theme>)theme {
    
    return [[DarkTheme alloc] init];
    
}

@end
