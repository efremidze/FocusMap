//
//  InterfaceController.m
//  FocusMap WatchKit Extension
//
//  Created by Lasha Efremidze on 3/30/15.
//  Copyright (c) 2015 More Voltage. All rights reserved.
//

#import "InterfaceController.h"
#import "MVLocation.h"

@interface InterfaceController()

@property (nonatomic, strong) NSArray *locations;

@end

@implementation InterfaceController

- (instancetype)init
{
    if (self = [super init]) {
        self.locations = @[];
        
        [self loadMap];
    }
    return self;
}

- (void)awakeWithContext:(id)context
{
    [super awakeWithContext:context];
    
    // Configure interface objects here.
    [WKInterfaceController reloadRootControllersWithNames:@[@"table", @"map"] contexts:nil];
}

- (void)willActivate
{
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    // call openParentApplication:reply: and request user's location info
}

- (void)didDeactivate
{
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (void)loadMap
{
    // add annotations
    // set region
}

@end
