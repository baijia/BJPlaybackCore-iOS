//
//  BJChatViewController.m
//  BJPlaybackCore
//
//  Created by 辛亚鹏 on 2017/1/11.
//  Copyright © 2017年 辛亚鹏. All rights reserved.
//

#import "BJChatViewController.h"
#import "UIImageView+WebCache.h"

@interface BJChatViewController ()

@end

@implementation BJChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"chatCell"];
    self.tableView.separatorStyle = NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chatList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.chatList.count) {
        return nil;
    }
    BJPMessage  *message = self.chatList[indexPath.row];
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"chatCell"];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = message.userName;
    cell.detailTextLabel.text = message.content;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:message.userAvatar]];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30.f;
}
@end
