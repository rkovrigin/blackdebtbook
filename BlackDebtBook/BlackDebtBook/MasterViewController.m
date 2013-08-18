//
//  MasterViewController.m
//  BlackDebtBook
//
//  Created by Roman Kovrigin on 14.02.13.
//  Copyright (c) 2013 rkovrigin co. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "AppDelegate.h"
#import "DBmanager.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation MasterViewController
@synthesize detailViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Master", @"Master");
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    //self.navigationItem.rightBarButtonItem = addButton;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    NSMutableArray * arr = [NSMutableArray arrayWithObjects:addButton, nil];
    self.navigationController.toolbar.tintColor = [UIColor blackColor];
    [[self navigationController] setToolbarHidden: NO animated:NO];
    [self setToolbarItems:arr animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    if(!self.editing){
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd-hh:mm"];
        DBmanager *db = [DBmanager getSharedInstance];
        [db saveData:[df stringFromDate:[NSDate date]]];

        [self.tableView reloadData];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    DBmanager *_db = [DBmanager getSharedInstance];
    NSMutableArray *_debtors = [_db loadDebtors];
    
    return [_debtors count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    NSMutableArray *_debtors;
    DBmanager *_db = [DBmanager getSharedInstance];
    _debtors = [_db loadDebtors];
    Debtor *debtor = [Debtor alloc];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if(indexPath.row < [_debtors count]){
        if (self.editing){
            NSLog(@"Editing");
        }else{
            NSLog(@"NOT Editing");
            cell.textLabel.textColor = [UIColor blackColor];
            cell.editingAccessoryType = UITableViewCellAccessoryNone;
            debtor = [_debtors objectAtIndex:indexPath.row];
            cell.textLabel.text = debtor.name;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
    }

//    NSDate *object = _objects[indexPath.row];
//    cell.textLabel.text = [object description];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    DBmanager *db = [DBmanager getSharedInstance];
    NSMutableArray *_debtors;
    Debtor *debtor = [Debtor alloc];
    _debtors = [db loadDebtors];

    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [_objects removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        debtor = [_debtors objectAtIndex:indexPath.row];
        [db Exec:[NSString stringWithFormat:@"delete from debtor where regno = %@", debtor.id]];
        [self.tableView reloadData];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationBottom];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.detailViewController) {
        self.detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    }
    DBmanager *db = [DBmanager getSharedInstance];
    NSMutableArray *_deblors = [db loadDebtors];
    AppDelegate *delegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    Debtor *_d = _deblors[indexPath.row];
    DetailViewController *detail = [[DetailViewController alloc] initWithID:_d.id];
    [delegate.navigationController pushViewController:detail animated:YES];
    
}

@end
