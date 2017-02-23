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

## 3. 创建房间并设置播放器的代理,上报回放用户的标识符
- 创建回放的room
```/**

 @param classId classId
 @param token token
 @return room
 */
+ (instancetype)createRoomWithClassId:(NSString *)classId token:(NSString *)token;
```
- 遵守<BJPMProtocol>, 设置播放器的代理
```
self.room.playbackVM.playerControl.delegate = self;


遵守协议需要实现的方法:
/**
播放过程中出错

@param playerManager 播放器实例
@param error 错误
*/
- (void)videoplayer:(BJPlayerManager *)playerManager throwPlayError:(NSError *)error;

```
- 上报回放用户的标识符
```
[self.room.playbackVM setUserInfo:_userInfo];
```


## 4.进入房间
```
[self.room enter];
```

## 5.自定义UI

1. 自定义播放器的UI
```
self.room.playbackVM.playView是播放器的view, 可自定义frame,
```
2. 播放器的播放时间支持KVO回调
```
[self bjl_kvo:BJLMakeProperty(self.room.playbackVM, currentTime) observer:^BOOL(NSNumber * _Nullable old, NSNumber *  _Nullable now) {
     //code
     return YES;
}];
```

3. 播放信息```self.room.playbackVM.videoInfoModel```在```roomDidEnter```之后才有信息

4. 播放器的其他功能可查看```BJPPlaybackVM.h```, 调用相关的API即可实现.

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
- 0.1.6: fix crash, 优化回调
