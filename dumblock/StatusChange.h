//
//  StatusChange.h
//  dumblock
//  this is a class to represent the state of the lock.
//  and when it was set to that state.
//
//  Created by Jessica Kwok on 8/2/14.
//  Copyright (c) 2014 Jessica Kwok. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatusChange : NSObject

@property (nonatomic,assign) BOOL locked;
@property (nonatomic,strong) NSDate *timeChanged;

- (instancetype)initWithState:(BOOL)state;
- (int)getStatus;
- (NSString *)getTimestamp;
- (NSString *)toStr;

@end
