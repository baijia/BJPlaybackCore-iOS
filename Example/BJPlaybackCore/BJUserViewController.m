//
//  BJUserViewController.m
//  BJPlaybackCore
//
//  Created by 辛亚鹏 on 2017/1/11.
//  Copyright © 2017年 辛亚鹏. All rights reserved.
//

#import "BJUserViewController.h"
#import "UIImageView+WebCache.h"

@interface BJUserViewController ()

@end

@implementation BJUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"userCell"];
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userCell" forIndexPath:indexPath];
    NSObject<BJLOnlineUser> *user = self.userList[indexPath.row];
    cell.textLabel.text = user.name;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:user.avatar]];
    
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30.f;
}

@end
