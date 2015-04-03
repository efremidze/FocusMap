//
//  InterfaceController.m
//  FocusMap WatchKit Extension
//
//  Created by Lasha Efremidze on 3/30/15.
//  Copyright (c) 2015 More Voltage. All rights reserved.
//

#import "InterfaceController.h"

@interface InterfaceController()

@end

@implementation InterfaceController

- (void)awakeWithContext:(id)context
{
    [super awakeWithContext:context];
    
    // Configure interface objects here.
    NSMutableArray *names = [NSMutableArray array];
    NSMutableArray *contexts = [NSMutableArray array];
    
    [names addObject:@"table"];
    [contexts addObject:@0];
    
    [names addObject:@"map"];
    [contexts addObject:@1];
    
//    [WKInterfaceController reloadRootControllersWithNames:names contexts:contexts];
    [WKInterfaceController reloadRootControllersWithNames:names contexts:nil];
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

@end
