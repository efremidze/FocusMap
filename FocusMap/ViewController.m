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
    
    NSArray *locations = [MVDataManager sharedInstance].locations;
    [self loadWithLocations:locations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (void)loadWithLocations:(NSArray *)locations
{
    NSMutableArray *annotations = [NSMutableArray array];
    for (MVLocation *location in locations)
        [annotations addObject:[self annotationForLocation:location]];
    [self.mapView addAnnotations:annotations];
    
    MKMapRect mapRect = MKMapRectNull;
    for (MKPointAnnotation *annotation in self.mapView.annotations)
        mapRect = MKMapRectAddAnnotation(mapRect, annotation);
    double inset = -(mapRect.size.width * 0.6f);
    mapRect = MKMapRectInset(mapRect, inset, inset);
    [self.mapView setVisibleMapRect:mapRect animated:NO];
}

static MKMapRect MKMapRectAddAnnotation(MKMapRect mapRect, MKPointAnnotation *annotation) {
    MKMapPoint point = MKMapPointForCoordinate(annotation.coordinate);
    MKMapRect rect = (MKMapRect){point.x, point.y, 0.1, 0.1};
    if (MKMapRectIsNull(mapRect))
        return rect;
    return MKMapRectUnion(mapRect, rect);
}

- (MKPointAnnotation *)annotationForLocation:(MVLocation *)location
{
    MKPointAnnotation *pointAnnotation = [MKPointAnnotation new];
    pointAnnotation.coordinate = location.coordinate;
    pointAnnotation.title = [location.averageHeartRate stringValue];
    return pointAnnotation;
}

@end
