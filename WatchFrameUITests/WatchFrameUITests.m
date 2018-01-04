//
//  WatchFrameUITests.m
//  WatchFrameUITests
//
//  Created by Mateus Nunes de B Magalhaes on 1/3/18.
//  Copyright © 2018 mateusnbm. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WatchFrameUITests-Swift.h"

@interface WatchFrameUITests : XCTestCase

@property (nonatomic, retain) XCUIApplication *application;

@end

@implementation WatchFrameUITests

- (void)setUp {
    
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    
    self.application = [[XCUIApplication alloc] init];
    [Snapshot setupSnapshot:self.application];
    [self.application launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    
}

- (void)tearDown {
    
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    
    [super tearDown];
    
}

- (void)testAppStoreScreenshots {
    
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    [app.navigationBars[@"Watch Frame"].buttons[@"settings icon"] tap];
    [Snapshot snapshot:@"1-settings" timeWaitingForIdle:2];
    
    [app.navigationBars[@"Settings"].buttons[@"Done"] tap];
    [Snapshot snapshot:@"0-home" timeWaitingForIdle:2];
    
}

@end
