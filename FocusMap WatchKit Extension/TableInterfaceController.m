//
//  TableInterfaceController.m
//  FocusMap
//
//  Created by Lasha Efremidze on 3/30/15.
//  Copyright (c) 2015 More Voltage. All rights reserved.
//

#import "TableInterfaceController.h"
#import "TableRowInterfaceController.h"
#import "MVLocation.h"

@interface TableInterfaceController ()

@property (nonatomic, weak) IBOutlet WKInterfaceTable *table;

@property (nonatomic, strong) NSArray *locations;

@end

@implementation TableInterfaceController

- (instancetype)init
{
    if (self = [super init]) {
        self.locations = @[];
        
        [self loadTable];
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

- (void)loadTable
{
    if (self.locations.count) {
        [self.table setNumberOfRows:self.locations.count withRowType:@"row"];
        
        // Create all of the table rows.
        [self.locations enumerateObjectsUsingBlock:^(MVLocation *location, NSUInteger idx, BOOL *stop) {
            TableRowInterfaceController *row = [self.table rowControllerAtIndex:idx];
            row.textLabel.text = [NSString stringWithFormat:@"%f %f", location.latitudeValue, location.longitudeValue];
            row.detailTextLabel.text = [NSString stringWithFormat:@"%f", location.averageHeartRateValue];
        }];
    } else {
        [self.table setNumberOfRows:1 withRowType:@"empty"];
    }
}

@end
