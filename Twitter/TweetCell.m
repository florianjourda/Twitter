//
//  TweetCell.m
//  Twitter
//
//  Created by Florian Jourda on 2/22/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "TweetCell.h"
#import "ImageLoaderHelper.h"

@interface TweetCell()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *isRetweetImageView;

@property (weak, nonatomic) IBOutlet UILabel *retweeterImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScreenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;


@end


@implementation TweetCell

- (void)awakeFromNib {
    // Initialization code
   self.messageLabel.preferredMaxLayoutWidth = self.textLabel.frame.size.width;
   self.avatarImageView.layer.cornerRadius = 5;
   self.avatarImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;

    self.messageLabel.text = self.tweet.text;
    self.userNameLabel.text = self.tweet.user.name;
    self.userScreenNameLabel.text = [NSString stringWithFormat:@"@%@", self.tweet.user.screenName];
    [ImageLoaderHelper setImage:self.avatarImageView withUrlString:self.tweet.user.profileImageUrl];
    
//    [self.ratingImageView setImageWithURL:[NSURL URLWithString:self.business.ratingImageUrl]];
//    self.ratingsLabel.text = [NSString stringWithFormat:@"%ld Reviews", self.business.numReviews];
//    self.addressLabel.text = self.business.address;
//    self.distanceLabel.text = [NSString stringWithFormat:@"%.2f mi", self.business.distance];
//    self.categoryLabel.text = self.business.categories;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.messageLabel.preferredMaxLayoutWidth = self.textLabel.frame.size.width;
}

@end
