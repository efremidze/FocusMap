// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MVVisit.m instead.

#import "_MVVisit.h"

const struct MVVisitAttributes MVVisitAttributes = {
	.arrivalDate = @"arrivalDate",
	.departureDate = @"departureDate",
};

const struct MVVisitRelationships MVVisitRelationships = {
	.location = @"location",
};

@implementation MVVisitID
@end

@implementation _MVVisit

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MVVisit" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MVVisit";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MVVisit" inManagedObjectContext:moc_];
}

- (MVVisitID*)objectID {
	return (MVVisitID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic arrivalDate;

@dynamic departureDate;

@dynamic location;

@end

