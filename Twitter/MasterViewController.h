//
//  MasterViewController.h
//  Twitter
//
//  Created by Florian Jourda on 3/1/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterViewController : UIViewController

- (id)initWithTimelineViewController:(UIViewController *)timelineViewController
               profileViewController:(UIViewController *)profileViewController
                tweetsViewController:(UIViewController *)tweetsViewController
             hamburgerViewController:(UIViewController *)hamburgerViewController;
@end
