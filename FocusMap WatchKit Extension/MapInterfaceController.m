//
//  MapInterfaceController.m
//  FocusMap
//
//  Created by Lasha Efremidze on 3/30/15.
//  Copyright (c) 2015 More Voltage. All rights reserved.
//

#import "MapInterfaceController.h"

@import FocusMapKit;

@interface MapInterfaceController ()

@property (nonatomic, weak) IBOutlet WKInterfaceMap *map;

@property (nonatomic, strong) NSArray *locations;

@end

@implementation MapInterfaceController

- (instancetype)init
{
    if (self = [super init]) {
        self.locations = [MVDataManager sharedInstance].locations;
        
        [self load];
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

- (void)load
{
    MKMapRect mapRect = MKMapRectNull;
    for (MVLocation *location in self.locations) {
        MKMapPoint point = MKMapPointForCoordinate(location.coordinate);
        MKMapRect rect = (MKMapRect){point.x, point.y, 0.1, 0.1};
        mapRect = MKMapRectUnion(mapRect, rect);
        [self.map addAnnotation:location.coordinate withPinColor:WKInterfaceMapPinColorRed];
    }
    [self.map setVisibleMapRect:mapRect];
}

@end
