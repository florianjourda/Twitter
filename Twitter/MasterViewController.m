//
//  MasterViewController.m
//  Twitter
//
//  Created by Florian Jourda on 3/1/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "MasterViewController.h"
#import "TweetsViewController.h"
#import "HamburgerViewController.h"

@interface MasterViewController ()
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIView *thisView;
@property (weak, nonatomic) IBOutlet UIView *thatView;
@property (strong, nonatomic) UIViewController *hamburgerViewController;
@property (strong, nonatomic) UIViewController *timelineViewController;
@property (strong, nonatomic) UIViewController *profileViewController;
@property (strong, nonatomic) UIViewController *tweetsViewController;

@end

@implementation MasterViewController

- (id)initWithTimelineViewController:(UIViewController *)timelineViewController
               profileViewController:(UIViewController *)profileViewController
                tweetsViewController:(UIViewController *)tweetsViewController
             hamburgerViewController:(UIViewController *)hamburgerViewController {
    self = [super init];

    if (self) {
        self.timelineViewController = timelineViewController;
        //[self addPanGestureToViewController:timelineViewController];
        //self.slidableViewController = timelineViewController;
        //self.currentSlidableItem = Timeline;

        self.profileViewController = profileViewController;
        //[self addPanGestureToViewController:profileViewController];
        //self.profileViewController.view.hidden = YES;

        self.tweetsViewController = tweetsViewController;
        //[self addPanGestureToViewController:messagesViewController];
        //self.messagesViewController.view.hidden = YES;

        self.hamburgerViewController = hamburgerViewController;
    }

    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"View did load");
    // Do any additional setup after loading the view from its nib.

    self.navigationController.navigationBar.hidden = YES;
    [self.backgroundView addSubview:self.hamburgerViewController.view];
//    TweetsViewController *viewController = [[TweetsViewController alloc] init];
//    [self.view addSubview:viewController.view];

    [self.thisView addSubview:self.tweetsViewController.view];
    [self addChildViewController:self.tweetsViewController];
    [self.tweetsViewController didMoveToParentViewController:self];

//    [self.tweetView addSubview:self.tweetsViewController.view];
//    [self addChildViewController:self.tweetsViewController];
//    [self.tweetsViewController didMoveToParentViewController:self];

    UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
    [self.view addGestureRecognizer:gestureRecognizer];
}

- (void)onPan:(UIPanGestureRecognizer *)sender {
    CGPoint translation = [sender translationInView:self.view];
    CGPoint velocity = [sender velocityInView:self.view];
    if (velocity.x > 0) {
        self.thisView.hidden = YES;
        self.thatView.hidden = YES;
    } else {
        self.thisView.hidden = NO;
        self.thatView.hidden = NO;
    }
    // Table scroll takes precedence over panning.  Woot!
//    if (sender.state == UIGestureRecognizerStateBegan) {
//        self.originalCenter = sender.view.center;
//    } else if (sender.state == UIGestureRecognizerStateChanged) {
//        CGPoint translation = [sender translationInView:self.view];
//        CGPoint center = CGPointMake(self.originalCenter.x + translation.x, self.originalCenter.y + translation.y);
//        sender.view.center = center;
//    } else if (sender.state == UIGestureRecognizerStateEnded) {
//        CGPoint velocity = [sender velocityInView:self.view];
//        CGFloat width = self.view.frame.size.width;
//        CGFloat height = self.view.frame.size.height;
//        CGPoint center;
//        if (velocity.x > 0) {
//            center = CGPointMake(3 * width / 2 - 64, height / 2 + 32);
//        } else {
//            center = self.view.center;
//        }
//        [UIView animateWithDuration:0.2 animations:^{
//            sender.view.center = center;
//        }];
//    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
