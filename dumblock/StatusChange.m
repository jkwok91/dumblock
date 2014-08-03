//
//  StatusChange.m
//  dumblock
//
//  Created by Jessica Kwok on 8/2/14.
//  Copyright (c) 2014 Jessica Kwok. All rights reserved.
//

#import "StatusChange.h"

@implementation StatusChange

- (instancetype)initWithState:(BOOL)state
{
    self = [super init];
    if (self) {
        NSDate *timeNow = [NSDate date];
        self.timeChanged = timeNow;
        self.locked = state;
    }
    return self;
}

- (NSString *)toStr {
    NSString *dateString = [self getTimestamp];
    NSString *status = self.locked ? @"LOCKED" : @"UNLOCKED";
    return [NSString stringWithFormat:@"%@ at %@",status,dateString];
}

- (int)getStatus {
    return self.locked ? 1 : 0;
}

- (NSString *)getTimestamp {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.YY HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:self.timeChanged];
    return dateString;
}

@end
