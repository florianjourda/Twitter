//
//  TweetDetailsController.m
//  Twitter
//
//  Created by Florian Jourda on 2/22/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "TweetDetailsController.h"
#import "ImageLoaderHelper.h"
#import "DateHelper.h"
#import "TwitterClient.h"
#import "ComposeViewController.h"
#import "TweetsViewController.h"

@interface TweetDetailsController () <ComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *retweeterLabel;
@property (weak, nonatomic) IBOutlet UIImageView *isRetweetImageView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScreenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;
@property (nonatomic, strong) Tweet *tweetToDisplay;
@property (weak, nonatomic) IBOutlet UIView *tapView;

@end

@implementation TweetDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tweet = self.tweet;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tweetDidUpdate) name:TweetDidUpdate object:self.tweet];

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onUserTap)];
    [self.tapView addGestureRecognizer:tapGestureRecognizer];
}

- (void)onUserTap {
    NSLog(@"TAP");
    [self.tweetToDisplay.user showProfile];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tweetDidUpdate {
    NSLog(@"Updated tweet!");
    // Refresh UI;
    self.tweet = self.tweet;
}

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;

    if (self.tweet.originalTweet) {
        self.tweetToDisplay = self.tweet.originalTweet;
        self.retweeterLabel.text = self.tweet.user.name;
        self.retweeterLabel.hidden = NO;
        self.isRetweetImageView.hidden = NO;
        //self.isRetweetImageView.frame = self.isRetweetImageViewFrameShowed;
    } else {
        self.tweetToDisplay = self.tweet;
        self.retweeterLabel.hidden = YES;
        self.isRetweetImageView.hidden = YES;
        //self.isRetweetImageView.frame = self.isRetweetImageViewFrameHidden;
    }

    //NSLog(@"setTweet %d %d", tweetToDisplay.retweeted, tweetToDisplay.favorited);

    [ImageLoaderHelper setImage:self.avatarImageView withUrlString:self.tweetToDisplay.user.profileImageUrl];
    self.messageLabel.text = self.tweetToDisplay.text;
    self.userNameLabel.text = self.tweetToDisplay.user.name;
    self.timeLabel.text = [DateHelper dateDiff:self.tweetToDisplay.createdAt];
    self.userScreenNameLabel.text = [NSString stringWithFormat:@"@%@", self.tweetToDisplay.user.screenName];
    self.retweetButton.selected = self.tweetToDisplay.retweeted;
    self.favoriteButton.selected = self.tweetToDisplay.favorited;
    self.retweetCountLabel.text = [NSString stringWithFormat:@"%li", (long)self.tweetToDisplay.retweetCount];
    self.favoriteCountLabel.text = [NSString stringWithFormat:@"%li", (long)self.tweetToDisplay.favoriteCount];
}


- (IBAction)onToggleFavorite:(id)sender {
    [self.tweet favorite:!self.tweet.favorited completion:nil];
}

- (IBAction)onRetweet:(id)sender {
    [self.tweet retweet:nil];
}

- (IBAction)onReply:(id)sender {
    ComposeViewController *viewController = [[ComposeViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    viewController.delegate = self;
    viewController.originalTweet = self.tweet;
    [TweetsViewController setupNavigationAppearance:navigationController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)composeViewController:(ComposeViewController *)composeViewController didComposeTweet:(Tweet *)tweet {
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
