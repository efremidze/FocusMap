// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MVLocation.m instead.

#import "_MVLocation.h"

const struct MVLocationAttributes MVLocationAttributes = {
	.averageHeartRate = @"averageHeartRate",
	.latitude = @"latitude",
	.longitude = @"longitude",
	.name = @"name",
};

const struct MVLocationRelationships MVLocationRelationships = {
	.visits = @"visits",
};

@implementation MVLocationID
@end

@implementation _MVLocation

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MVLocation" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MVLocation";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MVLocation" inManagedObjectContext:moc_];
}

- (MVLocationID*)objectID {
	return (MVLocationID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"averageHeartRateValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"averageHeartRate"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"latitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"latitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"longitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"longitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

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

@dynamic latitude;

- (double)latitudeValue {
	NSNumber *result = [self latitude];
	return [result doubleValue];
}

- (void)setLatitudeValue:(double)value_ {
	[self setLatitude:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveLatitudeValue {
	NSNumber *result = [self primitiveLatitude];
	return [result doubleValue];
}

- (void)setPrimitiveLatitudeValue:(double)value_ {
	[self setPrimitiveLatitude:[NSNumber numberWithDouble:value_]];
}

@dynamic longitude;

- (double)longitudeValue {
	NSNumber *result = [self longitude];
	return [result doubleValue];
}

- (void)setLongitudeValue:(double)value_ {
	[self setLongitude:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveLongitudeValue {
	NSNumber *result = [self primitiveLongitude];
	return [result doubleValue];
}

- (void)setPrimitiveLongitudeValue:(double)value_ {
	[self setPrimitiveLongitude:[NSNumber numberWithDouble:value_]];
}

@dynamic name;

@dynamic visits;

- (NSMutableSet*)visitsSet {
	[self willAccessValueForKey:@"visits"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"visits"];

	[self didAccessValueForKey:@"visits"];
	return result;
}

@end

