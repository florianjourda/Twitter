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

@end


@implementation TweetCell

- (void)awakeFromNib {
    // Initialization code
   //self.messageLabel.preferredMaxLayoutWidth = self.textLabel.frame.size.width;
   self.avatarImageView.layer.cornerRadius = 5;
   self.avatarImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;

    Tweet *tweetToDisplay;
    if (self.tweet.originalTweet) {
        tweetToDisplay = self.tweet.originalTweet;
        self.retweeterLabel.text = self.tweet.user.name;
        self.retweeterLabel.hidden = NO;
        self.retweetedHeightConstraint.constant = 16;
        self.isRetweetImageView.hidden = NO;
    } else {
        tweetToDisplay = self.tweet;
        self.retweeterLabel.hidden = YES;
        self.retweetedHeightConstraint.constant = 0;
        self.isRetweetImageView.hidden = YES;
    }

    [ImageLoaderHelper setImage:self.avatarImageView withUrlString:tweetToDisplay.user.profileImageUrl];
    self.messageLabel.text = tweetToDisplay.text;
    self.userNameLabel.text = tweetToDisplay.user.name;
    self.timeLabel.text = [DateHelper dateDiff:tweetToDisplay.createdAt];
    self.userScreenNameLabel.text = [NSString stringWithFormat:@"@%@", tweetToDisplay.user.screenName];
    NSLog(@"tweet %d %d", self.tweet.retweeted, tweetToDisplay.favorited);
    self.retweetButton.selected = tweetToDisplay.retweeted;
    self.favoriteButton.selected = tweetToDisplay.favorited;

}



- (IBAction)onToggleFavorite:(id)sender {
    self.tweet.favorited = !self.tweet.favorited;
    [[TwitterClient sharedInstance] setTweet:self.tweet asFavorite:self.tweet.favorited completion:^(Tweet *tweet, NSError *error) {
          self.tweet = tweet;
    }];
    self.tweet = self.tweet;
}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    self.messageLabel.preferredMaxLayoutWidth = self.textLabel.frame.size.width;
//}

@end
