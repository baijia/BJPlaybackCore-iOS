//
//  BJPPlayVM.h
//  Pods
//
//  Created by 辛亚鹏 on 2016/12/21.
//
//

#import "BJLBaseVM.h"
#import <BJHL-VideoPlayer-Manager/BJHL-VideoPlayer-Manager.h>

@class PBSignalModel;

@interface BJPPlaybackVM : NSObject

@property (nonatomic, readonly) PMPlayerViewController *playerControl;
@property (nonatomic, readonly) NSTimeInterval currentTime;
@property (nonatomic, readonly) CGFloat currentPlayRate;
@property (nonatomic, readonly) PKMoviePlaybackState playbackState;
@property (nonatomic, readonly) NSTimeInterval seekTotime;
@property (nonatomic, readonly) PBSignalModel *signalModel;
@property (nonatomic) UIView *playView;

/**
 <#Description#>

 @param classId 回放的classId
 @param frame 播放器view的frame
 @param partnerId 合作方id, 暂传nil
 */
- (void)playVideoWithClassId:(NSString *)classId frame:(CGRect)frame partnerId:(NSString *)partnerId;

/**
 播放的倍率, 默认是1.0
 */
- (void)setRateSpeed:(CGFloat)rateSpeed;

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

@end
