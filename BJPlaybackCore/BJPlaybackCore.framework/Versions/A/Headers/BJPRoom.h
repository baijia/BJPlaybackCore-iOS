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

/**
 播放本地视频访问媒体资料库时, 用户选择的状态, 只在iOS10以上的系统有效
 */
typedef NS_ENUM(NSInteger, BJPMediaLibraryAuthorizationStatus) {
    BJPMediaLibraryAuthorizationStatusNotDetermined = 0,
    BJPMediaLibraryAuthorizationStatusDenied,
    BJPMediaLibraryAuthorizationStatusRestricted,
    BJPMediaLibraryAuthorizationStatusAuthorized,
};

NS_ASSUME_NONNULL_BEGIN

/**
 教室
 可同时存在多个实例，但最多只有一个教室处于进入状态，后执行 enter 的教室会把之前的教室踢掉
 */
@interface BJPRoom : NSObject

/**
 创建回放的room
 创建在线视频, 参数不可传空
 创建本地room的话, 两个参数传nil

 @param classId classId
 @param token token
 @return room
 */
+ (instancetype)createRoomWithClassId:(nullable NSString *)classId token:(nullable NSString *)token;

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
 @param handle 用于在iOS10以上的系统用户授权进入本地资料库, 如果版本低iOS10,不需要授权,
               即status = BJPMediaLibraryAuthorizationStatusAuthorized
 */
- (void)enterRoomWithVideoPath:(NSString *)videoPath
                    startVideo:(nullable NSString*)startVideo
                      endVideo:(nullable NSString*)endVideo
                    signalPath:(NSString *)signalPath
                    definition:(PMVideoDefinitionType)definition
                        status:(void (^)(BJPMediaLibraryAuthorizationStatus status))handle;;

/** 退出教室 */
- (void)exit;

/** 
 成功进入教室后,
 @param error:成功进入房间, error为空, 如果有失败, error不为空
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
 聊天信息的list,批量更新
 */
- (BJLObservable)didReceiveMessageList:(NSArray <BJPMessage *> *)messageList;

/**
 聊天信息的list,增量更新
 */
- (BJLObservable)didReceiveNewMessageList:(NSArray <BJPMessage *> *)messageList;

/** 回放的管理VM */
@property (nonatomic, readonly, nullable) BJPPlaybackVM *playbackVM;

/**
 聊天的数组
 */
//@property (nonatomic, nullable) NSArray <PBChatModel *>*chatMessageList;

/** loadingVM */
@property (nonatomic, readonly, nullable) BJPLoadingVM *loadingVM;

/** 教室id */
@property (readonly, nonatomic, nonnull) NSString *classId;

/** 教室信息、状态，用户信息，公告等 */
@property (nonatomic, readonly, nullable) BJLRoomVM *roomVM;

/** 在线用户 */
@property (nonatomic, readonly, nullable) BJPOnlineUserVM *onlineUsersVM;

/** 课件显示 */
@property (nonatomic, readonly, nullable) UIViewController<BJLSlideshowUI> *slideshowViewController;

@end

NS_ASSUME_NONNULL_END
