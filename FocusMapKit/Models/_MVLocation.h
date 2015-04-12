// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MVLocation.h instead.

#import <CoreData/CoreData.h>

extern const struct MVLocationAttributes {
	__unsafe_unretained NSString *averageHeartRate;
	__unsafe_unretained NSString *latitude;
	__unsafe_unretained NSString *longitude;
} MVLocationAttributes;

extern const struct MVLocationRelationships {
	__unsafe_unretained NSString *visits;
} MVLocationRelationships;

@class MVVisit;

@interface MVLocationID : NSManagedObjectID {}
@end

@interface _MVLocation : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) MVLocationID* objectID;

@property (nonatomic, strong) NSNumber* averageHeartRate;

@property (atomic) double averageHeartRateValue;
- (double)averageHeartRateValue;
- (void)setAverageHeartRateValue:(double)value_;

//- (BOOL)validateAverageHeartRate:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* latitude;

@property (atomic) double latitudeValue;
- (double)latitudeValue;
- (void)setLatitudeValue:(double)value_;

//- (BOOL)validateLatitude:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* longitude;

@property (atomic) double longitudeValue;
- (double)longitudeValue;
- (void)setLongitudeValue:(double)value_;

//- (BOOL)validateLongitude:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *visits;

- (NSMutableSet*)visitsSet;

@end

@interface _MVLocation (VisitsCoreDataGeneratedAccessors)
- (void)addVisits:(NSSet*)value_;
- (void)removeVisits:(NSSet*)value_;
- (void)addVisitsObject:(MVVisit*)value_;
- (void)removeVisitsObject:(MVVisit*)value_;

@end

@interface _MVLocation (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveAverageHeartRate;
- (void)setPrimitiveAverageHeartRate:(NSNumber*)value;

- (double)primitiveAverageHeartRateValue;
- (void)setPrimitiveAverageHeartRateValue:(double)value_;

- (NSNumber*)primitiveLatitude;
- (void)setPrimitiveLatitude:(NSNumber*)value;

- (double)primitiveLatitudeValue;
- (void)setPrimitiveLatitudeValue:(double)value_;

- (NSNumber*)primitiveLongitude;
- (void)setPrimitiveLongitude:(NSNumber*)value;

- (double)primitiveLongitudeValue;
- (void)setPrimitiveLongitudeValue:(double)value_;

- (NSMutableSet*)primitiveVisits;
- (void)setPrimitiveVisits:(NSMutableSet*)value;

@end
