//
//  HelloWorldDetailViewController.h
//  blackdebtbook
//
//  Created by Roman Kovrigin on 11.02.13.
//  Copyright (c) 2013 rkovrigin co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelloWorldDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
