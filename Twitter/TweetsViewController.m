//
//  TweetsViewController.m
//  Twitter
//
//  Created by Florian Jourda on 2/21/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "TweetsViewController.h"
#import "User.h"
#import "TwitterClient.h"
#import "Tweet.h"
#import "TweetCell.h"

@interface TweetsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *tweets;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation TweetsViewController 

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupNavigationAppearance:self.navigationController];
    self.title = @"Home";

   UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(onLogout)];
    self.navigationItem.leftBarButtonItem = leftButton;

    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(onNew)];
    self.navigationItem.rightBarButtonItem = rightButton;

    self.tweets = [NSArray array];
    [self setupTableView];
    [self setupRefreshControl];

    [self loadTweets];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onLogout {
    [User logout];
}

- (void)onNew {
    NSLog(@"New");
}


- (void)setupNavigationAppearance:(UINavigationController *)navigationController {
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

- (void)loadTweets {
    [[TwitterClient sharedInstance] homeTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
        //        for (Tweet *tweet in tweets) {
        //            NSLog(@"text: %@", tweet.text);
        //        }
        self.tweets = tweets;
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    }];
}

#pragma mark - Table view methods

- (void)setupTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
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
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    cell.tweet = self.tweets[indexPath.row];
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
    [self loadTweets];
}


@end
