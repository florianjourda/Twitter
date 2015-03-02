//
//  ProfileViewController.m
//  Twitter
//
//  Created by Florian Jourda on 3/1/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIImageView+AFNetworking.h"

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersCountLabel;

@property (nonatomic, strong) User *user;


@end

@implementation ProfileViewController

- (id)initWithUser:(User *)user {
    self = [super init];

    if (self) {
        self.user = user;
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"Profile";

    [self.profileImageView setImageWithURL:[NSURL URLWithString:self.user.profileImageFullSizeUrl]];
    self.nameLabel.text = self.user.name;
    NSLog(@"User: %@", self.user);
    self.tweetCountLabel.text = [NSString stringWithFormat:@"%ld", self.user.tweetCount];
    self.followersCountLabel.text = [NSString stringWithFormat:@"%ld", self.user.followerCount];
    self.followingCountLabel.text = [NSString stringWithFormat:@"%ld", self.user.followingCount];
}

@end
