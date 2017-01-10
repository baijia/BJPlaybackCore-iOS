# BJPlaybackCore

==============

## 1. 集成

- podFile里面设置source,

``` 
source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/baijia/specs.git'
```
- podFile引入BJPlaybackCore

```
pod 'BJPlaybackCore' 
```

## 2. 导入头文件 
``` 
#import <BJPlaybackCore/BJPlaybackCore.h>
```

## 3. 创建房间
```
/** 创建回放的room */
+ (instancetype)createRoom;
```

## 4.进入房间,设置播放器
- 实例化播放器的管理类
```
BJPPlaybackVM *playbackVM = [BJPPlaybackVM playback];
```
- 设置播放器的```classId```和```frame```

```
    CGFloat width = ScreenWidth < ScreenHeight ? ScreenWidth : ScreenHeight;
    CGRect frame = CGRectMake(0, 64, width, width*9/16);
    //partnerId暂传nil
   [playbackVM playVideoWithClassId:self.classId frame:frame partnerId:nil];
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
