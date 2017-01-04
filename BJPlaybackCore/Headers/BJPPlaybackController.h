//
//  PBPlaybackController.h
//  Pods
//
//  Created by 辛亚鹏 on 2016/12/19.
//
//  控制播放器

#import <UIKit/UIKit.h>

@interface BJPPlaybackController : UIViewController

@property (assign, nonatomic,readonly) NSTimeInterval currentTime;
@property (assign, nonatomic,readonly) CGFloat currentPlayRate;

/**
 播放的倍率, 默认是1.0
 */
@property (assign, nonatomic) CGFloat rateSpeed;

/**
 设置播放地址和广告地址
 @param contentURL 正片地址
 @param adUrlList 广告地址 可为nil
 */
- (void)setContentURL:(NSURL *)contentURL adUrlList:(nullable NSArray *)adUrlList;

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

 @param time time
 */
- (void)playerSeekToTime:(NSTimeInterval)time;

@end
