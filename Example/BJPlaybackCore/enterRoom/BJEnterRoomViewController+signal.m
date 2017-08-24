//
//  BJEnterRoomViewController+signal.m
//  BJPlaybackCore
//
//  Created by 辛亚鹏 on 2017/3/15.
//  Copyright © 2017年 Baijia Cloud. All rights reserved.
//

#import "BJEnterRoomViewController+signal.h"
#import "MBProgressHUD+bjp.h"

#import <ReactiveObjC/ReactiveObjC.h>
#import <MBProgressHUD/MBProgressHUD.h>

@implementation BJEnterRoomViewController (signal)

- (void)roomEnterSignal {
    [self roomSignal];
    [self vmSiganl];
}

- (void)uiChangeSignal {
    [self buttonAndSliderSignal];
    [self definitionChange];
    [self rateChange];
}

- (void)roomSignal {
    @weakify(self);
    
    [self bjl_observe:BJLMakeMethod(self.room, roomDidEnterWithError:)
             observer:^BOOL(BJLError *error) {
                 if (error) {
                     //                     NSLog(@"roomDidEnterWithError ==> error = %@", error);
                     [MBProgressHUD bjp_showMessageThenHide:[error description] toView:self.view onHide:nil];
                     
                 }
                 return YES;
             }];
    [self bjl_observe:BJLMakeMethod(self.room, roomWillExitWithError:)
             observer:^BOOL(BJLError *error) {
                 //                 @strongify(self);
                 //                 NSLog(@"roomWillExitWithError ==> error = %@", error);
                 [MBProgressHUD bjp_showMessageThenHide:[error description] toView:self.view onHide:nil];
                 return YES;
             }];
    
    [self bjl_observe:BJLMakeMethod(self.room, roomDidExitWithError:)
             observer:^BOOL(BJLError *error) {
                 //                 @strongify(self);
                 //                 NSLog(@"roomDidExitWithError ==> error = %@", error);
                 [MBProgressHUD bjp_showMessageThenHide:[error description] toView:self.view onHide:nil];
                 return YES;
             }];
    
    [self bjl_observe:BJLMakeMethod(self.room, didReceiveMessageList:)
             observer:^BOOL(NSArray<BJPMessage *> *messageArray){
                 @strongify(self);
                 //                 self.chatCtrl.chatList = messageArray;
                 if (messageArray.count > 0) {
                     for (BJPMessage *msg in messageArray) {
                         [self.chatCtrl.chatList addObject:msg];
                     }
                 }
                 [self.chatCtrl.tableView reloadData];
                 //                 NSLog(@"self.chatCtrl.chatList = %@", self.chatCtrl.chatList);
                 return YES;
             }];
    
    [self bjl_observe:BJLMakeMethod(self.room, latestMediaPublish:)
             observer:^BOOL(BJPMediaPublish *mediaPublish){
                 //                 @strongify(self);
                 //                 NSLog(@"mediaPublish.offsetTimestamp === %li", mediaPublish.offsetTimestamp);
                 return YES;
             }];
}

- (void)vmSiganl {
    @weakify(self);
    [self bjl_observe:BJLMakeMethod(self.room.onlineUsersVM, onlineUserCount:)
             observer:^BOOL(NSNumber *count){
                 @strongify(self);
                 self.userTotalCountLabel.text = [NSString stringWithFormat:@"    totalUserCount: %@", count];
                 
                 return YES;
             }];
    
    [self bjl_observe:BJLMakeMethod(self.room.onlineUsersVM, onlineUserList:)
             observer:^BOOL(NSArray <BJLOnlineUser *> *userList){
                 @strongify(self);
                 self.userCtrl.userList = userList;
                 [self.userCtrl.tableView reloadData];
                 return YES;
             }];
    [self bjl_kvo:BJLMakeProperty(self.room.playbackVM, currentTime) observer:^BOOL(NSNumber * _Nullable old, NSNumber *  _Nullable now) {
        
        //        NSLog(@"old = %@ \n===============*********=============\n now = %@", old, now);
        CGFloat time = [now floatValue];
        CGFloat duration = self.room.playbackVM.duration;
        self.currentTimeLabel.text = [self timeWithTime:time];
        self.durationLabel.text = [self timeWithTime:(CGFloat)self.room.playbackVM.duration];
        self.progressSlider.value = time / duration;
        return YES;
    }];
}

- (void)buttonAndSliderSignal {
    @weakify(self);
    [[self.playButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *btn) {
        @strongify(self);
        btn.selected = !btn.selected;
        
        //selected 暂停
        if (btn.selected) {
            [self.room.playbackVM playerPause];
        }
        else {
            [self.room.playbackVM playerPlay];
        }
    }];
    //    UIControlEventTouchUpInside 表示手指抬起的动作
    [[self.progressSlider rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UISlider *slider) {
        @strongify(self);
        double currentTime = self.room.playbackVM.duration * slider.value;
        [self.room.playbackVM playerSeekToTime:currentTime];
        self.currentTimeLabel.text = [self timeWithTime:currentTime];
    }];
    [[self.progressSlider rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UISlider *slider) {
        @strongify(self);
        double currentTime = self.room.playbackVM.duration * slider.value;
        self.currentTimeLabel.text = [self timeWithTime:currentTime];
    }];
    
    [[self.progressSlider rac_signalForControlEvents:UIControlEventTouchUpOutside] subscribeNext:^(UISlider *slider) {
        @strongify(self);
        double currentTime = self.room.playbackVM.duration * slider.value;
        [self.room.playbackVM playerSeekToTime:currentTime];
        self.currentTimeLabel.text = [self timeWithTime:currentTime];
    }];
    
}

- (void)definitionChange {
    @weakify(self);
    [[self.lowButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *btn) {
        
        @strongify(self);
        if (!btn.selected) {
            btn.selected = YES;
            self.highButton.selected = NO;
            self.superHDButton.selected = NO;
            btn.userInteractionEnabled = !btn.selected;
            self.highButton.userInteractionEnabled = !self.highButton.selected;
            self.superHDButton.userInteractionEnabled = !self.superHDButton.selected;
            [self.room.playbackVM changeDefinition:DT_LOW];
        }
    }];
    
    [[self.highButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *btn) {
        @strongify(self);
        if (!btn.selected) {
            btn.selected = YES;
            self.lowButton.selected = NO;
            self.superHDButton.selected = NO;
            btn.userInteractionEnabled = !btn.selected;
            self.lowButton.userInteractionEnabled = !self.lowButton.selected;
            self.superHDButton.userInteractionEnabled = !self.superHDButton.selected;
            [self.room.playbackVM changeDefinition:DT_HIGH];
        }
    }];
    [[self.superHDButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *btn) {
        @strongify(self);
        if (!btn.selected) {
            btn.selected = YES;
            self.highButton.selected = NO;
            self.lowButton.selected = NO;
            btn.userInteractionEnabled = !btn.selected;
            self.highButton.userInteractionEnabled = !self.highButton.selected;
            self.lowButton.userInteractionEnabled = !self.lowButton.selected;
            [self.room.playbackVM changeDefinition:DT_SUPPERHD];
        }
    }];
}

- (void)rateChange {
    @weakify(self);
    [[self.rateSegmentCtrl rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UISegmentedControl *segCtrl) {
        @strongify(self);
        NSUInteger index = segCtrl.selectedSegmentIndex;
        NSString *str = [self.rateArray objectAtIndex:index];
        CGFloat rate = [str floatValue];
        [self.room.playbackVM changeRate:rate];
    }];
}

#pragma mark -
- (NSString *)timeWithSecond:(CGFloat)second {
    return [self timeWithTime:second];
}

- (NSString *)timeWithTime:(CGFloat)time {
    //    3753 == 1:02:33   33 + 120 + 3600
    NSUInteger uTime = (NSUInteger)time;
    NSUInteger hour = uTime / 3660;
    NSUInteger min;
    if (hour > 0) {
        min = uTime % 3600 / 60;
    }
    else {
        min = uTime / 60;
    }
    NSUInteger second = uTime % 60;
    NSString *str = @"";
    if (hour > 0) {
        str = [NSString stringWithFormat:@"%lu:%02lu:%02lu", (unsigned long)hour, min, second];
    }
    else{
        str = [NSString stringWithFormat:@"%02lu:%02lu", (unsigned long)min, second];
    }
    return str;
}

@end
