//
//  BJPRoom.h
//  Pods
//
//  Created by 辛亚鹏 on 2016/12/14.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BJLBlockHelper.h"

#import "BJLConstants.h"
#import "BJLFeatureConfig.h"

/** VM **/

#import "BJLRoomVM.h"
#import "BJLOnlineUsersVM.h"

#import "BJLMediaVM.h"
#import "BJLPlayingVM.h"

#import "BJLSlideVM.h"
#import "BJLSlideshowVM.h"

#import "BJLChatVM.h"

#import "BJLServerRecordingVM.h"

/** UI */

#import "BJLSlideshowUI.h"

#import "BJPLoadingVM.h"
#import "BJPPlaybackVM.h"

NS_ASSUME_NONNULL_BEGIN

/**
 教室
 可同时存在多个实例，但最多只有一个教室处于进入状态，后执行 enter 的教室会把之前的教室踢掉
 */
@interface BJPRoom : NSObject

#pragma mark lifecycle

/** 创建回放的room */
+ (instancetype)roomWithClassId:(NSString *)classId deployType:(BJLDeployType)deployType;

/** 进入教室 */
- (void)enter;

/** 退出教室 */
- (void)exit;

/** 成功进入教室 */
- (BJLOEvent)roomDidEnter;

/**
 退出教室事件，参考 BJLErrorDomain
 */
- (BJLOEvent)roomWillExitWithError:(BJLError *)error;
- (BJLOEvent)roomDidExitWithError:(BJLError *)error;

/** 回放的管理VM */
@property (nonatomic, readonly, nullable) BJPPlaybackVM *playbackVM;

/** 进教室的 loading 状态 */
@property (nonatomic, readonly, nullable) BJPLoadingVM *loadingVM;

/** 设置视频清晰度的URL, 标清, 高清, 超清 */
@property (nonatomic, readonly, nullable) NSString *lowUrlStr, *highUrlStr, *superHDUrlStr;

/** 回放视频的view */
@property (nonatomic, readonly, nullable) UIView *playbackView;

/** 视频的id */
@property (readonly, nonatomic, nonnull) NSString *classId;

/** 本地文件的路径 */
@property (strong, nonatomic) NSString *filePath;

/** 教室信息、状态，用户信息，公告等 */
@property (nonatomic, readonly, nullable) BJLRoomVM *roomVM;

/** 在线用户 */
@property (nonatomic, readonly, nullable) BJLOnlineUsersVM *onlineUsersVM;

/** 音视频 设置 */
@property (nonatomic, readonly, nullable) BJLMediaVM *mediaVM;

/** 课件管理 */
@property (nonatomic, readonly, nullable) BJLSlideVM *slideVM;

/** 课件显示 */
@property (nonatomic, readonly, nullable) UIViewController<BJLSlideshowUI> *slideshowViewController;

/** 聊天 */
@property (nonatomic, readonly, nullable) BJLChatVM *chatVM;

@end

NS_ASSUME_NONNULL_END
