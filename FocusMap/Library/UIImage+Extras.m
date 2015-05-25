//
//  UIImage+Extras.m
//  FocusMap
//
//  Created by Lasha Efremidze on 5/24/15.
//  Copyright (c) 2015 More Voltage. All rights reserved.
//

#import "UIImage+Extras.h"

@implementation UIImage (Extras)

+ (UIImage *)imageFromLayer:(CALayer *)layer;
{
    UIGraphicsBeginImageContextWithOptions(layer.frame.size, layer.opaque, [[UIScreen mainScreen] scale]);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
