//
//  MVDataManager.m
//  FocusMap
//
//  Created by Lasha Efremidze on 4/6/15.
//  Copyright (c) 2015 More Voltage. All rights reserved.
//

#import "MVDataManager.h"

NSString *const MVAppGroup = @"group.focusMap.Documents";
NSString *const MVSqlitePath = @"focusMap.sqlite";

@implementation MVDataManager

+ (instancetype)sharedInstance;
{
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [self new];
    });
    return _sharedInstance;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self setupCoreDataStack];
    }
    return self;
}

- (void)setupCoreDataStack
{    
    NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:MVAppGroup];
    containerURL = [containerURL URLByAppendingPathComponent:MVSqlitePath];
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreAtURL:containerURL];
}

#pragma mark -

- (NSArray *)locations
{
    if (!_locations) {
        [self refreshLocations];
    }
    return _locations;
}

- (void)refreshLocations;
{
    _locations = [self fetchLocations];
}

- (NSArray *)fetchLocations;
{
    NSManagedObjectContext *context = [NSManagedObjectContext MR_rootSavingContext];
    NSFetchRequest *request = [MVLocation MR_requestAllInContext:context];
    [request setRelationshipKeyPathsForPrefetching:@[NSStringFromSelector(@selector(visits))]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"%K > 0", NSStringFromSelector(@selector(averageHeartRate))]];
    return [MVLocation MR_executeFetchRequest:request inContext:context];
}

#pragma mark -

- (void)setImage:(UIImage *)image withName:(NSString *)name;
{
    NSURL *url = [self filePathForImageName:name];
    NSData *data = UIImagePNGRepresentation(image);
    [data writeToURL:url atomically:YES];
}

- (UIImage *)imageWithName:(NSString *)name;
{
    NSURL *url = [self filePathForImageName:name];
    NSData *data = [NSData dataWithContentsOfURL:url];
    return [UIImage imageWithData:data scale:[[UIScreen mainScreen] scale]];
}

- (NSURL *)filePathForImageName:(NSString *)name;
{
    NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:MVAppGroup];
    return [containerURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", name]];
}

@end
