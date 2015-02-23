//
//  ComposeViewController.m
//  Twitter
//
//  Created by Florian Jourda on 2/22/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "ComposeViewController.h"
#import "User.h"
#import "TwitterClient.h"
#import "ImageLoaderHelper.h"

@interface ComposeViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *userScreenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;


@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"";

    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancel)];
    self.navigationItem.leftBarButtonItem = leftButton;

    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(onTweet)];
    self.navigationItem.rightBarButtonItem = rightButton;

    User *user = [User currentUser];
    [ImageLoaderHelper setImage:self.avatarImageView withUrlString:user.profileImageUrl];
    self.userNameLabel.text = user.name;
    self.userScreenNameLabel.text = user.screenName;
    [self.messageTextView becomeFirstResponder];

    if (self.originalTweet != nil) {
        self.messageTextView.text = [NSString stringWithFormat:@"@%@ ", self.originalTweet.user.screenName];
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    //self.navigationItem.titleView = self.countLabel;
//    [[[UIApplication sharedApplication] keyWindow] addSubview:self.countLabel];
}

-(void)viewWillDisappear:(BOOL)animated
{
//    [self.countLabel removeFromSuperview];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onCancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onTweet {
    [[TwitterClient sharedInstance] newTweetWithStatus:self.messageTextView.text inReplyToTweet:self.originalTweet completion:^(Tweet *tweet, NSError *error) {
        if (tweet) {
            [self.delegate composeViewController:self didComposeTweet:tweet];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

#pragma mark - UITextView

- (void)textViewDidChange:(UITextView *)textView {
    self.countLabel.text = [NSString stringWithFormat:@"%lu", 140 - textView.text.length];
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
