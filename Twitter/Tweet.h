//
//  Tweet.h
//  Twitter
//
//  Created by Florian Jourda on 2/21/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, assign) NSInteger retweetCount;
@property (nonatomic, assign) NSInteger favoriteCount;
@property (nonatomic, assign) BOOL retweeted;
@property (nonatomic, assign) BOOL favorited;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSString *tweetId;
@property (nonatomic, strong) Tweet *originalTweet;

- (id)initWithDictionary:(NSDictionary *)dictionary;

+ (NSArray *)tweetWithArray:(NSArray *)array;
@end
