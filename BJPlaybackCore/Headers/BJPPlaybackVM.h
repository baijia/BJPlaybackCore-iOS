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

//播放本地视频, 解压信令文件失败的通知
extern const NSString *BJPSignalFileUnarchiveFild __deprecated_msg("不需要监听这个通知, 监听进入房间失败的信息");

@interface BJPPlaybackVM : NSObject

/**
 设置回放用户的标识符
 */
@property (nonatomic) NSString *userInfo;

/**
 当前的播放时间  支持KVO
 */
@property (nonatomic, readonly) NSTimeInterval currentTime;

/**
 播放控制器
 */
@property (nonatomic) BJPlayerManager *playerControl;

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
 播放信息
 */
@property (nonatomic, readonly) PMVideoInfoModel *videoInfoModel;

/**
 当前播放清晰度
 */
@property (nonatomic, readonly) PMVideoDefinitionInfoModel *currDefinitionInfoModel;

/**
 当前播放的CDN
 */
@property (nonatomic, readonly) PMVideoCDNInfoModel *currCDNInfoModel;



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
