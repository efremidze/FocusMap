#import "MVVisit.h"

NSUInteger const MVDuration = 60 * 60;

@interface MVVisit ()

// Private interface goes here.

@end

@implementation MVVisit

+ (MVVisit *)createVisitWithArrivalDate:(NSDate *)arrivalDate departureDate:(NSDate *)departureDate inContext:(NSManagedObjectContext *)context;
{
    MVVisit *visit = [MVVisit MR_createEntityInContext:context];
    visit.arrivalDate = arrivalDate;
    visit.departureDate = departureDate;
    return visit;
}

- (NSUInteger)duration;
{
    return [self.departureDate timeIntervalSinceDate:self.arrivalDate] / MVDuration;
}

@end
