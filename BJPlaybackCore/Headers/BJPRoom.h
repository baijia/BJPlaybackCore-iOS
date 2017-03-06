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
 播放在线视频播放 进入教室
 */
- (void)enter;

/**
 播放本地视频  进入房间

 @param videoPath 本地视频的路径
 @param startVideo 片头地址, 可为nil
 @param endVideo 片尾地址,可为nil
 @param path 本地信令 压缩文件的路径
 */
- (void)enterRoomWithVideoPath:(NSString *)videoPath
                    startVideo:(nullable NSString*)startVideo
                      endVideo:(nullable NSString*)endVideo
                    signalPath:(NSString *)signalPath
                    definition:(PMVideoDefinitionType)definition;

/** 退出教室 */
- (void)exit;

/** 
 成功进入教室后,
 case: 在线播放, 获取playbackVM的播放信息
 case: 本地视频, 信令文件解压完毕,并载入内存
 */
- (BJLObservable)roomDidEnterWithError:(BJLError *)error;

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
