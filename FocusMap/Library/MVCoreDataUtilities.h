//
//  MVCoreDataUtilities.h
//  FocusMap
//
//  Created by Lasha Efremidze on 4/1/15.
//  Copyright (c) 2015 More Voltage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MVCoreDataUtilities : NSObject

@property (nonatomic, strong) NSArray *locations;

+ (instancetype)sharedInstance;

- (void)fetchLocationsWithCompletion:(void (^)(NSArray *locations))completion;

@end
