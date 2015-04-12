#import "_MVLocation.h"

@import CoreLocation;

@interface MVLocation : _MVLocation {}

+ (MVLocation *)createLocationWithCoordinate:(CLLocationCoordinate2D)coordinate inContext:(NSManagedObjectContext *)context;
+ (MVLocation *)locationWithCoordinate:(CLLocationCoordinate2D)coordinate inContext:(NSManagedObjectContext *)context;

@end
