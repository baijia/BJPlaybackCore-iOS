BJPlaybackCore
==============
## 1. 集成
``` pod 'BJPlaybackCore' ```

## 2. 导入头文件 
``` #import <BJPlaybackCore/BJPlaybackCore.h> ```

## 3. 创建房间
```
/** 创建回放的room */
+ (instancetype)roomWithClassId:(NSString *)classId deployType:(BJLDeployType)deployType;
```
> classId为教室id, deployType参考直播SDK

## 4.进入房间
可以监听loadingVM的状态,加载完毕之后, 视频默认标清.

## 5.PPT和白板
```
self.room.slideshowViewController.view
```
## 6.退出房间
```
/** 退出教室 */
- (void)exit;
```
