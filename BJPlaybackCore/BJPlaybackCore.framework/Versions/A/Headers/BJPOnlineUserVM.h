//
//  BJPUserVM.h
//  Pods
//
//  Created by 辛亚鹏 on 2017/1/12.
//
//

#import <Foundation/Foundation.h>

#import "BJLUser.h"
#import "NSObject+BJLObserving.h"

@interface BJPOnlineUserVM : NSObject

/** 在线人数 */
@property (nonatomic, readonly) NSInteger onlineUsersTotalCount;

/** 有用户进入房间
 同时更新 `onlineUsers` */
- (BJLObservable)onlineUserDidEnter:(NSObject<BJLOnlineUser> *)user;
/** 有用户退出房间
 同时更新 `onlineUsers` */
- (BJLObservable)onlineUserDidExit:(NSObject<BJLOnlineUser> *)user;


/**
 监听可以获取userCount
*/
- (BJLObservable)onlineUserCount:(NSNumber *)count;

/**
 监听可以获取用户列表
*/
- (BJLObservable)onlineUserList:(NSArray <NSObject<BJLOnlineUser> *> *)userList;

@end
