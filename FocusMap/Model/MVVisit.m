#import "MVVisit.h"

@interface MVVisit ()

// Private interface goes here.

@end

@implementation MVVisit

+ (MVVisit *)createVisitWithArrivalDate:(NSDate *)arrivalDate departureDate:(NSDate *)departureDate inContext:(NSManagedObjectContext *)context;
{
    MVVisit *visit = [MVVisit createInContext:context];
    visit.arrivalDate = arrivalDate;
    visit.departureDate = departureDate;
    return visit;
}

@end
