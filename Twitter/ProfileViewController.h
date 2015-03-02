//
//  ProfileViewController.h
//  Twitter
//
//  Created by Florian Jourda on 3/1/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface ProfileViewController : UIViewController

- (id)initWithUser:(User *)user;

@end