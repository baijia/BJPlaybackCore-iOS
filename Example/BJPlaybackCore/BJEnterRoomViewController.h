//
//  BJViewController.h
//  BJPlaybackCore
//
//  Created by 辛亚鹏 on 01/04/2017.
//  Copyright (c) 2017 辛亚鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BJPlaybackCore/BJPlaybackCore.h>

@interface BJEnterRoomViewController : UIViewController

@property (nonatomic) BJPRoom *room;

+ (instancetype)enterRoomWithClassId:(NSString *)classId partnerId:(NSString *)partnerId;

@end
