//
//  BJEnterRoomViewController+UI.m
//  BJPlaybackCore
//
//  Created by 辛亚鹏 on 2017/3/13.
//  Copyright © 2017年 Baijia Cloud. All rights reserved.
//

#import "BJEnterRoomViewController+UI.h"
#import <Masonry/Masonry.h>
#import <ReactiveObjC/ReactiveObjC.h>

@implementation BJEnterRoomViewController (UI)

- (void)setupUI {
    [self setupDefinitionButton];
    [self setupRateSegmentCtrl];
    [self setupPlayer];
    [self setupProgeressView];
    
    [self userTotalCountLabelSetup];
    [self bottomViewSetup];
}

#pragma mark - setupView

- (void)setupDefinitionButton {
    self.lowButton = [self buttonWithTiltle:@"流畅"];
    self.highButton = [self buttonWithTiltle:@"标清"];
    self.superHDButton = [self buttonWithTiltle:@"高清"];
    
    self.lowButton.enabled = NO;
    self.highButton.enabled = NO;
    self.superHDButton.enabled = NO;
    
    [self.view addSubview:self.lowButton];
    [self.view addSubview:self.highButton];
    [self.view addSubview:self.superHDButton];
    
    NSArray<UIButton *> *arr = @[self.lowButton, self.highButton, self.superHDButton];
    [arr enumerateObjectsUsingBlock:^(UIButton * _Nonnull btn, NSUInteger idx, BOOL * _Nonnull stop) {
        btn.frame = CGRectMake(idx * (45 + 10) +10, 64, 45.f, 30);
    }];
}

- (void)setupRateSegmentCtrl {
    self.rateArray = @[@"1.0", @"1.2", @"1.5", @"2.0"];
    self.rateSegmentCtrl = [[UISegmentedControl alloc] initWithItems:self.rateArray];
    [self.rateSegmentCtrl setSelectedSegmentIndex:0];
    [self.view addSubview:self.rateSegmentCtrl];
    [self.rateSegmentCtrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-10);
        make.width.equalTo(@180);
        make.top.equalTo(self.view).offset(64);
    }];
}

- (void)setupPlayer {
    CGFloat width = ScreenWidth < ScreenHeight ? ScreenWidth : ScreenHeight;
    self.playerView = [[UIView alloc] initWithFrame:CGRectMake(0, 94, width, width*9/16)];
    [self.view addSubview:self.playerView];

    CGRect frame = CGRectMake(0, 0, width, width*9/16);
    self.room.playbackVM.playView.frame = frame;
    [self.playerView addSubview:self.room.playbackVM.playView];

}

- (void)setupProgeressView {
    //播放按钮 播放时长 进度的容器view
    UIView *progeressView = [UIView new];
    progeressView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.8];
    [self.playerView addSubview:progeressView];
    [progeressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.room.playbackVM.playView);
        make.height.equalTo(@40);
    }];
    
    self.playButton = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"ic_pause"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"ic_play"] forState:UIControlStateSelected];
        btn;
    });
    [progeressView addSubview:self.playButton];
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20.f);
//        make.bottom.equalTo(self.room.playbackVM.playView).offset(-20.f);
        make.centerY.equalTo(progeressView);
    }];
    
    self.currentTimeLabel = [UILabel new];
    self.currentTimeLabel.textColor = [UIColor whiteColor];
    self.currentTimeLabel.text = @"--:--";
    
    [progeressView addSubview:self.currentTimeLabel];
    [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playButton.mas_right).offset(10.f);
//        make.width.equalTo(@55);
        make.centerY.equalTo(self.playButton);
    }];
    
    self.durationLabel = [UILabel new];
    self.durationLabel.textColor = [UIColor whiteColor];
    [progeressView addSubview:self.durationLabel];
    self.durationLabel.text = @"--:--";
    
    [self.durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-5.f);
        make.width.equalTo(@85);
        make.centerY.equalTo(self.playButton);
    }];
    
    self.progressSlider = [UISlider new];
    [progeressView addSubview:self.progressSlider];
    [self.progressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.currentTimeLabel.mas_right).offset(10.f);
        make.right.equalTo(self.durationLabel.mas_left).offset(-10);
        make.centerY.equalTo(self.playButton);
        make.height.equalTo(@10);
    }];
    
}


- (void)userTotalCountLabelSetup {
    UILabel *label = [[UILabel alloc] init];
    self.userTotalCountLabel = label;
    label.layer.borderColor = [UIColor grayColor].CGColor;
    label.layer.borderWidth = 0.5f;
    label.font = [UIFont systemFontOfSize:12.f];
    label.text = @"   totalUserCount:";
    
    [self.view addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(5.f);
        make.right.equalTo(self.view).offset(-5.f);
        make.top.equalTo(self.room.playbackVM.playView.mas_bottom).offset(10.f);
        make.height.equalTo(@25);
    }];
    
}

- (void)bottomViewSetup {
    
    UISegmentedControl *segmentCotl = [[UISegmentedControl alloc] initWithItems:@[@"PPT", @"userList", @"chatList"]];
    self.segmentCtrl = segmentCotl;
    [segmentCotl setSelectedSegmentIndex:0];
    
    [self.view addSubview:segmentCotl];
    [segmentCotl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.userTotalCountLabel);
        make.top.equalTo(self.userTotalCountLabel.mas_bottom).offset(10.f);
        make.height.equalTo(@30);
    }];
    
    UIView *bottomContentView = [[UIView alloc] init];
    self.bottomContentView = bottomContentView;
    bottomContentView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:bottomContentView];
    [bottomContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.userTotalCountLabel);
        make.bottom.equalTo(self.view).offset(-30.f);
        make.top.equalTo(self.segmentCtrl.mas_bottom).offset(10.f);
    }];
    
    self.userCtrl = [BJUserViewController new];
    self.chatCtrl = [BJChatViewController new];
    
//    [self changeSignal];
    
    [self addChildViewController:self.room.slideshowViewController];
    [self addChildViewController:self.userCtrl];
    [self addChildViewController:self.chatCtrl];
    
    [self pptSetup];
    [self makeSegmentCtrlEvent];
    
}

- (void)pptSetup {
    
    for (UIView *v in self.bottomContentView.subviews) {
        [v removeFromSuperview];
    }
    [self.bottomContentView addSubview:self.room.slideshowViewController.view];
    
    [self.room.slideshowViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bottomContentView);
    }];
}

- (void)userViewSetup {
    for (UIView *v in self.bottomContentView.subviews) {
        [v removeFromSuperview];
    }
    [self.bottomContentView addSubview:self.userCtrl.view];
    
    [self.userCtrl.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bottomContentView);
    }];
}

- (void)chatViewSetup {
    for (UIView *v in self.bottomContentView.subviews) {
        [v removeFromSuperview];
    }
    [self.bottomContentView addSubview:self.chatCtrl.view];
    //    [self.room.slideshowViewController didMoveToParentViewController:self];
    
    [self.chatCtrl.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bottomContentView);
    }];
}


#pragma mark - event

- (void)makeSegmentCtrlEvent {
    @weakify(self);
    [[self.segmentCtrl rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(id x) {
        @strongify(self);
        NSInteger index = self.segmentCtrl.selectedSegmentIndex;
        if (0 == index) {
            [self pptSetup];
        }
        else if (1 == index){
            [self userViewSetup];
            
        }
        else if (2 == index) {
            [self chatViewSetup];
        }
    }];
}

#pragma pravite method 

- (UIButton *)buttonWithTiltle:(NSString *)title {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btn.layer.borderWidth = 0.5f;
    return btn;
}


@end
