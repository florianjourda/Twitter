//
//  TwitterClient.m
//  Twitter
//
//  Created by Florian Jourda on 2/21/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "TwitterClient.h"


NSString * const kTwitterConsumerKey = @"DbW33mcP12iUeXnJZPQ3EyqT0";
NSString * const kTwitterConsumerSecret = @"zuYXrosT6xB7nFuOR9rBGy4CsIebpERZtMHICF1akCLBRMc4M5";
NSString * const kTwitterBaseUrl = @"https://api.twitter.com";

@interface TwitterClient()

@property (nonatomic, strong) void (^loginCompletion)(User *user, NSError *error);

@end

@implementation TwitterClient

+ (TwitterClient *)sharedInstance {
    static TwitterClient *instance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:kTwitterBaseUrl] consumerKey:kTwitterConsumerKey consumerSecret:kTwitterConsumerSecret];
        }
    });

    return instance;
}

- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion {
    self.loginCompletion = completion;
    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"cptwitterdemo://oauth"] scope:nil success:^(BDBOAuth1Credential *requestToken) {
        NSLog(@"Got request token");
        NSURL *authURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token]];
        [[UIApplication sharedApplication] openURL:authURL];
    } failure:^(NSError *error) {
        NSLog(@"Did not get request token: %@", error);
        self.loginCompletion(nil, error);
    }];
}

- (void)openURL:(NSURL *)url {
    [self fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuth1Credential credentialWithQueryString:url.query]  success:^(BDBOAuth1Credential *accessToken) {
        NSLog(@"Got access token %@", accessToken);
        [[TwitterClient sharedInstance].requestSerializer saveAccessToken:accessToken];

        [[TwitterClient sharedInstance] GET:@"1.1/account/verify_credentials.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //NSLog(@"Current user %@", responseObject);
            User *user = [[User alloc] initWithDictionary:responseObject];
            [User setCurrentUser:user];
            NSLog(@"Current user %@", user.name);
            self.loginCompletion(user,  nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Failed to get current user");
            self.loginCompletion(nil, error);
        }];
    } failure:^(NSError *error) {
        NSLog(@"Did not get access token %@", error);
    }];
}

- (void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *, NSError *))completion {
    [self GET:@"1.1/statuses/home_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Got tweets: %@", responseObject);
        NSArray *tweets = [Tweet tweetWithArray:responseObject];
        completion(tweets, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Did not get tweets: %@", error);
        completion(nil, error);
    }];
}

- (void)setTweet:(Tweet *)tweet asFavorite:(BOOL)isFavorite completion:(void (^)(Tweet *tweet, NSError *error))completion {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = tweet.tweetId;
    NSString *favoriteEndpoint = (isFavorite) ? @"1.1/favorites/create.json" : @"1.1/favorites/destroy.json";
    [self POST:favoriteEndpoint parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:responseObject];
        completion(tweet, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

- (void)newTweetWithStatus:(NSString *)status inReplyToTweet:(Tweet *)tweetToReplyTo completion:(void (^)(Tweet *tweet, NSError *error))completion {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"status"] = status;
    params[@"in_reply_to_status_id"] = (tweetToReplyTo) ? tweetToReplyTo.tweetId : @"";
    [self POST:@"1.1/statuses/update.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Posted tweet: %@", responseObject);
        Tweet *tweet = [[Tweet alloc] initWithDictionary:responseObject];
        completion(tweet, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error with posting tweet: %@", error);
        completion(nil, error);
    }];
}

- (void)retweet:(Tweet *)tweet completion:(void (^)(Tweet *tweet, NSError *error))completion {
    [self POST:[NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", tweet.tweetId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Retweeted tweet: %@", responseObject);
        Tweet *tweet = [[Tweet alloc] initWithDictionary:responseObject];
        completion(tweet, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error with retweeting: %@", error);
        completion(nil, error);
    }];
}

@end
