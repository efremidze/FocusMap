#import "_MVLocation.h"

@import UIKit;
@import CoreLocation;

@interface MVLocation : _MVLocation {}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

+ (MVLocation *)createLocationWithCoordinate:(CLLocationCoordinate2D)coordinate inContext:(NSManagedObjectContext *)context;
+ (MVLocation *)locationWithCoordinate:(CLLocationCoordinate2D)coordinate inContext:(NSManagedObjectContext *)context;

- (double)fetchAverageHeartRate;
- (NSString *)averageHeartRateString;

- (void)setImage:(UIImage *)image;
- (UIImage *)image;

@end
