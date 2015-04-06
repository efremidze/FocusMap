//
//  TableRowInterfaceController.h
//  FocusMap
//
//  Created by Lasha Efremidze on 4/5/15.
//  Copyright (c) 2015 More Voltage. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface TableRowInterfaceController : NSObject

@property (nonatomic, weak) IBOutlet WKInterfaceLabel *textLabel;
@property (nonatomic, weak) IBOutlet WKInterfaceLabel *detailTextLabel;

@end
