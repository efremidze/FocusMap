// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MVVisit.h instead.

#import <CoreData/CoreData.h>

extern const struct MVVisitAttributes {
	__unsafe_unretained NSString *arrivalDate;
	__unsafe_unretained NSString *departureDate;
} MVVisitAttributes;

extern const struct MVVisitRelationships {
	__unsafe_unretained NSString *location;
} MVVisitRelationships;

@class MVLocation;

@interface MVVisitID : NSManagedObjectID {}
@end

@interface _MVVisit : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) MVVisitID* objectID;

@property (nonatomic, strong) NSDate* arrivalDate;

//- (BOOL)validateArrivalDate:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* departureDate;

//- (BOOL)validateDepartureDate:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) MVLocation *location;

//- (BOOL)validateLocation:(id*)value_ error:(NSError**)error_;

@end

@interface _MVVisit (CoreDataGeneratedPrimitiveAccessors)

- (NSDate*)primitiveArrivalDate;
- (void)setPrimitiveArrivalDate:(NSDate*)value;

- (NSDate*)primitiveDepartureDate;
- (void)setPrimitiveDepartureDate:(NSDate*)value;

- (MVLocation*)primitiveLocation;
- (void)setPrimitiveLocation:(MVLocation*)value;

@end
