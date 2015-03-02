//
//  HamburgerViewController.m
//  Twitter
//
//  Created by Florian Jourda on 3/1/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "HamburgerViewController.h"
#import "User.h"

@interface HamburgerViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HamburgerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 40;
    //[self.tableView registerNib:[UINib nibWithNibName:@"UITableViewCell" bundle:nil] forCellReuseIdentifier:@"HamburgerCell"];
    self.title = @"Menu";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"HamburgerCell"];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HamburgerCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Home";
            break;
        case 1:
            cell.textLabel.text = @"Profile";
            break;
        case 2:
            cell.textLabel.text = @"Mentions";
            break;
        case 3:
            cell.textLabel.text = @"Log Out";
            break;
        default:
            cell.textLabel.text = @"";
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    switch (indexPath.row) {
//        case 0:
//            //Home timeline
//            [self.delegate closeMenu:@"home" withUser:nil];
//            break;
//        case 1:
//            //ProfileView
//            [self.delegate closeMenu:@"profile" withUser:[User currentuser]];
//            break;
//        case 2:
//            //Mentions
//            [self.delegate closeMenu:@"mentions" withUser:nil];
//            break;
//        default:
//            [User logOut];
//            break;
//    }
//}

@end
