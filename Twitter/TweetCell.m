//
//  TweetCell.m
//  Twitter
//
//  Created by Florian Jourda on 2/22/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "TweetCell.h"
#import "ImageLoaderHelper.h"
#import "TwitterClient.h"
#import "DateHelper.h"
#import "ComposeViewController.h"

@interface TweetCell()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *isRetweetImageView;

@property (weak, nonatomic) IBOutlet UILabel *retweeterLabel;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScreenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *retweetedHeightConstraint;
@property (nonatomic, strong) Tweet *tweetToDisplay;

@end


@implementation TweetCell

- (void)awakeFromNib {
    // Initialization code
   //self.messageLabel.preferredMaxLayoutWidth = self.messageLabel.frame.size.width;
   self.avatarImageView.layer.cornerRadius = 5;
   self.avatarImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;

    if (self.tweet.originalTweet) {
        self.tweetToDisplay = self.tweet.originalTweet;
        self.retweeterLabel.text = [NSString stringWithFormat:@"%@ retweeted", self.tweet.user.name];
        self.retweeterLabel.hidden = NO;
        self.retweetedHeightConstraint.constant = 16;
        self.isRetweetImageView.hidden = NO;
    } else {
        self.tweetToDisplay = self.tweet;
        self.retweeterLabel.hidden = YES;
        self.retweetedHeightConstraint.constant = 0;
        self.isRetweetImageView.hidden = YES;
    }

    [ImageLoaderHelper setImage:self.avatarImageView withUrlString:self.tweetToDisplay.user.profileImageUrl];
    //NSLog(@"%@", tweetToDisplay);
    self.messageLabel.text = self.tweetToDisplay.text;
    self.userNameLabel.text = self.tweetToDisplay.user.name;
    self.timeLabel.text = [DateHelper dateDiff:self.tweetToDisplay.createdAt];
    self.userScreenNameLabel.text = [NSString stringWithFormat:@"@%@", self.tweetToDisplay.user.screenName];
    self.retweetButton.selected = self.tweetToDisplay.retweeted;
    self.favoriteButton.selected = self.tweetToDisplay.favorited;

}


- (IBAction)onToggleFavorite:(id)sender {
    [self.tweet favorite:!self.tweet.favorited completion:nil];}

- (IBAction)onRetweet:(id)sender {
    [self.tweet retweet:nil];
}

- (IBAction)onReply:(id)sender {
    // @TODO(florian): Implement reply
//    ComposeViewController *viewController = [[ComposeViewController alloc] init];
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
//    viewController.delegate = self;
//    viewController.originalTweet = self.tweet;
//    [TweetsViewController setupNavigationAppearance:navigationController];
//    [self presentViewController:navigationController animated:YES completion:nil];
}



//- (void)layoutSubviews {
//    [super layoutSubviews];
//    self.messageLabel.preferredMaxLayoutWidth = self.messageLabel.frame.size.width;
//}

@end
