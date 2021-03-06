//
//  User.m
//  Twitter
//
//  Created by Florian Jourda on 2/21/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "User.h"
#import "TwitterClient.h"
#import "ProfileViewController.h"
#import "AppDelegate.h"

NSString * const UserDidLoginNotification = @"UserDidLoginNotification";
NSString * const UserDidLogoutNotification = @"UserDidLogoutNotification";


@interface User()

@property (nonatomic, strong) NSDictionary *dictionary;

@end

@implementation User

#pragma mark - Properties

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
        @"screenName": @"screen_name",
        @"profileImageUrl": @"profile_image_url",
        @"profileImageFullSizeUrl": @"profile_image_url",
        @"tagLine": @"description",
        @"tweetCount": @"statuses_count",
        @"followerCount": @"followers_count",
        @"followingCount": @"friends_count",
    };
}

+ (NSValueTransformer *)profileImageFullSizeUrlJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^NSString *(NSString *profileImageUrl) {
        return [profileImageUrl stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
    }];
}

static User *_currentUser = nil;

NSString * const kCurrentUserKey = @"kCurrentUserKey";

+ (User *)currentUser {
    if (_currentUser == nil) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentUserKey];
        if (data != nil) {
            _currentUser = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            //NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            //_currentUser = [[User alloc] initWithDictionary:dictionary];
        }
    }
    return _currentUser;
}

+ (void)setCurrentUser:(User *)currentUser {
    _currentUser = currentUser;

    if (_currentUser != nil) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:currentUser];
//        [NSUserDefaults.standardUserDefaults setObject:data forKey:@"myModel"];
//        NSData *data = [NSJSONSerialization dataWithJSONObject:currentUser.dictionary options:0 error:NULL];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kCurrentUserKey];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kCurrentUserKey];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)logout {
    [User setCurrentUser:nil];
    [[TwitterClient sharedInstance].requestSerializer removeAccessToken];
    [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLogoutNotification object:nil];
}

- (void)showProfile {
    ProfileViewController *profileViewController = [[ProfileViewController alloc] initWithUser:self];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.navigationController pushViewController:profileViewController animated:YES];
}

@end
