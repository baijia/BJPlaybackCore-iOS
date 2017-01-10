# BJPlaybackCore

==============

## 1. 集成

- ```Podfile```里面设置```source```

``` 
source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/baijia/specs.git'
```
- ```Podfile```引入```BJPlaybackCore```

```
pod 'BJPlaybackCore' 
```

## 2. 导入头文件 
``` 
#import <BJPlaybackCore/BJPlaybackCore.h>
```

## 3. 创建房间
```/**
 创建回放的room

 @param classId classId
 @param partnerId 暂时传nil
 @return room
 */
+ (instancetype)createRoomWithClassId:(NSString *)classId partnerId:(nullable NSString *)partnerId;
```

## 4.进入房间,设置播放器
- 实例化播放器的管理类
```
/**
 进入教室
 @param frame 设置回放视频的view的frame
 */
- (void)enterWithPlaybackViewFrame:(CGRect)frame;
```

## 5.设置PPT
```
self.room.slideshowViewController.view
```
## 6.退出房间
```
/** 退出教室 */
- (void)exit;
```

## 7.changeLogs

- 参见```BJLiveCore```的```wiki```(https://github.com/baijia/BJLiveCore-iOS/wiki)
