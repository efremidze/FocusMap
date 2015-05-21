//
//  DataManager.h
//  FocusMap
//
//  Created by Lasha Efremidze on 5/20/15.
//  Copyright (c) 2015 More Voltage. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface DataManager : NSObject

+ (void)refreshData:(void (^)(void))completion;

@end
