//
//  BJViewController.m
//  BJPlaybackCore
//
//  Created by 辛亚鹏 on 01/04/2017.
//  Copyright (c) 2017 辛亚鹏. All rights reserved.
//

#import "BJEnterRoomViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <BJLiveCore/BJLiveCore.h>
#import <BJLiveCore/NSObject+BJLObserving.h>
#import <Masonry/Masonry.h>

#import "BJUserViewController.h"
#import "BJChatViewController.h"

@interface BJEnterRoomViewController ()

@property (nonatomic) UIView *bottomContentView;
@property (nonatomic) NSString *classId, *partnerId;
@property (nonatomic) UILabel *userTotalCountLabel;
@property (nonatomic) UISegmentedControl *segmentCtrl;
@property (nonatomic) BJUserViewController *userCtrl;
@property (nonatomic) BJChatViewController *chatCtrl;

@end

@implementation BJEnterRoomViewController

+ (instancetype)enterRoomWithClassId:(NSString *)classId partnerId:(NSString *)partnerId {
    BJEnterRoomViewController *enterRoomCtrl = [BJEnterRoomViewController new];
    enterRoomCtrl.classId = classId;
    enterRoomCtrl.partnerId = partnerId;
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
    self.room = [BJPRoom createRoomWithClassId:_classId partnerId:_partnerId];
    
    CGFloat width = ScreenWidth < ScreenHeight ? ScreenWidth : ScreenHeight;
    CGRect frame = CGRectMake(0, 64, width, width*9/16);
    [self.room enterWithPlaybackViewFrame:frame];
    
    [self setupPlayer];
    [self userTotalCountLabelSetup];
    [self bottomViewSetup];
    [self changeSignal];
}

- (void)exitRoom {
    [self.room exit];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - setupView

- (void)setupPlayer {
    [self.view addSubview:self.room.playbackVM.playView];
    
    [self addChildViewController:self.room.playbackVM.playerControl];
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
    
    [self changeSignal];
    
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

#pragma mark - signal

- (void)changeSignal {
    @weakify(self);
    [self bjl_observe:BJLMakeMethod(self.room.chatVM, didReceiveMessage:)
             observer:^BOOL(NSArray<NSObject<BJLMessage> *> *messageArray){
                 @strongify(self);
                 self.chatCtrl.chatList = messageArray;
                 [self.chatCtrl.tableView reloadData];
                 return YES;
             }];
    
    [self bjl_observe:BJLMakeMethod(self.room.onlineUsersVM, onlineUserCount:)
             observer:^BOOL(NSNumber *count){
                 @strongify(self);
                 self.userTotalCountLabel.text = [NSString stringWithFormat:@"    totalUserCount: %@", count];
                 return YES;
             }];
    
    [self bjl_observe:BJLMakeMethod(self.room.onlineUsersVM, onlineUserList:)
             observer:^BOOL(NSArray <NSObject<BJLOnlineUser> *> *userList){
                 @strongify(self);
                 self.userCtrl.userList = userList;
                 [self.userCtrl.tableView reloadData];
                 return YES;
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

@end

