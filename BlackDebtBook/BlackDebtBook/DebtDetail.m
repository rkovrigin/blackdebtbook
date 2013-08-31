//
//  DebtDetail.m
//  BlackDebtBook
//
//  Created by Roman Kovrigin on 18.08.13.
//  Copyright (c) 2013 rkovrigin co. All rights reserved.
//

#import "DebtDetail.h"

@interface DebtDetail ()

@end

@implementation DebtDetail
@synthesize DebtAmount;
@synthesize DatePicker;
@synthesize StartDate;
@synthesize ReturnDate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [DebtAmount becomeFirstResponder];
    DebtAmount.keyboardAppearance = UIKeyboardAppearanceAlert;
    DebtAmount.keyboardType = UIKeyboardTypeDecimalPad;
//    [DatePicker setBackgroundColor:[UIColor greenColor]];
    
//    StartDate.inputView = DatePicker;
//    ReturnDate.inputView = DatePicker;
    
    UIDatePicker *dp = [[UIDatePicker alloc] init];
//    UIView *overlayIndicator = [[UIView alloc] initWithFrame:CGRectMake(20, 86, 280, 44)];
//    overlayIndicator.backgroundColor = [UIColor darkTextColor];
//    overlayIndicator.alpha = 0.5f;
//    [dp addSubview:overlayIndicator];
    dp.datePickerMode = UIDatePickerModeDate;
//    dp.minimumDate = 0;
    
    NSCalendar * gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
    NSDate * currentDate = [NSDate date];
    NSDateComponents * comps = [[NSDateComponents alloc] init];
    [comps setYear: +100];
    NSDate * maxDate = [gregorian dateByAddingComponents: comps toDate: currentDate options: 0];
    [comps setYear: 0];
    NSDate * minDate = [gregorian dateByAddingComponents: comps toDate: currentDate options: 0];
    dp.minimumDate = minDate;
    dp.maximumDate = maxDate;
    dp.date = minDate;
    dp.backgroundColor = [UIColor blackColor];
    
    
    StartDate.inputView = dp;
    ReturnDate.inputView = dp;
    
    NSDate *date = dp.date;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/mm/yyyy"];
    NSString *prettyVersion = [dateFormat stringFromDate:date];
    StartDate.text = prettyVersion;
    
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(addDebt:)];
    // Do any additional setup after loading the view from its nib.
}

- (void)addDebt:(id)sender
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dateChanged:(id)sender {
//    UIDatePicker *picker = (UIDatePicker *)sender;
    
//    StartDate.text = [NSString stringWithFormat:@"%@", picker.date];
//    ReturnDate.text = [NSString stringWithFormat:@"%@", picker.date];
}

- (IBAction)doneEditing:(id)sender {
    [StartDate resignFirstResponder];
}

@end
