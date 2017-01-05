//
//  BJViewController.m
//  BJPlaybackCore
//
//  Created by 辛亚鹏 on 01/04/2017.
//  Copyright (c) 2017 辛亚鹏. All rights reserved.
//

#import "BJEnterRoomViewController.h"
#import <BJPlaybackCore/BJPlaybackCore.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Masonry/Masonry.h>

@interface BJEnterRoomViewController ()

@property (nonatomic) BJPRoom *room;
@property (nonatomic) UIButton *playButton;
@property (nonatomic) UIView *topContentView, *bottomContentView, *pptView, *definitionView;
@property (nonatomic) UISlider *slider;
@property (nonatomic) UILabel *timeLabel;
@property (nonatomic) UISegmentedControl *rateSegmentCtrl, *viewSegmentCtrl;
@property (nonatomic) UIButton *lowButton, *hightButton, *superHDButton;
@property (nonatomic) NSString *classId;

@end

@implementation BJEnterRoomViewController

+ (instancetype)enterRoomWithClassId:(NSString *)classId {
    BJEnterRoomViewController *enterRoomCtrl = [BJEnterRoomViewController new];
    enterRoomCtrl.classId = classId;
    return enterRoomCtrl;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self enterRoom];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"退出" style:UIBarButtonItemStylePlain target:self action:@selector(exitRoom)];
}

- (void)enterRoom {
    self.room = [BJPRoom roomWithClassId:self.classId deployType:BJLDeployType_test];
    [self.room enter];
    [self makeLoadingEvents];
    self.room.playbackView.frame = CGRectMake(20, 70, 320, 240);
}

- (void)exitRoom {
    [self.room exit];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)makeLoadingEvents {
    @weakify(self);
    [self bjl_KVObserve:self.room
                 getter:@selector(loadingVM)
                 filter:^BOOL(id old, id now) {
                     // strongdef(self);
                     return !!now;
                 }
             usingBlock:^BOOL(id old, id now) {
                 @strongify(self);
                 self.room.loadingVM.suspendBlock = ^(BJPLoadingStep step,
                                                      BJPLoadingSuspendReason reason,
                                                      BJLError *error,
                                                      BOOL ignorable,
                                                      BJPLoadingSuspendCallback suspendCallback) {
                     @strongify(self);
                     
                     if (reason == BJPLoadingSuspendReason_stepOver) {
                         suspendCallback(YES);
                         return;
                     }
                     
                     NSString *message = nil;
                     if (reason == BJPLoadingSuspendReason_askForWWANNetwork) {
                         message = @"WWAN 网络";
                     }
                     else if (reason == BJPLoadingSuspendReason_errorOccurred) {
                         message = error ? [NSString stringWithFormat:@"%@ - %@",
                                            error.localizedDescription,
                                            error.localizedFailureReason] : @"错误";
                     }
                     if (message) {
                         UIAlertController *alert = [UIAlertController
                                                     alertControllerWithTitle:ignorable ? @"提示" : @"错误"
                                                     message:message
                                                     preferredStyle:UIAlertControllerStyleAlert];
                         [alert addAction:[UIAlertAction
                                           actionWithTitle:ignorable ? @"继续" : @"重试"
                                           style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction * _Nonnull action) {
                                               suspendCallback(YES);
                                           }]];
                         [alert addAction:[UIAlertAction
                                           actionWithTitle:@"取消"
                                           style:UIAlertActionStyleCancel
                                           handler:^(UIAlertAction * _Nonnull action) {
                                               suspendCallback(NO);
                                           }]];
                         [self presentViewController:alert animated:YES completion:nil];
                     }
                 };
                 
                 [self bjl_observe:self.room.loadingVM
                             event:@selector(loadingDidUpdateProgress:)
                        usingBlock:^(NSNumber *progress /*, id object, BJLOEventType event */) {
                            NSLog(@"loading progress: %f", progress.doubleValue);
                        }];
                 
                 [self bjl_observe:self.room.loadingVM
                             event:@selector(loadingDidSuccess)
                        usingBlock:^(id data /*, id object, BJLOEventType event */) {
                            @strongify(self);
                            NSLog(@"loading success");
                            [self setupPlayerAndView];
                            [self pptSetup];
                        }];
                 
                 [self bjl_observe:self.room.loadingVM
                             event:@selector(loadingDidFailureWithError:)
                        usingBlock:^(BJLError *error /*, id object, BJLOEventType event */) {
                            NSLog(@"loading failure");
                        }];
                 return BJLKVO_GOON;
             }];
}

- (void)setupPlayerAndView {
    
    UIView *topContentView = [[UIView alloc] initWithFrame:CGRectMake(20, 70, 320, 240)];
    topContentView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:topContentView];
    self.topContentView = topContentView;
    
    
    [topContentView addSubview:self.room.playbackView];
    [self.room.playbackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(topContentView);
    }];
    
    [self makePlaySubview];
    
    
    UIView *bottomContentView = [[UIView alloc] initWithFrame:CGRectMake(20, 330, 320, 250)];
    self.bottomContentView = bottomContentView;
    [self.view addSubview:bottomContentView];
    
}

- (void)pptSetup {
    
    [self addChildViewController:self.room.slideshowViewController];
    [self.bottomContentView addSubview:self.room.slideshowViewController.view];
    [self.room.slideshowViewController didMoveToParentViewController:self];
    self.pptView = self.room.slideshowViewController.view;
    
    [self.room.slideshowViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.bottomContentView);
//        make.width.equalTo(self.bottomContentView).multipliedBy(0.5);
        make.width.equalTo(self.bottomContentView);
    }];
}

//设置player的进度条, 暂停, 切换清晰度
- (void)makePlaySubview {
    
    //play
    UIButton *playButton = [UIButton new];
    self.playButton = playButton;
    [playButton setImage:[UIImage imageNamed:@"ic-play"] forState:UIControlStateNormal];
    [playButton setImage:[UIImage imageNamed:@"ic-pause"] forState:UIControlStateSelected];
    [self.topContentView addSubview:playButton];
    [playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topContentView).offset(10);
        make.bottom.equalTo(self.topContentView).offset(-10);
    }];
    
    //timeLabel
    UILabel *label = [UILabel new];
    [label setTextColor:[UIColor whiteColor]];
    [label setFont:[UIFont systemFontOfSize:14]];
    label.text = @"-- / --";
    self.timeLabel = label;
    [self.topContentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(playButton);
        make.bottom.equalTo(playButton.mas_top).offset(-5);
        make.width.equalTo(@80);
        make.height.equalTo(@30);
    }];
    
    //slider
    UISlider *slider = [[UISlider alloc] init];
    self.slider = slider;
    [self.topContentView addSubview:slider];
    [slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(playButton.mas_right).offset(20);
        make.centerY.equalTo(playButton);
        make.right.equalTo(self.topContentView).offset(-20);
    }];
    
    //rate
    UISegmentedControl *rateSegmentCtrl = [[UISegmentedControl alloc] initWithItems:@[@"1.0倍速", @"1.2倍速", @"1.5倍速"]];
    self.rateSegmentCtrl = rateSegmentCtrl;
    rateSegmentCtrl.hidden = YES;
    rateSegmentCtrl.selectedSegmentIndex = 0;
    [rateSegmentCtrl setTintColor:[UIColor darkGrayColor]];
    [rateSegmentCtrl setTitleTextAttributes:@{NSForegroundColorAttributeName :[UIColor blackColor]} forState:UIControlStateNormal];
    [rateSegmentCtrl setTitleTextAttributes:@{NSForegroundColorAttributeName :[UIColor whiteColor]} forState:UIControlStateSelected];
    [rateSegmentCtrl setBackgroundColor:[UIColor whiteColor]];
    [self.topContentView addSubview:rateSegmentCtrl];
    
    [rateSegmentCtrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topContentView).offset(20);
        make.centerX.equalTo(self.topContentView);
        make.height.equalTo(@20);
        make.width.equalTo(@200);
    }];
    
    //definition
    [self setDefinitionView];
    
    [self makeEvents];
}

- (void)setDefinitionView {
    UIView *definitionView = [UIView new];
    self.definitionView = definitionView;
    definitionView.hidden = YES;
    [self.topContentView addSubview:definitionView];
    [definitionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.right.equalTo(self.topContentView);
        make.height.equalTo(@90);
        make.width.equalTo(@40);
    }];
    
    UIButton *lowButton = [UIButton new];
    [lowButton setTitle:@"标清" forState:UIControlStateNormal];
    [lowButton.titleLabel setFont:[UIFont systemFontOfSize:12.f]];
    UIButton *highButton = [UIButton new];
    [highButton setTitle:@"高清" forState:UIControlStateNormal];
    [highButton.titleLabel setFont:[UIFont systemFontOfSize:12.f]];
    UIButton *superHDButton = [UIButton new];
    [superHDButton setTitle:@"超清" forState:UIControlStateNormal];
    [superHDButton.titleLabel setFont:[UIFont systemFontOfSize:12.f]];
    self.lowButton = lowButton;
    self.hightButton = highButton;
    self.superHDButton = superHDButton;
    [definitionView addSubview:lowButton];
    [definitionView addSubview:highButton];
    [definitionView addSubview:superHDButton];
    if (!self.room.lowUrlStr) {
        lowButton.hidden = YES;
    }
    if (!self.room.highUrlStr) {
        highButton.hidden = YES;
    }
    if (!self.room.superHDUrlStr) {
        superHDButton.hidden = YES;
    }
    [lowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(definitionView);
        make.height.equalTo(@30);
    }];
    [highButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.centerY.equalTo(definitionView);
        make.height.equalTo(@30);
    }];
    [superHDButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(definitionView);
        make.height.equalTo(@30);
    }];
    
}

- (void)makeEvents {
    @weakify(self);
    [[self.playButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        self.playButton.selected = !self.playButton.selected;
        if (self.playButton.selected) {
            [self.room.playbackVM playerPlay];
            if (self.room.playbackVM.currentTime <= 0) {
                [self.slider setValue:0];
            }
            if (self.rateSegmentCtrl.hidden || self.definitionView.hidden) {
                self.rateSegmentCtrl.hidden = NO;
                self.definitionView.hidden = NO;
            }
        }
        else {
            [self.room.playbackVM playerPause];
            self.rateSegmentCtrl.hidden = YES;
            self.definitionView.hidden = YES;
        }
    }];
    
    [[self.slider rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(id x) {
        @strongify(self);
        CGFloat value = self.slider.value;
        NSTimeInterval duration = self.room.playbackVM.playerControl.duration;
        NSTimeInterval time = duration * value;
        [self.room.playbackVM playerSeekToTime:time];
        self.timeLabel.text = [NSString stringWithFormat:@"%.0f / %.0f",self.room.playbackVM.currentTime,
                               self.room.playbackVM.playerControl.duration];
        
        NSLog(@"currtime = %f", self.room.playbackVM.currentTime);
    }];
    
    [[self.rateSegmentCtrl rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UISegmentedControl *seg) {
        @strongify(self);
        NSInteger index = seg.selectedSegmentIndex;
        if (self.room.playbackVM.playbackState == PKMoviePlaybackStatePlaying) {
            switch (index) {
                    case 0:
                    [self.room.playbackVM setRateSpeed:1.0];
                    break;
                    
                    case 1:
                    [self.room.playbackVM setRateSpeed:1.2];
                    break;
                    
                    case 2:
                    [self.room.playbackVM setRateSpeed:1.5];
                    break;
                    
                default:
                    break;
            }
        }
    }];
    
    [[self.lowButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.room.playbackVM setContentURL:self.room.lowUrlStr adUrlList:nil];
    }];
    
    [[self.hightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.room.playbackVM setContentURL:self.room.highUrlStr adUrlList:nil];
    }];
    
    [[self.superHDButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.room.playbackVM setContentURL:self.room.superHDUrlStr adUrlList:nil];
    }];
}

@end

