//
//  TweetsViewController.m
//  Twitter
//
//  Created by Florian Jourda on 2/21/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "TweetsViewController.h"
#import "ComposeViewController.h"
#import "User.h"
#import "TwitterClient.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "TweetDetailsController.h"

@interface TweetsViewController () <UITableViewDataSource, UITableViewDelegate, ComposeViewControllerDelegate, TweetDetailsControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tweets;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, assign) BOOL isForMentions;

@end

@implementation TweetsViewController 

- (id)initForMentions:(BOOL)isForMentions {
    self = [super init];
    if (self != nil) {
        self.isForMentions = isForMentions;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [TweetsViewController setupNavigationAppearance:self.navigationController];
    self.title = (self.isForMentions) ? @"Mentions" : @"Timeline";

//   UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(onLogout)];
//    self.navigationItem.leftBarButtonItem = leftButton;

    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(onNew)];
    self.navigationItem.rightBarButtonItem = rightButton;

    self.tweets = [NSMutableArray array];
    [self setupTableView];
    [self setupRefreshControl];

    [self loadTweets:true];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tweetDidUpdate:) name:TweetDidUpdate object:nil];
}

- (void)tweetDidUpdate:(NSNotification *)notification {
    NSLog(@"Refresh TweetsViewController");
    Tweet *updatedTweet = (Tweet *)notification.object;
    NSUInteger updatedTweetRow = [self.tweets indexOfObject:updatedTweet];
    NSIndexPath *updatedTweetIndexPath = [NSIndexPath indexPathForRow:updatedTweetRow inSection:0];
    NSLog(@"Found tweet at %lu", (unsigned long)updatedTweetRow);
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[updatedTweetIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onLogout {
    [User logout];
}

- (void)onNew {
    ComposeViewController *viewController = [[ComposeViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    viewController.delegate = self;
    [TweetsViewController setupNavigationAppearance:navigationController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)composeViewController:(ComposeViewController *)composeViewController didComposeTweet:(Tweet *)tweet {
    NSMutableArray *tweets = [[NSMutableArray alloc] init];
    [tweets addObject:tweet];
    [tweets addObjectsFromArray:self.tweets];
    self.tweets = tweets;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView endUpdates];
}


+ (void)setupNavigationAppearance:(UINavigationController *)navigationController {
    [navigationController.navigationBar setBarStyle:(UIBarStyle)UIStatusBarStyleLightContent];
    navigationController.navigationBar.tintColor = [UIColor whiteColor];
    UIColor *yelpColor = [UIColor colorWithRed:64.0f/255.0f
                                         green:153.0f/255.0f
                                          blue:255.0f/255.0f
                                         alpha:1.0f];
    navigationController.navigationBar.barTintColor = yelpColor;
    navigationController.navigationBar.translucent = NO;
}


#pragma mark - Data

- (void)loadTweets:(BOOL)atTheBeginning {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (atTheBeginning) {
        if (self.tweets.count > 0) {
            Tweet *mostRecentTweet = (Tweet*)self.tweets[0];
            params[@"since_id"] = mostRecentTweet.tweetId;
        }
    } else {
        if (self.tweets.count > 0) {
            Tweet *leastRecentTweet = (Tweet*)self.tweets[self.tweets.count - 1];
            params[@"max_id"] = leastRecentTweet.tweetId;
        }
    }

    void (^completion)(NSArray *, NSError *) = ^(NSArray *tweets, NSError *error) {
        NSLog(@"Got %lu tweets", (unsigned long)tweets.count);
        //        for (Tweet *tweet in tweets) {
        //            NSLog(@"text: %@", tweet.text);
        //        }
        if (tweets.count != 0) {
            NSMutableArray *allTweets = [NSMutableArray array];
            if (atTheBeginning) {
                [allTweets addObjectsFromArray:tweets];
                [allTweets addObjectsFromArray:self.tweets];
            } else {
                [allTweets addObjectsFromArray:self.tweets];
                NSArray *tweetsWithoutLeastRecentTweet = [tweets subarrayWithRange:NSMakeRange(1, tweets.count - 1)];
                [allTweets addObjectsFromArray:tweetsWithoutLeastRecentTweet];
            }
            if (allTweets.count > self.tweets.count) {
                self.tweets = allTweets;
                [self.tableView reloadData];
            }
        }
        [self.refreshControl endRefreshing];
    };

    if (self.isForMentions) {
        [[TwitterClient sharedInstance] mentionTimelineWithParams:params completion:completion];
    } else {
        [[TwitterClient sharedInstance] homeTimelineWithParams:params completion:completion];
    }
}

#pragma mark - Table view methods

- (void)setupTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 85;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    TweetDetailsController *viewController = [[TweetDetailsController alloc] init];
    viewController.tweet = self.tweets[indexPath.row];
    viewController.delegate = self;
    [self.navigationController pushViewController:viewController animated:true];
}

- (void)tweetDetailsController:(TweetDetailsController *)tweetDetailsController didUpdateTweet:(Tweet *)tweet {
    NSLog(@"Should update tweeet");
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    cell.tweet = self.tweets[indexPath.row];

    if (indexPath.row == self.tweets.count - 1) {
        [self loadTweets:NO];
    }

    return cell;
}


# pragma mark - Refresh Control

- (void)setupRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void)onRefresh {
    // Some loading
    [self loadTweets:true];
}


@end
