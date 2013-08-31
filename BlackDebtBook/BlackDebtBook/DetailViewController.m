//
//  DetailViewController.m
//  BlackDebtBook
//
//  Created by Roman Kovrigin on 14.02.13.
//  Copyright (c) 2013 rkovrigin co. All rights reserved.
//

#import "DetailViewController.h"
#import "DBmanager.h"
#import "AppDelegate.h"
#import "DebtDetail.h"


@interface DetailViewController ()
- (void)configureView;
@end

@implementation DetailViewController
@synthesize bottomToolbar;
#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
//    if (_detailItem != newDetailItem) {
//        _detailItem = newDetailItem;
    
        // Update the view.
        [self configureView];
//    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    DBmanager *db = [DBmanager getSharedInstance];
    NSString *query = [NSString stringWithFormat:@"select count(*) from debt where debtor = %@", self.debtorID];
    NSString *a = [db getStr:query];
    return [a intValue]+1;
}

- (void)configureView
{
    // Update the user interface for the detail item.
//
//    if (self.detailItem) {
//        self.detailDescriptionLabel.text = [self.detailItem description];
//    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
//    UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonItem:)];
//    self.navigationItem.rightBarButtonItem = edit;
    
    UIBarButtonItem *addBottomButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addDebt:)];
    UIBarButtonItem *minusBottomButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addDebt:)];
//    UIBarButtonItem *fixed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    [fixed setWidth:135.0f];
    
    self.navigationController.toolbar.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                   target:nil
                                   action:nil];
    NSArray *buttons = [NSArray arrayWithObjects: fixedSpace, addBottomButton, fixedSpace, nil];
    [bottomToolbar setItems: buttons];
    [self setToolbarItems:buttons];
    
    DBmanager *db = [DBmanager getSharedInstance];
    NSMutableArray *_debterCount = [db loadDebts:self.debtorID];
    
    NSIndexPath* ipath = [NSIndexPath indexPathForRow: [_debterCount count] inSection: 0];
    
    [self.debtsTable scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionBottom animated: YES];
    
    [self configureView];
}

- (void)addDebt:(id)sender
{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"title" message:@"message" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
//    alert.alertViewStyle = UIKeyboardAppearanceAlert;
    
//    [alert show];
    AppDelegate *delegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    DebtDetail *debtdetail = [[DebtDetail alloc] init];
    [delegate.navigationController pushViewController:debtdetail animated:YES];
}

- (void)editButtonItem:(id)sender
{
    NSLog(@"add");
}

- (void)insertNewObject:(id)sender
{
    if(!self.editing){
        DBmanager *db = [DBmanager getSharedInstance];
        [db Exec:[NSString stringWithFormat:@"insert into debt (amount, debtor) values(178, %@)", self.debtorID]];
        [self.debtsTable reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Debt", @"Debt");
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    DBmanager *db = [DBmanager getSharedInstance];
    NSMutableArray *_debts = [db loadDebts:self.debtorID];
    NSLog(@"debtorID %@", self.debtorID);
    
    if( nil == cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    if(indexPath.row < [_debts count]){
        cell.textLabel.textColor = [UIColor blackColor];
        cell.editingAccessoryType = UITableViewCellAccessoryNone;
        Debtor *debtor = [Debtor alloc];
        debtor = [_debts objectAtIndex:indexPath.row];
        cell.textLabel.text = debtor.name;
        
        int money = [debtor.name integerValue];
        NSLog(@"money %i", money);
        if (money < 0){
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
        }else{
            cell.textLabel.textAlignment = NSTextAlignmentRight;
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    if (indexPath.row == [_debts count]){
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor blackColor];
        cell.editingAccessoryType = UITableViewCellAccessoryNone;
        if(indexPath.row != 0){
        NSString *sum = [db getStr:[NSString stringWithFormat:@"select sum(amount) from debt where debtor = %@", self.debtorID]];
            cell.textLabel.text = [NSString stringWithFormat:@"Sum is %@", sum];
        }else{
            cell.textLabel.text = @"Empty";
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];            
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    cell.backgroundColor = [UIColor redColor];
}

- (id)initWithID:(NSString *)debtorid {
    if ( (self = [super init]) ) {
        self.debtorID = debtorid;
        NSLog(@"initWithID %@", self.debtorID);
    }
    DBmanager *db = [DBmanager getSharedInstance];
    NSLog(@"debtorID= %@", self.debtorID);
    NSString *debtorName = [db getStr: [NSString stringWithFormat:@"select name from debtor where regno = %@", self.debtorID]];
    self.title = debtorName;
 
    return self;
}

@end
