//
//  MVLocationManager.h
//  FocusMap
//
//  Created by Lasha Efremidze on 3/30/15.
//  Copyright (c) 2015 More Voltage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MVLocationManager : NSObject

@property (nonatomic, strong) CLLocationManager *locationManager;

+ (instancetype)sharedInstance;

@end
