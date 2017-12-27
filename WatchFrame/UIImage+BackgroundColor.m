//
//  UIImage+BackgroundColor.m
//  Frame It
//
//  Created by Mateus Nunes de B Magalhaes on 12/24/17.
//  Copyright © 2017 mateusnbm. All rights reserved.
//

#import "UIImage+BackgroundColor.h"

@implementation UIImage (BackgroundColor)

- (UIImage *)imageWithColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
