#import "_MVVisit.h"

@interface MVVisit : _MVVisit {}

+ (MVVisit *)createVisitWithArrivalDate:(NSDate *)arrivalDate departureDate:(NSDate *)departureDate inContext:(NSManagedObjectContext *)context;

- (NSUInteger)duration;

@end
