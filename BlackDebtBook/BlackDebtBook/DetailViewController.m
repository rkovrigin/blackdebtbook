//
//  DetailViewController.m
//  BlackDebtBook
//
//  Created by Roman Kovrigin on 14.02.13.
//  Copyright (c) 2013 rkovrigin co. All rights reserved.
//

#import "DetailViewController.h"
#import "DBmanager.h"

@interface DetailViewController ()
- (void)configureView;
@end

@implementation DetailViewController

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
    [self configureView];
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
