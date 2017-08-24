//
//  BJEnterRoomViewController+signal.h
//  BJPlaybackCore
//
//  Created by 辛亚鹏 on 2017/3/15.
//  Copyright © 2017 Baijia Cloud. All rights reserved.
//

#import "BJEnterRoomViewController.h"

@interface BJEnterRoomViewController (signal)

//监听进入房间的时候是否成功
- (void)roomEnterSignal;

//成功进入房间后 ui的signal
- (void)uiChangeSignal;

//将秒数转化为 12:45:18 格式
- (NSString *)timeWithSecond:(CGFloat)second;

- (NSString *)timeWithTime:(CGFloat)time;

@end
