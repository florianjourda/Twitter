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
@property (nonatomic, assign) CGPoint originalCenter;
@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *foregroundXContraint;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *foregroundTopConstraint;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *foregroundBottomConstraint;

@end

@implementation MasterViewController


- (id)initWithBackgroundViewController:(UIViewController *)backgroundViewController
          foregroundViewController:(UIViewController *)foregroundViewController {
    self = [super init];

    if (self) {
        self.backgroundViewController = backgroundViewController;
        self.foregroundViewController = foregroundViewController;
    }

    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //NSLog(@"View did load");

    [self.backgroundView addSubview:self.backgroundViewController.view];
    [self addChildViewController:self.backgroundViewController];
    [self.backgroundViewController didMoveToParentViewController:self];

    [self.foregroundView addSubview:self.foregroundViewController.view];
    [self addChildViewController:self.foregroundViewController];
    [self.foregroundViewController didMoveToParentViewController:self];

    UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
    [self.view addGestureRecognizer:gestureRecognizer];

    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
}

- (void)onPan:(UIPanGestureRecognizer *)sender {
    CGPoint translation = [sender translationInView:self.view];
    CGPoint velocity = [sender velocityInView:self.view];

    if (sender.state == UIGestureRecognizerStateBegan) {
        self.originalCenter = self.foregroundView.center;
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        self.foregroundXContraint.constant = MAX(0, MIN(self.view.frame.size.width - 40, self.originalCenter.x - self.foregroundView.frame.size.width / 2 + translation.x));
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        if (velocity.x > 0) {
            [self open];
        } else {
            [self close];
        }
    }
}

- (void)close {
    [UIView animateWithDuration:0.3
                          delay: 0.0
                        options: UIViewAnimationOptionTransitionNone
                     animations:^{
                         [self placeForegroundToTheLeft];
                         [self.view layoutIfNeeded];
                     }
                     completion:nil];
    [self.foregroundView removeGestureRecognizer:self.tapRecognizer];
}

- (void)open {
    [UIView animateWithDuration:0.3
                          delay: 0.0
                        options: UIViewAnimationOptionTransitionNone
                     animations:^{
                         [self placeForegroundToTheRight];
                         [self.view layoutIfNeeded];
                     }
                     completion:nil];
    [self.foregroundView addGestureRecognizer:self.tapRecognizer];
}

- (void)placeForegroundToTheLeft {
    self.foregroundXContraint.constant = 0;
//    self.foregroundTopConstraint.constant = 0;
//    self.foregroundBottomConstraint.constant = 0;
}

- (void)placeForegroundToTheRight {
    self.foregroundXContraint.constant = self.view.frame.size.width - 60;
//    self.foregroundTopConstraint.constant = 30;
//    self.foregroundBottomConstraint.constant = 30;
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
