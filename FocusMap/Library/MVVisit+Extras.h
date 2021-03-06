//
//  MVVisit+Extras.h
//  FocusMap
//
//  Created by Lasha Efremidze on 5/11/15.
//  Copyright (c) 2015 More Voltage. All rights reserved.
//

#import <FocusMapKit/FocusMapKit.h>

@interface MVVisit (Extras)

- (void)fetchAverageHeartRateWithCompletion:(void (^)(double, NSError *))completion;

- (double)fetchAverageHeartRate;

@end
