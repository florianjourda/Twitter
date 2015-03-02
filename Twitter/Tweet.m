#import "Tweet.h"
#import "TwitterClient.h"

NSString * const TweetDidUpdate = @"TweetDidUpdate";

@implementation Tweet

#pragma mark - Properties

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"tweetId" : @"id",
             @"createdAt": @"created_at",
             @"retweetCount": @"retweet_count",
             @"favoriteCount": @"favorite_count",
             @"originalTweet": @"retweeted_status",
             //             @"tweetLinks":@"entities.urls",
             //             @"tweetImages":@"extended_entities.media",
             //             self.tweetPhotoUrl = nil;
             //             self.tweetPhotoUrls = [NSMutableArray array];
             //                     NSArray *mediaArray = [dictionary valueForKeyPath:@"extended_entities.media"];
             //                     if (mediaArray != nil && mediaArray.count > 0) {
             //                         NSDictionary *mediaData = mediaArray[0];
             //                         if ([mediaData[@"type"] isEqualToString:@"photo"]) {
             //                             self.tweetPhotoUrl = mediaData[@"media_url"];
             //                         }
             //                         for (NSDictionary *data in mediaArray) {
             //                             if ([data[@"type"] isEqualToString:@"photo"]) {
             //                                 [self.tweetPhotoUrls addObject:data[@"media_url"]];
             //                             }
             //                         }
             //                     }
    };
}


//- (NSURL *)tweetURL
//{
//    if (!_tweetURL) {
//        // TODO: Pull this URL String constant out
//        _tweetURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.twitter.com/%@/status/%@", self.username, self.identifier]];
//    }
//    return _tweetURL;
//}

+ (NSValueTransformer *)createdAtJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [self.dateFormatter dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

+ (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *_dateFormater = nil;
    if (!_dateFormater) {
        _dateFormater = [[NSDateFormatter alloc] init];
        _dateFormater.dateFormat = @"EEE MMM dd HH:mm:ss ZZZ yyyy";
    }
    return _dateFormater;
}

+ (NSValueTransformer *)originalTweetJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:Tweet.class];
}

+ (NSValueTransformer *)userJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:User.class];
}

//
//+ (NSValueTransformer *)tweetImagesJSONTransformer {
//    return [MTLValueTransformer transformerWithBlock:^id(NSDictionary *tweetImagesDict) {
//        NSMutableArray *arr = [NSMutableArray new];
//
//        for (NSDictionary *mediaDict in tweetImagesDict) {
//            [arr addObject:mediaDict[@"media_url_https"]];
//        }
//
//        return [NSArray arrayWithArray:arr];
//    }];
//}

//+ (NSValueTransformer *)tweetLinksJSONTransformer {
//    return [MTLValueTransformer transformerWithBlock:^id(NSDictionary *tweetImagesDict) {
//        NSMutableArray *arr = [NSMutableArray new];
//
//        for (NSDictionary *mediaDict in tweetImagesDict) {
//            [arr addObject:[self removeNewlineCharactersFromString:mediaDict[@"url"]]];
//        }
//
//        return [NSArray arrayWithArray:arr];
//    }];
//}
//+ (NSString *)removeNewlineCharactersFromString:(NSString *)string {
//    return [string stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
//}

# pragma mark - Actions

- (void)favorite:(BOOL)isFavorite completion:(void (^)(Tweet *tweet, NSError *error))completion {
    // Async server-side action
    [[TwitterClient sharedInstance] setTweet:self asFavorite:isFavorite completion:^(Tweet *tweet, NSError *error) {
        [self mergeValuesForKeysFromModel:tweet];
        NSLog(@"Call TweetDidUpdate with favorite: %d", self.favorited);
        [[NSNotificationCenter defaultCenter] postNotificationName:TweetDidUpdate object:self];
        if (completion != nil) {
            completion(tweet, nil);
        }
    }];
    // Sync client-side action to fake fast result
    self.favorited = isFavorite;
    NSLog(@"Set favorite: %d", self.favorited);
    NSLog(@"Call TweetDidUpdate with favorite: %d", self.favorited);
    [[NSNotificationCenter defaultCenter] postNotificationName:TweetDidUpdate object:self];
}

- (void)reply {
//    ComposeViewController *viewController = [[ComposeViewController alloc] init];
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
//    viewController.delegate = self;
//    viewController.originalTweet = self.tweet;
//    [TweetsViewController setupNavigationAppearance:navigationController];
//    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)retweet {

}


@end
