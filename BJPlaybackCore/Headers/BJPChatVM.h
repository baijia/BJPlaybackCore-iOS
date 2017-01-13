//
//  BJPChatVM.h
//  Pods
//
//  Created by 辛亚鹏 on 2017/1/12.
//
//


#import <Foundation/Foundation.h>

#import "BJLMessage.h"
#import "NSObject+BJLObserving.h"

@interface BJPChatVM : NSObject

/** 所有消息 */
//@property (nonatomic, readonly, nullable, copy) NSArray<NSObject<BJLMessage> *> *receivedMessages;

/** 收到消息 , 返回一个消息的数组*/
- (BJLObservable)didReceiveMessage:(NSArray<NSObject<BJLMessage>*> *)messageArray;

@end
