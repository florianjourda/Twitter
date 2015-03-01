#import "Tweet.h"

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
             //@"user": @"user",
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


//+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key
//{
//    if ([key isEqualToString:@"date"]) {
//        return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
//            return [[self dateFormatter] dateFromString:str];
//        } reverseBlock:^(NSDate *date) {
//            return [[self dateFormatter] stringFromDate:date];
//        }];
//    }
//
//    return nil;
//}

//+ (NSValueTransformer *)userProfilePictureJSONTransformer {
//    return [MTLValueTransformer reversibleTransformerWithBlock:^(NSString *str) {
//        str = [str stringByReplacingOccurrencesOfString:@"normal" withString:@"bigger"];
//        return [NSURL URLWithString:str];
//    }];
//}
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


@end
