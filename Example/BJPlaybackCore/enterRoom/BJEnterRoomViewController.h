//
//  BJViewController.h
//  BJPlaybackCore
//
//  Created by 辛亚鹏 on 01/04/2017.
//  Copyright (c) 2017 Baijia Cloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BJPlaybackCore/BJPlaybackCore.h>

#import "BJUserViewController.h"
#import "BJChatViewController.h"

@interface BJEnterRoomViewController : UIViewController

@property (nonatomic) NSString *classId, *token, *userInfo;
@property (nonatomic) NSString *videoPath, *signalPath;

@property (nonatomic) UIView *playerView, *bottomContentView;
@property (nonatomic) UISlider *progressSlider;
@property (nonatomic) UIButton *playButton;
@property (nonatomic) UILabel *userTotalCountLabel;
@property (nonatomic) UILabel *currentTimeLabel, *durationLabel; //当前的播放时间 和 总的时长
@property (nonatomic) UIButton *lowButton, *highButton, *superHDButton;  //流畅 标清 高清
@property (nonatomic) UISegmentedControl *segmentCtrl, *rateSegmentCtrl;
@property (nonatomic) BJUserViewController *userCtrl;
@property (nonatomic) BJChatViewController *chatCtrl;
@property (nonatomic) BOOL isLoacal;
@property (nonatomic) NSArray *rateArray;

@property (nonatomic) BJPRoom *room;

//在线
+ (instancetype)enterRoomWithClassId:(NSString *)classId
                           token:(NSString *)token
                            userInfo:(NSString *)userInfo;

//播放本地视频
+ (instancetype)localEnterRoomWithVideoPath:(NSString *)videopPath
                                 signalPath:(NSString *)signalPath
                                   userInfo:(NSString *)userInfo;

@end
