//
//  TableInterfaceController.m
//  FocusMap
//
//  Created by Lasha Efremidze on 3/30/15.
//  Copyright (c) 2015 More Voltage. All rights reserved.
//

#import "TableInterfaceController.h"
#import "TableRowInterfaceController.h"

#import "DataManager.h"

@import FocusMapKit;

@interface TableInterfaceController ()

@property (nonatomic, weak) IBOutlet WKInterfaceTable *table;

@end

@implementation TableInterfaceController

- (instancetype)init
{
    if (self = [super init]) {
        [DataManager refreshData:^{
            NSArray *locations = [MVDataManager sharedInstance].locations;
            [self loadWithLocations:locations];
        }];
    }
    return self;
}

- (void)awakeWithContext:(id)context
{
    [super awakeWithContext:context];
    
    // Configure interface objects here.
}

- (void)willActivate
{
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate
{
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

#pragma mark -

- (void)loadWithLocations:(NSArray *)locations
{
    if (locations.count) {
        [self.table setNumberOfRows:locations.count withRowType:@"row"];
        
        // configure rows
        [locations enumerateObjectsUsingBlock:^(MVLocation *location, NSUInteger idx, BOOL *stop) {
            TableRowInterfaceController *row = [self.table rowControllerAtIndex:idx];
            row.textLabel.text = location.name;
            row.detailTextLabel.text = [NSString stringWithFormat:@"%@ BPM", [location averageHeartRateString]];
        }];
    } else {
        [self.table setNumberOfRows:1 withRowType:@"empty"];
    }
}

@end
