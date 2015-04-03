//
//  NSManagedObjectContext+Extras.h
//  FocusMap
//
//  Created by Lasha Efremidze on 3/30/15.
//  Copyright (c) 2015 More Voltage. All rights reserved.
//

#import "NSManagedObjectContext+Extras.h"

@implementation NSManagedObjectContext (Extras)

+ (NSManagedObjectContext *)defaultContext
{
    return [NSManagedObjectContext MR_rootSavingContext];
}

+ (NSManagedObjectContext *)backgroundContext;
{
    static NSManagedObjectContext *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSManagedObjectContext *mainContext = [NSManagedObjectContext MR_defaultContext];
        _sharedInstance = [NSManagedObjectContext MR_contextWithParent:mainContext];
        [_sharedInstance setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
        [_sharedInstance MR_setWorkingName:@"BACKGROUND"];
    });
    return _sharedInstance;
}

@end
