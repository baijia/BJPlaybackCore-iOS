//
//  BJChatViewController.h
//  BJPlaybackCore
//
//  Created by 辛亚鹏 on 2017/1/11.
//  Copyright © 2017年 Baijia Cloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BJPlaybackCore/BJPlaybackCore.h>

@interface BJChatViewController : UITableViewController

@property (nonatomic) NSMutableArray<BJPMessage*> *chatList;

@end
