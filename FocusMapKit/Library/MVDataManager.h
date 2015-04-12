//
//  MVDataManager.h
//  FocusMap
//
//  Created by Lasha Efremidze on 4/6/15.
//  Copyright (c) 2015 More Voltage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MVDataManager : NSObject

+ (instancetype)sharedInstance;

- (NSArray *)locations;

@end