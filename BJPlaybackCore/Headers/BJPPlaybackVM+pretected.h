//
//  BJPPlaybackVM+pretected.h
//  Pods
//
//  Created by 辛亚鹏 on 2017/1/4.
//
//

#import <BJPlaybackCore/BJPlaybackCore.h>
#import "_BJPContext.h"

@interface BJPPlaybackVM ()

@property (nonatomic, readonly, nullable, weak) BJPContext *context;
+ (instancetype)instanceWithContext:(BJPContext *)context;

@end
