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

@property (nonatomic) NSInteger watchCaseKind;

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
    
    self.watchCaseKind = kWatchCaseGoldAluminum;
    
    [self setupView];
    
}

#pragma mark -
#pragma mark - Private

- (NSString *)filenameForWatchKind:(kWatchCase)kind {
    
    NSString *filename;
    
    switch (kind) {
            
        case kWatchCaseRoseAluminum: filename = @"watch_rose_aluminum.png"; break;
        case kWatchCaseGoldAluminum: filename = @"watch_gold_aluminum.png"; break;
        case kWatchCaseSilverAluminum: filename = @"watch_silver_aluminum.png"; break;
        case kWatchCaseSpaceGrayAluminum: filename = @"watch_space_gray_aluminum.png"; break;
        case kWatchCaseStainlessSteel: filename = @"watch_stainless_steel.png"; break;
        case kWatchCaseBlackStainlessSteel: filename = @"watch_black_stainless_steel.png"; break;
        default: filename = @"watch_gold_aluminum.png"; break;
            
    }
    
    return filename;
    
}

- (void)setupView {
    
    CGSize screenSize = UIScreen.mainScreen.bounds.size;
    CGPoint screenCenter = CGPointMake(screenSize.width/2, screenSize.height/2);
    
    UIColor *buttonsBackgroundColor = [UIColor colorWithRed:0 green:122/255.f blue:1 alpha:1];
    UIImage *buttonsBackgroundImage = [[UIImage alloc] imageWithColor:buttonsBackgroundColor];
    
    // Watch frame image view.
    
    CGFloat watchImageWidth = 275;
    CGFloat watchImageHeight = 306;
    NSString *watchImageName = [self filenameForWatchKind:self.watchCaseKind];
    UIImage *watchImage = [UIImage imageNamed:watchImageName];
    UIImageView *watchImageView = [[UIImageView alloc] init];
    
    watchImageView.frame = CGRectMake(0, 0, watchImageWidth, watchImageHeight);
    watchImageView.center = screenCenter;
    watchImageView.image = watchImage;
    
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
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
    
}

- (void)saveImageToCameraRoll {
    
    NSString *watchImageName = [self filenameForWatchKind:self.watchCaseKind];
    
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

- (void)changeWatchCase:(kWatchCase)watchCase {
    
    NSString *watchImageName = [self filenameForWatchKind:watchCase];
    UIImage *watchImage = [UIImage imageNamed:watchImageName];
    
    self.watchCaseKind = watchCase;
    self.watchImageView.image = watchImage;
    
}

#pragma mark -
#pragma mark - Image picker delegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *, id> *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    self.screenshotImageView.image = image;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
