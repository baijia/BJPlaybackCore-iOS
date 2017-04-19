//
//  BJViewController.m
//  BJPlaybackCore
//
//  Created by 辛亚鹏 on 01/04/2017.
//  Copyright (c) 2017 Baijia Cloud. All rights reserved.
//

#import "BJEnterRoomViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <BJLiveCore/BJLiveCore.h>
#import <BJLiveCore/NSObject+BJLObserving.h>
#import <Masonry/Masonry.h>
#import <BJHL-VideoPlayer-Manager/PMNotification.h>

#import "BJEnterRoomViewController+UI.h"
#import "BJEnterRoomViewController+signal.h"
#import "MBProgressHUD+bjp.h"

@interface BJEnterRoomViewController ()<BJPMProtocol>

@property (nonatomic) MBProgressHUD *hud;

@end

@implementation BJEnterRoomViewController

- (void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [self bjl_stopAllKeyValueObserving];
//    [self bjl_stopAllMethodArgumentsObserving];
}

+ (instancetype)enterRoomWithClassId:(NSString *)classId
                           token:(NSString *)token
                            userInfo:(NSString *)userInfo

{
    BJEnterRoomViewController *enterRoomCtrl = [BJEnterRoomViewController new];
    enterRoomCtrl.classId = classId;
    enterRoomCtrl.token = token;
    enterRoomCtrl.userInfo = userInfo;
    enterRoomCtrl.isLoacal = false;
    return enterRoomCtrl;
}

+ (instancetype)localEnterRoomWithVideoPath:(NSString *)videopPath
                                 signalPath:(NSString *)signalPath
                                   userInfo:(NSString *)userInfo {
    BJEnterRoomViewController *enterRoomCtrl = [BJEnterRoomViewController new];
    enterRoomCtrl.videoPath = videopPath;
    enterRoomCtrl.signalPath = signalPath;
    enterRoomCtrl.userInfo = userInfo;
    enterRoomCtrl.isLoacal = true;
    
    return enterRoomCtrl;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (self.isLoacal) {
        [self localEnterRoom];
    }
    else {
        [self enterRoom];
    }
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"退出房间" style:UIBarButtonItemStylePlain target:self action:@selector(exitRoom)];
    
    [self addNotification];

}

- (void)enterRoom {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStatusChange:)
                                                 name:PKMoviePlayerLoadStateDidChangeNotification
                                               object:nil];
    
    //如果是播放本地视频  创建房间2个参数可以传nil
    self.room = [BJPRoom createRoomWithClassId:_classId token:_token];
    
    // 设置需要上报的userInfo
    [self.room.playbackVM setUserInfo:_userInfo];

    self.room.playbackVM.playerControl.delegate = self;
    
    //!!!: 记忆播放:需要在进入房间之前, 将上次播放的时间赋值给initialPlaybackTime
//    self.room.playbackVM.initialPlaybackTime = 200;
    
    
    //在线视频进入房间
    [self.room enter];
    [self roomEnterSignal];

}

- (void)localEnterRoom {
    self.room = [BJPRoom createRoomWithClassId:nil token:nil];
    self.room.playbackVM.playerControl.delegate = self;
    
    //!!!: 记忆播放:需要在进入房间之前, 将上次播放的时间赋值给initialPlaybackTime
//    self.room.playbackVM.initialPlaybackTime = 200;
    
    [self.room enterRoomWithVideoPath:self.videoPath startVideo:nil endVideo:nil signalPath:self.signalPath definition:DT_LOW status:^(BJPMediaLibraryAuthorizationStatus status) {
        if (status != BJPMediaLibraryAuthorizationStatusAuthorized) {
            NSString *str = @"请到设置 -> 隐私 -> 媒体资料库 中打开 本APP的选项, 否则无法看本地视频";
            NSLog(@"%@", str);
//            [MBProgressHUD bjp_showMessageThenHide:str toView:self.view onHide:nil];
        }
    }];
    
    
    [self roomEnterSignal];
}

- (void)exitRoom {
    [self.room exit];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self bjl_stopAllKeyValueObserving];
    [self bjl_stopAllMethodArgumentsObserving];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 添加通知
- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playStatusChange:)
                                                 name:PKMoviePlayerPlaybackStateDidChangeNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerWillPlay:)
                                                 name:PMPlayerWillPlayNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playbackFinish:)
                                                 name:PKMoviePlayerPlaybackDidFinishNotification
                                               object:nil];
}


#pragma mark - BJPMProtocol 

- (void)videoplayer:(BJPlayerManager *)playerManager throwPlayError:(BJLError *)error {
    NSLog(@"=============== > error= %@", error);
    [MBProgressHUD bjp_showMessageThenHide:[error description] toView:self.view onHide:nil];
}


#pragma mark - noti seletor

- (void)playStatusChange:(NSNotification *)noti {
    
    if (self.room.playbackVM.playbackState == PKMoviePlaybackStatePlaying) {
//        NSLog(@"duration= %f", self.room.playbackVM.playerControl.player.duration);
        self.playButton.selected = NO;
        
        self.durationLabel.text = [self timeWithSecond:(CGFloat)self.room.playbackVM.duration];
        
    }
    if (self.room.playbackVM.playbackState == PKMoviePlaybackStatePaused) {
        self.playButton.selected = YES;
    }

}

- (void)loadStatusChange:(NSNotification *)noti {
    PKMoviePlayerController *vc = noti.object;
    if (vc.loadState == PKMovieLoadStateStalled) {
//         [MBProgressHUD bjp_showLoading:@"loading" toView:self.room.playbackVM.playView];
    }
    else if(vc.loadState == PKMovieLoadStatePlaythroughOK) {
//        [MBProgressHUD bjp_closeLoadingView:self.room.playbackVM.playView];
    }
}

- (void)playerWillPlay:(NSNotification *)noti {
    
    [self setupUI];
    [self uiChangeSignal];
    
    NSLog(@"noti ==> %@", noti);
    NSArray *arr =self.room.playbackVM.videoInfoModel.definitionList;
    for (PMVideoDefinitionInfoModel *item in arr) {
        NSLog(@"defintion = %@", item.definition);
        PMVideoDefinitionType type = item.definitionType;
        switch (type) {
            case DT_LOW:
                self.lowButton.enabled = YES;
                break;
            case DT_HIGH:
                self.highButton.enabled = YES;
                break;
            case DT_SUPPERHD:
                self.superHDButton.enabled = YES;
                break;
            default:
                break;
        }
    }
    PMVideoDefinitionType currentType = self.room.playbackVM.currDefinitionInfoModel.definitionType;
    switch (currentType) {
        case DT_LOW:
            self.lowButton.selected = YES;
            self.lowButton.userInteractionEnabled = NO;
            break;
        case DT_HIGH:
            self.highButton.selected = YES;
            self.highButton.userInteractionEnabled = NO;
            break;
        case DT_SUPPERHD:
            self.superHDButton.selected = YES;
            self.superHDButton.userInteractionEnabled = NO;
            break;
        default:
            break;
    }
        
}

- (void)playbackFinish:(NSNotification *)noti {
    
    self.playButton.selected = YES;
    
    PKMovieFinishReason reason = [[noti.userInfo objectForKey:PKMoviePlayerPlaybackDidFinishReasonUserInfoKey] integerValue];
    NSString *error = [noti.userInfo objectForKey:@"error"];
    switch (reason) {
        case PKMovieFinishReasonPlaybackEnded:
            [MBProgressHUD bjp_showMessageThenHide:@"Playback Ended ==> video finish" toView:self.view onHide:nil];
            break;
        
            
        case PKMovieFinishReasonPlaybackError:
            [MBProgressHUD bjp_showMessageThenHide:[NSString stringWithFormat:@"playback error ==> video finish, error:%@", error] toView:self.view onHide:nil];
            break;

        case PKMovieFinishReasonUserExited:
            [MBProgressHUD bjp_showMessageThenHide:@"User Exited ==> video finish" toView:self.view onHide:nil];
            break;
        default:
            break;
    }
}

@end

