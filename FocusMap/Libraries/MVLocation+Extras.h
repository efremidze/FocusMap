//
//  MVLocation+Extras.h
//  FocusMap
//
//  Created by Lasha Efremidze on 4/6/15.
//  Copyright (c) 2015 More Voltage. All rights reserved.
//

#import <FocusMapKit/FocusMapKit.h>

@interface MVLocation (Extras)

- (void)averageHeartRateWithCompletion:(void (^)(NSNumber *averageHeartRate))completion;

- (void)reverseGeocodeLocationWithCompletion:(void (^)(NSString *name))completion;

@end
