//
//  DebtDetail.h
//  BlackDebtBook
//
//  Created by Roman Kovrigin on 18.08.13.
//  Copyright (c) 2013 rkovrigin co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DebtDetail : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *DebtAmount;
@property (strong, nonatomic) IBOutlet UIDatePicker *DatePicker;
@property (weak, nonatomic) IBOutlet UITextField *StartDate;
- (IBAction)dateChanged:(id)sender;
- (IBAction)doneEditing:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *ReturnDate;
@end
