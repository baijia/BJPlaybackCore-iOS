//
//  BJChatViewController.m
//  BJPlaybackCore
//
//  Created by 辛亚鹏 on 2017/1/11.
//  Copyright © 2017年 Baijia Cloud. All rights reserved.
//

#import "BJChatViewController.h"
#import "UIImageView+WebCache.h"


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
    cell.textLabel.text = message.fromUser.name;
    //    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:message.fromUser.avatar]];
    switch (message.type) {
        case BJLMessageType_text:
            cell.detailTextLabel.text = message.text;
            break;
            
        case BJLMessageType_emoticon:
            
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:message.emoticon.urlString]];
            break;
            
        case BJLMessageType_image:
            NSLog(@"imageH = %f, imageW = %f", message.imageHeight, message.imageWidth);
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:message.imageURLString]];
            break;
            
        default:
            break;
    }
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30.f;
}

#pragma mark -
- (NSMutableArray<BJPMessage *> *)chatList {
    if (!_chatList) {
        _chatList = [NSMutableArray array];
    }
    return _chatList;
}

@end
