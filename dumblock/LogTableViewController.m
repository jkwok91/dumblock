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
@property NSMutableArray *recentLogs;

@end

@implementation LogTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
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
    
    NSString *docsDir;
    NSArray *dirPaths;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    _databasePath = [[NSString alloc]
                     initWithString: [docsDir stringByAppendingPathComponent:
                                      @"logs.db"]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: _databasePath ] == NO)
    {
        const char *dbpath = [_databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &_logDB) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt =
            "CREATE TABLE IF NOT EXISTS LOGS (ID INTEGER PRIMARY KEY AUTOINCREMENT, LOCKEDSTATUS INTEGER, TIMESTAMP TEXT)";
            // stores each log as bool (locked(1)/unlocked(0)) and the timestamp as text
            
            if (sqlite3_exec(_logDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                _dbstatus.text = @"Failed to create table";
            }
            sqlite3_close(_logDB);
        } else {
            _dbstatus.text = @"Failed to open/create database";
        }
    }
    
    // create recentLogs array
    self.recentLogs = [[NSMutableArray alloc] init];
    
    // load up the recent logs and put into the array
    [self loadInitialData];
}

/* yo i dont know where the f this method should actually go but probably not in this controller cuz the controller will never call it because it will be called by the mechanism that actually detects wat is wat
 */
- (void) saveData:(StatusChange *)log
{
    sqlite3_stmt    *statement;
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_logDB) == SQLITE_OK)
    {
        // enter data correctly / format SQL
        NSString *insertSQL = [NSString stringWithFormat:
                               @"INSERT INTO LOGS (lockedstatus, timestamp) VALUES (%i, \"%@\")",
                               [log getStatus], [log getTimestamp]];
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(_logDB, insert_stmt,
                           -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            _dbstatus.text = @"Log added";
        } else {
            _dbstatus.text = @"Failed to add log";
        }
        sqlite3_finalize(statement);
        sqlite3_close(_logDB);
    }
}

- (void) getRecents
{
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &_logDB) == SQLITE_OK)
    {
        NSString *querySQL = @"SELECT lockedstatus, timestamp FROM logs ORDER BY id DESC";
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_logDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                // load dem resultttzzzzz in diz arrayyy bittttcchhhh
                int doorStatus = sqlite3_column_int(statement, 0);
                NSString *status = doorStatus ? @"LOCKED" : @"UNLOCKED";
                NSString *timestamp = [[NSString alloc]
                                        initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                [self.recentLogs addObject:[NSString stringWithFormat:@"%@ at %@",status,timestamp]];
                _dbstatus.text = @"dat ass";
            } /*
               else {
                _status.text = @"THERE IZ NONE";
            } */
            sqlite3_finalize(statement);
        }
        sqlite3_close(_logDB);
    }
}

- (void)loadInitialData {
    // load up stuff and fill the array
    
    // TEST DATA ***REPLACE ME ***
    // THIS PART IS NOTTTTTTT PART OF LOAD INITIAL DATA THIS IS TEST DATA IGNORE THIS
    StatusChange *change1 = [[StatusChange alloc] initWithState:YES];
    [self saveData:change1];
    StatusChange *change2 = [[StatusChange alloc] initWithState:NO];
    [self saveData:change2];
    StatusChange *change3 = [[StatusChange alloc] initWithState:YES];
    [self saveData:change3];
    
    NSLog(@"BOOP! added three hardcoded things");
    
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.recentLogs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListPrototypeCell" forIndexPath:indexPath];
    
    // Configure the cell...
    StatusChange *log = [self.recentLogs objectAtIndex:indexPath.row];
    cell.textLabel.text = log;
    
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
