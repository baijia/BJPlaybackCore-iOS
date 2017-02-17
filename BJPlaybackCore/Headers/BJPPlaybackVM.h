//
//  BJPPlayVM.h
//  Pods
//
//  Created by 辛亚鹏 on 2016/12/21.
//
//

#import "BJLBaseVM.h"
#import <BJHL-VideoPlayer-Manager/BJHL-VideoPlayer-Manager.h>

@class BJPSignalModel;

@interface BJPPlaybackVM : NSObject

/**
 播放控制器
 */
@property (nonatomic, readonly) BJPlayerManager *playerControl;

/**
 当前的播放时间
 */
@property (nonatomic, readonly) NSTimeInterval currentTime;

/**
 当前的播放速度
 */
@property (nonatomic, readonly) CGFloat currentPlayRate;

/**
 播放状态
 */
@property (nonatomic, readonly) PKMoviePlaybackState playbackState;

/**
 信令文件的url
 */
@property (nonatomic, readonly) BJPSignalModel *signalModel;

/**
 播放器的view
 */
@property (nonatomic, readonly) UIView *playView;

/**
 设置回放用户的标识符
 */
@property (nonatomic) NSString *userInfo;

/**
 播放信息
 */
@property (nonatomic, readonly) PMVideoInfoModel *videoInfoModel;

/**
 @param classId classId
 @param token   token
 */
- (void)playVideoWithClassId:(NSString *)classId token:(NSString *)token;

/**
 play
 */
- (void)playerPlay;

/**
 pause
 */
- (void)playerPause;

/**
 stop
 */
- (void)playerStop;

/**
 seek
 @param seekTotime time
 */
- (void)playerSeekToTime:(NSTimeInterval)seekTotime;

/**
 change rate

 @param rate rate, default: 1.0
 */
- (void)changeRate:(CGFloat)rate;

/**
 play by vid

 @param vid vid
 */
- (void)playVideoById:(NSInteger)vid;

@end
