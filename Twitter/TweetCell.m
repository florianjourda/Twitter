//
//  TweetCell.m
//  Twitter
//
//  Created by Florian Jourda on 2/22/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "TweetCell.h"

@interface TweetCell()
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end


@implementation TweetCell

- (void)awakeFromNib {
    // Initialization code
    self.textLabel.preferredMaxLayoutWidth = self.textLabel.frame.size.width;
//    self.thumbImageView.layer.cornerRadius = 3;
//    self.thumbImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;
    //[self.thumbImageView setImageWithURL:[NSURL URLWithString:self.business.imageUrl]];
    self.textLabel.text = self.tweet.text;
//    [self.ratingImageView setImageWithURL:[NSURL URLWithString:self.business.ratingImageUrl]];
//    self.ratingsLabel.text = [NSString stringWithFormat:@"%ld Reviews", self.business.numReviews];
//    self.addressLabel.text = self.business.address;
//    self.distanceLabel.text = [NSString stringWithFormat:@"%.2f mi", self.business.distance];
//    self.categoryLabel.text = self.business.categories;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textLabel.preferredMaxLayoutWidth = self.textLabel.frame.size.width;
}

@end
