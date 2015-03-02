//
//  MasterViewController.h
//  Twitter
//
//  Created by Florian Jourda on 3/1/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterViewController : UIViewController

- (id)initWithBackgroundViewController:(UIViewController *)backgroundViewController
          foregroundViewController:(UIViewController *)foregroundViewController;
- (void)close;
@end
