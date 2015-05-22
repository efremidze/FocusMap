//
//  ViewController.m
//  FocusMap
//
//  Created by Lasha Efremidze on 3/30/15.
//  Copyright (c) 2015 More Voltage. All rights reserved.
//

#import "ViewController.h"

@import MapKit;

@interface ViewController ()

@property (nonatomic, weak) IBOutlet MKMapView *mapView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self load];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (void)load
{
    NSArray *locations = [MVDataManager sharedInstance].locations;
    
    MKMapRect mapRect = MKMapRectNull;
    for (MVLocation *location in locations) {
        [self addAnnotation:location];
        
        mapRect = ((^{
            MKMapPoint point = MKMapPointForCoordinate(location.coordinate);
            MKMapRect rect = (MKMapRect){point.x, point.y, 0.1, 0.1};
            return MKMapRectUnion(mapRect, rect);
        })());
    }
    [self.mapView setVisibleMapRect:mapRect];
}

- (void)addAnnotation:(MVLocation *)location
{
    MKPointAnnotation *pointAnnotation = [MKPointAnnotation new];
    pointAnnotation.coordinate = location.coordinate;
    [self.mapView addAnnotation:pointAnnotation];
}

@end
