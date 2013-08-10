//
//  DetailViewController.h
//  BlackDebtBook
//
//  Created by Roman Kovrigin on 14.02.13.
//  Copyright (c) 2013 rkovrigin co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property NSString *debtorID;
//@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UITableView *debtsTable;

//@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
- (id)initWithID:(NSString *)debtorID;

@end
