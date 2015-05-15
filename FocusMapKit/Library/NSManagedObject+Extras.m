//
//  NSManagedObject+Extras.m
//  FocusMap
//
//  Created by Lasha Efremidze on 3/30/15.
//  Copyright (c) 2015 More Voltage. All rights reserved.
//

#import "NSManagedObject+Extras.h"

@implementation NSManagedObject (Extras)

- (NSString *)detailedDescription;
{
    NSMutableArray *properties = [NSMutableArray array];
    for (id property in self.entity.properties) {
        if ([property isKindOfClass:[NSAttributeDescription class]]) {
            NSAttributeDescription *attributeDescription = (NSAttributeDescription *)property;
            NSString *name = attributeDescription.name;
            id value = [self valueForKey:name];
            [properties addObject:[NSString stringWithFormat:@"%@: %@", name, value]];
        } else if ([property isKindOfClass:[NSRelationshipDescription class]]) {
            NSRelationshipDescription *relationshipDescription = (NSRelationshipDescription *)property;
            NSString *name = relationshipDescription.name;
            
            if (relationshipDescription.isToMany) {
                NSMutableSet *managedObjectS = [self mutableSetValueForKey:name];
                [properties addObject:[NSString stringWithFormat:@"%@: %lu", name, (unsigned long)managedObjectS.count]]; // displays count
            } else {
                NSManagedObject *managedObject = [self valueForKey:name];
                NSURL *uri = [managedObject.objectID URIRepresentation];
                [properties addObject:[NSString stringWithFormat:@"%@: %@", name, uri.absoluteString]];
            }
        }
    }
    return [properties componentsJoinedByString:@", "];
}

- (void)logAsString;
{
    NSLog(@"%@: %@", [self class], [self detailedDescription]);
}

@end
