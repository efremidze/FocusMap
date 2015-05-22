//
//  MapInterfaceController.m
//  FocusMap
//
//  Created by Lasha Efremidze on 3/30/15.
//  Copyright (c) 2015 More Voltage. All rights reserved.
//

#import "MapInterfaceController.h"

#import "DataManager.h"

@import FocusMapKit;

@interface MapInterfaceController ()

@property (nonatomic, weak) IBOutlet WKInterfaceMap *map;

@end

@implementation MapInterfaceController

- (instancetype)init
{
    if (self = [super init]) {
        [DataManager refreshData:^{
            NSArray *locations = [MVDataManager sharedInstance].locations;
            [self loadWithLocations:locations];
        }];
    }
    return self;
}

- (void)awakeWithContext:(id)context
{
    [super awakeWithContext:context];
    
    // Configure interface objects here.
}

- (void)willActivate
{
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate
{
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

#pragma mark -

- (void)loadWithLocations:(NSArray *)locations
{
    MKMapRect mapRect = MKMapRectNull;
    for (MVLocation *location in locations) {
        [self.map addAnnotation:location.coordinate withPinColor:WKInterfaceMapPinColorRed];
        mapRect = MKMapRectAddAnnotation(mapRect, location);
    }
    double inset = -(mapRect.size.width * 0.6f);
    mapRect = MKMapRectInset(mapRect, inset, inset);
    [self.map setVisibleMapRect:mapRect];
}

static MKMapRect MKMapRectAddAnnotation(MKMapRect mapRect, MVLocation *location) {
    MKMapPoint point = MKMapPointForCoordinate(location.coordinate);
    MKMapRect rect = (MKMapRect){point.x, point.y, 0.1, 0.1};
    if (MKMapRectIsNull(mapRect))
        return rect;
    return MKMapRectUnion(mapRect, rect);
}
@end
