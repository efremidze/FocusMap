//
//  DataManager.m
//  FocusMap
//
//  Created by Lasha Efremidze on 5/20/15.
//  Copyright (c) 2015 More Voltage. All rights reserved.
//

#import "DataManager.h"

@import FocusMapKit;

NSString *const MVLastRefresh = @"focusMap-watchKit-extension.dataManager.lastRefresh";

@implementation DataManager

+ (void)refreshData:(void (^)(void))completion;
{
    BOOL shouldRefresh = [self shouldRefresh];
    if (shouldRefresh) {
        [self refreshPhoneDataWithTimeoutInterval:2.0f completion:^(BOOL finished) {
            if (finished) {
                [[MVDataManager sharedInstance] refreshLocations];
                [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:MVLastRefresh];
            }
            if (completion)
                completion();
        }];
    } else {
        if (completion)
            completion();
    }
}

+ (void)refreshPhoneDataWithTimeoutInterval:(NSTimeInterval)timeoutInterval completion:(void (^)(BOOL finished))completion
{
    __block BOOL finished = NO;
    __block BOOL cancelled = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, timeoutInterval * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if (!finished) {
            cancelled = YES;
            if (completion)
                completion(finished);
        }
    });
    
    [WKInterfaceController openParentApplication:@{} reply:^(NSDictionary *replyInfo, NSError *error) {
        if (!cancelled) {
            finished = YES;
            if (completion)
                completion(finished);
        }
    }];
}

+ (BOOL)shouldRefresh
{
    NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:MVLastRefresh];
    if (date)
        return [date compare:[NSDate dateWithTimeIntervalSinceNow:-(60 * 60)]] == NSOrderedAscending;
    return YES;
}

@end
