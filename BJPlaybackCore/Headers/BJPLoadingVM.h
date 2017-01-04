//
//  BJPLoadingVM.h
//  Pods
//
//  Created by 辛亚鹏 on 2016/12/14.
//
//

#import "BJLBaseVM.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, BJPLoadingStep) {
    BJPLoadingStep_checkLocalFile       = 1 << 0,
    BJPLoadingStep_checkNetwork         = 1 << 1,
    BJPLoadingStep_connect              = 1 << 2,
    BJPLoadingStep_downloadFile         = 1 << 3,
};
typedef BJPLoadingStep BJPLoadingSteps;
static BJPLoadingSteps const BJPLoadingSteps_all = NSIntegerMax;

/**
 - stepOver: 单步完成，无错误 ignorable
 - checkFile: 检查文件
 - askForWWANNetwork: 蜂窝网络，ignorable
 - errorOccurred: 发生错误，unignorable，参考 BJLErrorCode
 */
typedef NS_ENUM(NSInteger, BJPLoadingSuspendReason) {
    BJPLoadingSuspendReason_stepOver,
    BJPLoadingSuspendReason_checkFile,
    BJPLoadingSuspendReason_askForWWANNetwork,
    BJPLoadingSuspendReason_errorOccurred
};

typedef void (^BJPLoadingSuspendCallback)(BOOL isContinue);
typedef void (^BJPLoadingSuspendBlock)(
BJPLoadingStep step,
BJPLoadingSuspendReason reason,
BJLError *error,
BOOL ignorable,
BJPLoadingSuspendCallback suspendCallback);

@interface BJPLoadingVM : NSObject

/**
 加载任务回调，在 suspendBlock 中调用 callback(BOOL isContinue) 决定是否继续
 @param reason      暂停原因
 @param error       具体错误
 @param ignorable   错误是否可以被忽略
 @param callback(BOOL isContinue)   回调，suspendBlock 为 nil 时使用 ignorable 当作 isContinue
 isContinue: ignorable 为 YES 时表示是否忽略该错误、执行下一步骤，否则表示是否重试当前步骤
 */
@property (nonatomic, nullable, copy) BJPLoadingSuspendBlock suspendBlock;

// TODO: MingLQ - 初始连接、断开重连

/** 加载进度 */
- (BJLOEvent)loadingDidUpdateProgress:(CGFloat)progress; // progress: 0.0 ~ 1.0
/** 加载成功 */
- (BJLOEvent)loadingDidSuccess;
/** 加载失败 */
- (BJLOEvent)loadingDidFailureWithError:(nullable BJLError *)error;

@end

NS_ASSUME_NONNULL_END
