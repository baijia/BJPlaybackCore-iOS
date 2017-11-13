//
//  BJPPlayVM.h
//  Pods
//
//  Created by 辛亚鹏 on 2016/12/21.
//
//

#import <BJLiveCore/BJLBaseVM.h>
#import <BJPlayerManagerCore/BJPlayerManagerCore.h>

@class BJPSignalModel;

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
 视频的总时长
 */
@property (nonatomic, readonly) NSTimeInterval duration;

/**
 初始化播放时间, 用于记忆播放, 需要在进入房间之前设置
 */
@property (nonatomic) NSTimeInterval initialPlaybackTime;

/**
 播放控制器
 */
@property (nonatomic, readonly) BJPlayerManager *playerControl;

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
 切换清晰度

 @param dt 清晰度
 */
- (void)changeDefinition:(PMVideoDefinitionType)dt;

@end
