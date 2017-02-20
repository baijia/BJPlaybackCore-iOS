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
 @param token token
 @return room
 */
+ (instancetype)createRoomWithClassId:(NSString *)classId token:(NSString *)token;
```
## 4.进入房间
```
[self.room enter];
```

## 5.设置播放器, 自定义UI
- 上报回放用户的标识符
```
[self.room.playbackVM setUserInfo:_userInfo];
```
- 自定义播放器的UI
```
self.room.playbackVM.playView是播放器的view, 可自定义frame,
播放器的其他功能可查看BJPPlaybackVM.h, 调用相关的API即可实现.
```
## 6.设置PPT
```
self.room.slideshowViewController.view
```
## 7.退出房间
```
/** 退出教室 */
- (void)exit;
```

## 8.changeLogs

- 参见```BJLiveCore```的```wiki```(https://github.com/baijia/BJLiveCore-iOS/wiki)
