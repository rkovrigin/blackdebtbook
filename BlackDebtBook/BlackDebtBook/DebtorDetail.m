//
//  DebtorDetail.m
//  BlackDebtBook
//
//  Created by Roman Kovrigin on 21.08.13.
//  Copyright (c) 2013 rkovrigin co. All rights reserved.
//

#import "DebtorDetail.h"

@interface DebtorDetail ()

@end
@implementation DebtorDetail
@synthesize DebtoName;

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
    [DebtoName becomeFirstResponder];
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(addDebtor:)];
    // Do any additional setup after loading the view from its nib.
}

- (void)addDebtor:(id)sender
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
