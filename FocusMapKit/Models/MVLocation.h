#import "_MVLocation.h"

@import CoreLocation;

@interface MVLocation : _MVLocation {}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

+ (MVLocation *)createLocationWithCoordinate:(CLLocationCoordinate2D)coordinate inContext:(NSManagedObjectContext *)context;
+ (MVLocation *)locationWithCoordinate:(CLLocationCoordinate2D)coordinate inContext:(NSManagedObjectContext *)context;

- (void)refreshAverageHeartRate;

@end
