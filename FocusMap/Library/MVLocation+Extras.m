//
//  MVLocation+Extras.m
//  FocusMap
//
//  Created by Lasha Efremidze on 5/24/15.
//  Copyright (c) 2015 More Voltage. All rights reserved.
//

#import "MVLocation+Extras.h"

#import "UIImage+Extras.h"

@implementation MVLocation (Extras)

- (UIImage *)fetchImage;
{
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, 12, 12);
    layer.cornerRadius = layer.frame.size.width / 2.0f;
    layer.borderColor = [UIColor whiteColor].CGColor;
    layer.borderWidth = 0.5f;
    layer.backgroundColor = [UIColor redColor].CGColor;
    layer.contentsScale = [[UIScreen mainScreen] scale];
    
    NSString *imageName = [self averageHeartRateString];
    CATextLayer *textLayer = [self layerWithString:imageName];
    [layer addSublayer:textLayer];
    
    return [UIImage imageFromLayer:layer];
}

#pragma mark - Private

- (CATextLayer *)layerWithString:(NSString *)string
{
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.frame = CGRectMake(1, 1, 10, 10);
    textLayer.foregroundColor = [UIColor whiteColor].CGColor;
    textLayer.string = string;
    textLayer.fontSize = 8.0f;
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.contentsScale = [[UIScreen mainScreen] scale];
    return textLayer;
}

@end
