#import "MVLocation.h"

static double const kDegrees = 0.001;

@interface MVLocation ()

// Private interface goes here.

@end

@implementation MVLocation

+ (MVLocation *)createLocationWithCoordinate:(CLLocationCoordinate2D)coordinate inContext:(NSManagedObjectContext *)context;
{
    MVLocation *location = [MVLocation locationWithCoordinate:coordinate inContext:context];
    if (!location) {
        location = [MVLocation MR_createEntityInContext:context];
        location.latitudeValue = coordinate.latitude;
        location.longitudeValue = coordinate.longitude;
    }
    return location;
}

+ (MVLocation *)locationWithCoordinate:(CLLocationCoordinate2D)coordinate inContext:(NSManagedObjectContext *)context;
{
    NSPredicate *latitudePredicate = [NSPredicate predicateWithFormat:@"%K >= %@ && %K <= %@",
                                      NSStringFromSelector(@selector(latitude)),
                                      @(coordinate.latitude - kDegrees),
                                      NSStringFromSelector(@selector(latitude)),
                                      @(coordinate.latitude + kDegrees)];
    NSPredicate *longitudePredicate = [NSPredicate predicateWithFormat:@"%K >= %@ && %K <= %@",
                                       NSStringFromSelector(@selector(longitude)),
                                       @(coordinate.longitude - kDegrees),
                                       NSStringFromSelector(@selector(longitude)),
                                       @(coordinate.longitude + kDegrees)];
    NSCompoundPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[latitudePredicate, longitudePredicate]];
    NSFetchRequest *request = [MVLocation MR_requestFirstWithPredicate:predicate inContext:context];
    [request setRelationshipKeyPathsForPrefetching:@[NSStringFromSelector(@selector(visits))]];
    return [MVLocation MR_executeFetchRequestAndReturnFirstObject:request inContext:context];
}

#pragma mark -

- (CLLocationCoordinate2D)coordinate;
{
    return CLLocationCoordinate2DMake(self.latitudeValue, self.longitudeValue);
}

#pragma mark -

- (void)refreshAverageHeartRate;
{
    NSUInteger totalDuration = 0;
    NSUInteger totalAverageHeartRate = 0;
    
    for (MVVisit *visit in self.visits) {
        NSUInteger duration = [visit duration];
        totalDuration += duration;
        
        NSUInteger averageHeartRate = visit.averageHeartRateValue;
        averageHeartRate *= duration;
        totalAverageHeartRate += averageHeartRate;
    }
    
    self.averageHeartRateValue = totalAverageHeartRate / totalDuration;
}

@end
