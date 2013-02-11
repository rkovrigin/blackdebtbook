//
//  HelloWorldMasterViewController.h
//  blackdebtbook
//
//  Created by Roman Kovrigin on 11.02.13.
//  Copyright (c) 2013 rkovrigin co. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HelloWorldDetailViewController;

@interface HelloWorldMasterViewController : UITableViewController

@property (strong, nonatomic) HelloWorldDetailViewController *detailViewController;

@end
