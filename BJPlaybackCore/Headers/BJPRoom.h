//
//  BJPRoom.h
//  Pods
//
//  Created by 辛亚鹏 on 2016/12/14.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <BJLiveCore/BJLiveCore.h>

#import "BJPOnlineUserVM.h"
#import "BJPLoadingVM.h"
#import "BJPPlaybackVM.h"

#import "BJPMessage.h"

/** UI */
//#import "BJLSlideshowUI.h"


NS_ASSUME_NONNULL_BEGIN

/**
 教室
 可同时存在多个实例，但最多只有一个教室处于进入状态，后执行 enter 的教室会把之前的教室踢掉
 */
@interface BJPRoom : NSObject

#pragma mark lifecycle

/**
 创建回放的room

 @param classId classId
 @param partnerId 暂时传nil
 @return room
 */
+ (instancetype)createRoomWithClassId:(NSString *)classId token:(NSString *)token;

/**
 进入教室
 @param frame 设置回放视频的view的frame
 */
- (void)enter;

/** 退出教室 */
- (void)exit;

/** 成功进入教室, 才可以获取playbackVM的一些播放信息 */
- (BJLObservable)roomDidEnter;

/**
 退出教室事件，参考 BJLErrorDomain
 */
- (BJLObservable)roomWillExitWithError:(BJLError *)error;
- (BJLObservable)roomDidExitWithError:(BJLError *)error;

/**
 聊天信息的list
 */
- (BJLObservable)didReceiveMessageList:(NSArray <BJPMessage *> *)messageList;

/** 回放的管理VM */
@property (nonatomic, readonly, nullable) BJPPlaybackVM *playbackVM;

/**
 聊天的数组
 */
//@property (nonatomic, nullable) NSArray <PBChatModel *>*chatMessageList;

/** 进教室的 loading 状态 */
@property (nonatomic, readonly, nullable) BJPLoadingVM *loadingVM;

/** 教室id */
@property (readonly, nonatomic, nonnull) NSString *classId;

/** 教室信息、状态，用户信息，公告等 */
@property (nonatomic, readonly, nullable) BJLRoomVM *roomVM;

/** 在线用户 */
@property (nonatomic, readonly, nullable) BJPOnlineUserVM *onlineUsersVM;

/** 音视频 设置 */
@property (nonatomic, readonly, nullable) BJLMediaVM *mediaVM;

/** 课件管理 */
@property (nonatomic, readonly, nullable) BJLSlideVM *slideVM;

/** 课件显示 */
@property (nonatomic, readonly, nullable) UIViewController<BJLSlideshowUI> *slideshowViewController;

@end

NS_ASSUME_NONNULL_END
