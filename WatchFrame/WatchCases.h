//
//  WatchCases.h
//  WatchFrame
//
//  Created by Mateus Nunes de B Magalhaes on 12/28/17.
//  Copyright © 2017 mateusnbm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WatchCases : NSObject

typedef NS_ENUM(NSInteger, kWatchCase) {
    
    kWatchCaseGoldAluminum,
    kWatchCaseRoseAluminum,
    kWatchCaseSilverAluminum,
    kWatchCaseSpaceGrayAluminum,
    
    kWatchCaseStainlessSteel,
    kWatchCaseBlackStainlessSteel,
    
    kWatchCaseCount
    
};

+ (NSInteger)count;
+ (NSString *)nameForWatchCase:(kWatchCase)watchCase;
+ (NSString *)filenameForWatchCase:(kWatchCase)watchCase;

@end
