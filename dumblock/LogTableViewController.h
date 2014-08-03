//
//  LogTableViewController.h
//  dumblock
//
//  Created by Jessica Kwok on 8/2/14.
//  Copyright (c) 2014 Jessica Kwok. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>

@interface LogTableViewController : UITableViewController

@property (nonatomic,strong) NSString *firebaseURL;
@property (nonatomic,strong) Firebase *firebaseRef;

@end
