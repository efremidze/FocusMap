//
//  MVConstants.m
//  FocusMap
//
//  Created by Lasha Efremidze on 5/23/15.
//  Copyright (c) 2015 More Voltage. All rights reserved.
//

#import "MVConstants.h"

@implementation MVConstants

MKMapRect MKMapRectAddAnnotation(MKMapRect mapRect, MVLocation *location) {
    MKMapPoint point = MKMapPointForCoordinate(location.coordinate);
    MKMapRect rect = (MKMapRect){point.x, point.y, 0.1, 0.1};
    if (MKMapRectIsNull(mapRect))
        return rect;
    return MKMapRectUnion(mapRect, rect);
}

@end
