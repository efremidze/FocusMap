//
//  DataManager.m
//  FocusMap
//
//  Created by Lasha Efremidze on 5/20/15.
//  Copyright (c) 2015 More Voltage. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager

+ (void)refreshData:(void (^)(void))completion;
{
    [WKInterfaceController openParentApplication:@{} reply:^(NSDictionary *replyInfo, NSError *error) {
        if (completion)
            completion();
    }];
}

@end
