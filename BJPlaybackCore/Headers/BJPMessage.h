//
//  BJPMessage.h
//  Pods
//
//  Created by 辛亚鹏 on 2017/1/18.
//
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>

@interface BJPMessage : NSObject<YYModel>

@property (assign, nonatomic) NSInteger offsetTimestamp;
@property (strong, nonatomic) NSString *classId, *content;

@property (strong, nonatomic) NSString *userAvatar; //用户头像图片的url
@property (strong, nonatomic) NSString *userName;

@end
