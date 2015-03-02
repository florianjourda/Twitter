//
//  TweetDetailsController.h
//  Twitter
//
//  Created by Florian Jourda on 2/22/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@class TweetDetailsController;

@protocol TweetDetailsControllerDelegate <NSObject>

- (void)tweetDetailsController:(TweetDetailsController *)tweetDetailsController didUpdateTweet:(Tweet *)tweet;

@end

@interface TweetDetailsController : UIViewController

@property (nonatomic, weak) id<TweetDetailsControllerDelegate> delegate;
@property (nonatomic, strong) Tweet* tweet;

@end
