//
//  LogTableViewController.m
//  dumblock
//
//  Created by Jessica Kwok on 8/2/14.
//  Copyright (c) 2014 Jessica Kwok. All rights reserved.
//

#import "LogTableViewController.h"
#import "StatusChange.h"

@interface LogTableViewController ()

// private!
@property (nonatomic,strong) NSMutableArray *recentLogs;

@end

@implementation LogTableViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.firebaseURL = @"https://rasp-pi-timestamps.firebaseio.com";
        self.firebaseRef = [[Firebase alloc] initWithUrl:self.firebaseURL];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // create recentLogs array
    self.recentLogs = [[NSMutableArray alloc] init];
    
    // load up the recent logs and put into the array
    [self loadInitialData];
}


- (void) getRecents
{
    Firebase *updatesRef = [[Firebase alloc] initWithUrl: [NSString stringWithFormat:@"%@/updates",self.firebaseURL]];
    FQuery* updatesQuery = [updatesRef queryLimitedToNumberOfChildren:10];
    [updatesQuery observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        NSString *status = snapshot.value;
        NSString *timestamp = snapshot.priority;
        NSLog(@"%@ at %@",status,timestamp);
        [self.recentLogs addObject:[NSString stringWithFormat:@"%@ at %@",status,timestamp]];
        [self.tableView reloadData];
    }];
    NSLog(@"im happening");
    
}

- (void)loadInitialData {
    // load up stuff and fill the array
    
    // ok this is the part where i have to pull it from some sort of back end. so. later.
    [self getRecents];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    NSLog(@"ppoop");
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSLog(@"%d",[self.recentLogs count]);
    return [self.recentLogs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"boop");
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListPrototypeCell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSUInteger row = [indexPath row];
    NSUInteger count = [self.recentLogs count]; // here listData is your data source
    cell.textLabel.text = [self.recentLogs objectAtIndex:(count-row-1)];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
