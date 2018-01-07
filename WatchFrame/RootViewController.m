//
//  RootViewController.m
//  WatchFrame
//
//  Created by Mateus Nunes de B Magalhaes on 12/27/17.
//  Copyright © 2017 mateusnbm. All rights reserved.
//

#import "RootViewController.h"
#import "WatchCases.h"
#import "UIImage+BackgroundColor.h"

@interface RootViewController ()

@property (nonatomic, retain) UIButton *pickButton;
@property (nonatomic, retain) UIButton *saveButton;

@property (nonatomic, retain) UIImageView *watchImageView;
@property (nonatomic, retain) UIImageView *screenshotImageView;

@end

@implementation RootViewController

#pragma mark -
#pragma mark - Lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIImage *settingsImage = [UIImage imageNamed:@"settings-icon.png"];
    
    UIBarButtonItem *settingsBarButtonItem =
        [[UIBarButtonItem alloc]
         initWithImage:settingsImage
         style:UIBarButtonItemStylePlain
         target:self
         action:@selector(openSettingsController)];
    
    self.title = @"Watch Frame";
    self.navigationItem.leftBarButtonItem = settingsBarButtonItem;
    
    [self setupView];
    
}

#pragma mark -
#pragma mark - Private

- (void)setupView {
    
    CGSize screenSize = UIScreen.mainScreen.bounds.size;
    CGPoint screenCenter = CGPointMake(screenSize.width/2, screenSize.height/2);
    
    UIColor *buttonsBackgroundColor = [UIColor colorWithRed:0 green:122/255.f blue:1 alpha:1];
    UIImage *buttonsBackgroundImage = [[UIImage alloc] imageWithColor:buttonsBackgroundColor];
    
    // Watch frame image view.
    
    CGFloat watchImageWidth = 275;
    CGFloat watchImageHeight = 306;
    NSString *watchImageName = [WatchCases filenameForWatchCase:self.selectedCase];
    UIImage *watchImage = [UIImage imageNamed:watchImageName];
    UIImageView *watchImageView = [[UIImageView alloc] init];
    
    //
    // Attempt to fix Apple Review issue (showing an apple product) by
    // displying only a blacked out version of the watch mockup.
    //
    // Comment this line up and uncomment code in didChangeWatchCase: to revert.
    //
    watchImage = [UIImage imageNamed:@"watch-blacked-out.png"];
    
    watchImageView.frame = CGRectMake(0, 0, watchImageWidth, watchImageHeight);
    watchImageView.center = screenCenter;
    watchImageView.image = watchImage;
    watchImageView.backgroundColor = UIColor.clearColor;
    
    [self.view addSubview:watchImageView];
    
    // Screenshot image view.
    
    CGFloat screenshotImageWidth = 177;
    CGFloat screenshotImageHeight = 221;
    CGFloat screenshotImageX = (screenSize.width-watchImageWidth)/2 + 13 + (58/2);
    CGFloat screenshotImageY = (screenSize.height-screenshotImageHeight)/2;
    UIImageView *screenshotImageView = [[UIImageView alloc] init];
    
    screenshotImageView.frame = CGRectMake(screenshotImageX, screenshotImageY, screenshotImageWidth, screenshotImageHeight);
    
    [self.view addSubview:screenshotImageView];
    
    // Pick image button.
    
    CGFloat pickImageButtonWidth = 120;
    CGFloat pickImageButtonHeight = 50;
    CGFloat pickImageButtonX = (screenSize.width/2)-pickImageButtonWidth-10;
    CGFloat pickImageButtonY = (screenSize.height-pickImageButtonHeight-30);
    UIButton *pickImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    pickImageButton.frame = CGRectMake(pickImageButtonX, pickImageButtonY, pickImageButtonWidth, pickImageButtonHeight);
    pickImageButton.layer.cornerRadius = 4;
    pickImageButton.layer.masksToBounds = YES;
    pickImageButton.backgroundColor = [UIColor colorWithRed:0 green:122/255.f blue:1 alpha:1];
    [pickImageButton setBackgroundImage:buttonsBackgroundImage forState:UIControlStateNormal];
    [pickImageButton setTitle:@"Pick Image" forState:UIControlStateNormal];
    [pickImageButton addTarget:self action:@selector(showImagePicker) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:pickImageButton];
    
    // Save to camera roll button.
    
    CGFloat saveImageButtonWidth = 120;
    CGFloat saveImageButtonHeight = 50;
    CGFloat saveImageButtonX = (screenSize.width/2)+10;
    CGFloat saveImageButtonY = (screenSize.height-pickImageButtonHeight-30);
    UIButton *saveImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    saveImageButton.frame = CGRectMake(saveImageButtonX, saveImageButtonY, saveImageButtonWidth, saveImageButtonHeight);
    saveImageButton.layer.cornerRadius = 4;
    saveImageButton.layer.masksToBounds = YES;
    [saveImageButton setBackgroundImage:buttonsBackgroundImage forState:UIControlStateNormal];
    [saveImageButton setTitle:@"Save Image" forState:UIControlStateNormal];
    [saveImageButton addTarget:self action:@selector(saveImageToCameraRoll) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:saveImageButton];
    
    // Keep references.
    
    self.pickButton = pickImageButton;
    self.saveButton = saveImageButton;
    self.watchImageView = watchImageView;
    self.screenshotImageView = screenshotImageView;
    
}

- (void)openSettingsController {
    
    if ([self.delegate respondsToSelector:@selector(rootViewControllerDidTapSettings)]) {
        
        [self.delegate rootViewControllerDidTapSettings];
        
    }
    
}

- (void)showImagePicker {
    
    if ([self.delegate respondsToSelector:@selector(rootViewControllerDidTapImageSelection)]) {
        
        [self.delegate rootViewControllerDidTapImageSelection];
        
    }
    
}

- (void)saveImageToCameraRoll {
    
    //
    // Uncomment the code below when generating app store screenshots
    // in order to display the watch frame with an image selected.
    //
    // #warning Comment out in production.
    // self.screenshotImageView.image = [UIImage imageNamed:@"watch-screenshot.png"];
    // return;
    
    NSString *watchImageName = [WatchCases filenameForWatchCase:self.selectedCase];
    
    UIImage *image1 = self.screenshotImageView.image;
    UIImage *image2 = [UIImage imageNamed:watchImageName];
    
    CGFloat padding = 50;
    CGFloat fullPadding = padding*2;
    
    CGSize imageSize = CGSizeMake(image2.size.width+fullPadding, image2.size.height+fullPadding);
    
    UIGraphicsBeginImageContext(imageSize);
    [image2 drawInRect:CGRectMake(padding, padding, image2.size.width, image2.size.height)];
    [image1 drawInRect:CGRectMake(padding + 84, padding + 84, 177*2, 221*2)];
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageWriteToSavedPhotosAlbum(finalImage, nil, nil, nil);
    
}

#pragma mark -
#pragma mark - Public

- (void)didChangeWatchCase:(kWatchCase)watchCase {
    
    self.selectedCase = watchCase;
    
    //
    // Commented out in order to keep the blacked out version of
    // watch mockups visible all the times.
    //
    // NSString *watchImageName = [WatchCases filenameForWatchCase:watchCase];
    // UIImage *watchImage = [UIImage imageNamed:watchImageName];
    // self.watchImageView.image = watchImage;
    //
    
}

- (void)didChangeImageSelection:(UIImage *)image {
    
    self.screenshotImageView.image = image;
    
}

@end
