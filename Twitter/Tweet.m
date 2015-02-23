//
//  Tweet.m
//  Twitter
//
//  Created by Florian Jourda on 2/21/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        //NSLog(@"tweet: %@", dictionary);
        self.tweetId = dictionary[@"id_str"];
        self.text = dictionary[@"text"];
        self.user = [[User alloc] initWithDictionary:dictionary[@"user"]];
        NSString *createAtString = dictionary[@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        self.createdAt = [formatter dateFromString:createAtString];
        self.retweetCount = [dictionary[@"retweet_count"] integerValue];
        self.retweeted = [dictionary[@"retweeted"] boolValue];
        self.favoriteCount = [dictionary[@"favorite_count"] integerValue];
        self.favorited = [dictionary[@"favorited"] boolValue];

        self.originalTweet = nil;
        NSDictionary *originalTweetDictionary = dictionary[@"retweeted_status"];
        if (originalTweetDictionary != nil) {
            self.originalTweet = [[Tweet alloc] initWithDictionary:originalTweetDictionary];
        }

//        self.tweetPhotoUrl = nil;
//        self.tweetPhotoUrls = [NSMutableArray array];
//        NSArray *mediaArray = [dictionary valueForKeyPath:@"extended_entities.media"];
//        if (mediaArray != nil && mediaArray.count > 0) {
//            NSDictionary *mediaData = mediaArray[0];
//            if ([mediaData[@"type"] isEqualToString:@"photo"]) {
//                self.tweetPhotoUrl = mediaData[@"media_url"];
//            }
//            for (NSDictionary *data in mediaArray) {
//                if ([data[@"type"] isEqualToString:@"photo"]) {
//                    [self.tweetPhotoUrls addObject:data[@"media_url"]];
//                }
//            }
//        }
    }

    return self;
}

+ (NSArray *)tweetWithArray:(NSArray *)array {
    NSMutableArray *tweets = [NSMutableArray array];
    for (NSDictionary *dictionary in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:dictionary]];
    }
    return tweets;
}

@end
