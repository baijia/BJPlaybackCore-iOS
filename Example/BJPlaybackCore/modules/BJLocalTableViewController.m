//
//  BJLocalTableViewController.m
//  BJPlaybackCore
//
//  Created by 辛亚鹏 on 2017/3/17.
//  Copyright © 2017年 Baijia Cloud. All rights reserved.
//

#import "BJLocalTableViewController.h"
#import "BJEnterRoomViewController.h"

@interface BJLocalTableViewController ()

@end

@implementation BJLocalTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.text = @"请将localVideo的文件夹放到真机沙盒的Caches目录下面";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // !!!: 将localVideo的文件夹放到沙盒的 Library -> Caches 目录下面
    // www.baijiacloud.com
    NSString *cachesDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *signalPath = [cachesDir stringByAppendingPathComponent:@"localVideo/9986918de9cb2b50d0e96e258ab5700c.tar.gz"];
    NSString *videoPath = [cachesDir stringByAppendingPathComponent:@"localVideo/5957663_8519c6f241182d8b6489d74343865ccf_6V2gQvGm.mp4"];
    
    BJEnterRoomViewController *enterRoom = [BJEnterRoomViewController
                                            localEnterRoomWithVideoPath:videoPath
                                            signalPath:signalPath
                                            userInfo:nil];
    [self.navigationController pushViewController:enterRoom animated:YES];
    
}

@end
