//
//  TwitterClient.h
//  Twitter
//
//  Created by Florian Jourda on 2/21/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "User.h"
#import "Tweet.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *)sharedInstance;

- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion;
- (void)openURL:(NSURL *)url;
- (void)homeTimelineWithParams:(NSDictionary *)params completion:(void(^)(NSArray *tweets, NSError *error))completion;
- (void)setTweet:(Tweet *)tweet asFavorite:(BOOL)isFavorite completion:(void (^)(Tweet *tweet, NSError *error))completion;
- (void)newTweetWithStatus:(NSString *)status inReplyToTweet:(Tweet *)tweetToReplyTo completion:(void (^)(Tweet *tweet, NSError *error))completion;
- (void)retweet:(Tweet *)tweet completion:(void (^)(Tweet *tweet, NSError *error))completion;

@end
