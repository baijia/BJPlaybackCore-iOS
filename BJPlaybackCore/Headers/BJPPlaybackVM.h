//
//  BJPPlayVM.h
//  Pods
//
//  Created by 辛亚鹏 on 2016/12/21.
//
//

#import "BJLBaseVM.h"
#import <BJVideoPlayer/PKMoviePlayer.h>

@interface BJPPlaybackVM : NSObject

@property (nonatomic, readonly) PKMoviePlayerController *playerControl;
@property (nonatomic, readonly) NSTimeInterval currentTime;
@property (nonatomic, readonly) CGFloat currentPlayRate;
@property (nonatomic, readonly) PKMoviePlaybackState playbackState;
@property (nonatomic, readonly) NSTimeInterval seekTotime;
@property (nonatomic, readonly) NSString *lowUrlStr, *highUrlStr, *superHDUrlStr;


/**
 播放的倍率, 默认是1.0
 */
- (void)setRateSpeed:(CGFloat)rateSpeed;

/**
 设置播放地址和广告地址
 @param contentURL 正片地址 标清: lowUrlStr, 高清: highUrlStr, 超清: superHDUrlStr;
 @param adUrlList 广告地址 可为nil
 */
- (void)setContentURL:(NSString *)contentURL adUrlList:(nullable NSArray *)adUrlList;

/**
 play
 */
- (void)playerPlay;

/**
 pause
 */
- (void)playerPause;

/**
 strop
 */
- (void)playerStop;

/**
 seek
 * 内部会设置self.seekToTime = seekToTime
 @param time time
 */
- (void)playerSeekToTime:(NSTimeInterval)seekTotime;

@end
