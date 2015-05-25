//
//  MVConstants.h
//  FocusMap
//
//  Created by Lasha Efremidze on 5/23/15.
//  Copyright (c) 2015 More Voltage. All rights reserved.
//

#import <Foundation/Foundation.h>

@import MapKit;

@interface MVConstants : NSObject

MK_EXTERN MKMapRect MKMapRectAddAnnotation(MKMapRect mapRect, MVLocation *location);

@end
