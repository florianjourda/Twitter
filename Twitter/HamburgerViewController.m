//
//  HamburgerViewController.m
//  Twitter
//
//  Created by Florian Jourda on 3/1/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "HamburgerViewController.h"
#import "User.h"
#import "ProfileViewController.h"

@interface HamburgerViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *menuItems;

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

- (id)initWithMenuItems:(NSArray *)menuItems {
    self = [super init];

    if (self) {
        self.menuItems = menuItems;
    }

    return self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"HamburgerCell"];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HamburgerCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.menuItems[indexPath.row][@"text"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    void (^action)() = self.menuItems[indexPath.row][@"action"];
    action();
}

@end
