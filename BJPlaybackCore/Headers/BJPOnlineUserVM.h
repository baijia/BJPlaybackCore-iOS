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
/** 在线用户，分页加载
 参考 `- loadMoreOnlineUsersWithCount:` */
@property (nonatomic, readonly, nullable, copy) NSArray<NSObject<BJLOnlineUser> *> *onlineUsers;
/** 是否有更多在线用户未加载 */
@property (nonatomic, readonly) BOOL hasMoreOnlineUsers;
/** 在线的老师 */
@property (nonatomic, readonly, nullable) NSObject<BJLOnlineUser> *onlineTeacher;

/** 加载更多在线用户
 连接教室后、掉线重新连接后自动调用加载
 加载成功更新 `onlineUsers` */
// count: 传 0 默认 20、最多 30
- (nullable BJLError *)loadMoreOnlineUsersWithCount:(NSInteger)count;

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
