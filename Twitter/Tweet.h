#import <Mantle/Mantle.h>
#import "User.h"


extern NSString * const TweetDidUpdate;

@interface Tweet : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *tweetId;
@property (nonatomic, strong) NSString *text;
//@property (strong, nonatomic) NSURL *tweetURL;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, assign) NSInteger retweetCount;
@property (nonatomic, assign) NSInteger favoriteCount;
@property (nonatomic, assign) BOOL retweeted;
@property (nonatomic, assign) BOOL favorited;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) Tweet *originalTweet;

- (void)favorite:(BOOL)isFavorite completion:(void (^)(Tweet *tweet, NSError *error))completion;
- (void)reply;
- (void)retweet:(void (^)(Tweet *tweet, NSError *error))completion;

@end