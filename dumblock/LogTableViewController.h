//
//  LogTableViewController.h
//  dumblock
//
//  Created by Jessica Kwok on 8/2/14.
//  Copyright (c) 2014 Jessica Kwok. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface LogTableViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UILabel *status;
@property (strong, nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *logDB;

@end
