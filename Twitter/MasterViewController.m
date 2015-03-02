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
#import "ProfileViewController.h"

@interface MasterViewController ()
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIView *foregroundView;
@property (strong, nonatomic) UIViewController *backgroundViewController;
@property (strong, nonatomic) UIViewController *foregroundViewController;
@property (strong, nonatomic) UIViewController *profileViewController;
@property (strong, nonatomic) UIViewController *tweetsViewController;
@property (nonatomic, assign) CGPoint originalCenter;

@end

@implementation MasterViewController


- (id)initWithBackgroundViewController:(UIViewController *)backgroundViewController
          foregroundViewController:(UIViewController *)foregroundViewController {
    self = [super init];

    if (self) {
        self.backgroundViewController = backgroundViewController;
        //[self addPanGestureToViewController:timelineViewController];
        //self.slidableViewController = timelineViewController;
        //self.currentSlidableItem = Timeline;

        self.foregroundViewController = foregroundViewController;
        //[self addPanGestureToViewController:profileViewController];
        //self.profileViewController.view.hidden = YES;
    }

    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"View did load");
    // Do any additional setup after loading the view from its nib.

    //self.navigationController.navigationBar.hidden = YES;
    [self.backgroundView addSubview:self.backgroundViewController.view];
    [self addChildViewController:self.backgroundViewController];
    [self.backgroundViewController didMoveToParentViewController:self];
//    TweetsViewController *viewController = [[TweetsViewController alloc] init];
//    [self.view addSubview:viewController.view];
//
//    ProfileViewController *profileViewController = [[ProfileViewController alloc] initWithUser:[User currentUser]];
    [self.foregroundView addSubview:self.foregroundViewController.view];
    [self addChildViewController:self.foregroundViewController];
    [self.foregroundViewController didMoveToParentViewController:self];

//    [self.tweetView addSubview:self.tweetsViewController.view];
//    [self addChildViewController:self.tweetsViewController];
//    [self.tweetsViewController didMoveToParentViewController:self];

    UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
    [self.view addGestureRecognizer:gestureRecognizer];
}

- (void)onPan:(UIPanGestureRecognizer *)sender {
    CGPoint translation = [sender translationInView:self.view];
    CGPoint velocity = [sender velocityInView:self.view];

    if (sender.state == UIGestureRecognizerStateBegan) {
        self.originalCenter = self.foregroundView.center;
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        CGPoint center = CGPointMake(MIN(self.view.frame.size.width - 100, MAX(0, self.originalCenter.x + translation.x)), self.originalCenter.y);
        self.foregroundView.center = center;
    } else if (sender.state == UIGestureRecognizerStateEnded) {
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
    }
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
