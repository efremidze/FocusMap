// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MVVisit.m instead.

#import "_MVVisit.h"

const struct MVVisitAttributes MVVisitAttributes = {
	.arrivalDate = @"arrivalDate",
	.averageHeartRate = @"averageHeartRate",
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

	if ([key isEqualToString:@"averageHeartRateValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"averageHeartRate"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic arrivalDate;

@dynamic averageHeartRate;

- (double)averageHeartRateValue {
	NSNumber *result = [self averageHeartRate];
	return [result doubleValue];
}

- (void)setAverageHeartRateValue:(double)value_ {
	[self setAverageHeartRate:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveAverageHeartRateValue {
	NSNumber *result = [self primitiveAverageHeartRate];
	return [result doubleValue];
}

- (void)setPrimitiveAverageHeartRateValue:(double)value_ {
	[self setPrimitiveAverageHeartRate:[NSNumber numberWithDouble:value_]];
}

@dynamic departureDate;

@dynamic location;

@end

