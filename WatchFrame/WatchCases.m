//
//  WatchCases.m
//  WatchFrame
//
//  Created by Mateus Nunes de B Magalhaes on 12/28/17.
//  Copyright © 2017 mateusnbm. All rights reserved.
//

#import "WatchCases.h"

@implementation WatchCases

#pragma mark -
#pragma mark - Private

#pragma mark -
#pragma mark - Public

+ (NSInteger)count {
    
    return kWatchCaseCount;
    
}

+ (NSString *)nameForWatchCase:(kWatchCase)watchCase {
    
    NSString *name;
    
    switch (watchCase) {
            
        case kWatchCaseGoldAluminum:        name = @"Gold Aluminum";            break;
        case kWatchCaseRoseAluminum:        name = @"Rose Aluminum";            break;
        case kWatchCaseSilverAluminum:      name = @"Silver Aluminum";          break;
        case kWatchCaseSpaceGrayAluminum:   name = @"Space Gray Aluminum";      break;
        case kWatchCaseStainlessSteel:      name = @"Stainless Steel";          break;
        case kWatchCaseBlackStainlessSteel: name = @"Black Stainless Steel";    break;
        default:                            name = @"Gold Aluminum";            break;
        
    }
    
    return name;
    
}

+ (NSString *)filenameForWatchCase:(kWatchCase)watchCase {
    
    NSString *filename;
    
    switch (watchCase) {
            
        case kWatchCaseRoseAluminum:        filename = @"watch_rose_aluminum.png";          break;
        case kWatchCaseGoldAluminum:        filename = @"watch_gold_aluminum.png";          break;
        case kWatchCaseSilverAluminum:      filename = @"watch_silver_aluminum.png";        break;
        case kWatchCaseSpaceGrayAluminum:   filename = @"watch_space_gray_aluminum.png";    break;
        case kWatchCaseStainlessSteel:      filename = @"watch_stainless_steel.png";        break;
        case kWatchCaseBlackStainlessSteel: filename = @"watch_black_stainless_steel.png";  break;
        default:                            filename = @"watch_gold_aluminum.png";          break;
        
    }
    
    return filename;
    
}

@end
