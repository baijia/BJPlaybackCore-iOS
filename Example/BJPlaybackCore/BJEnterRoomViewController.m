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
@property (nonatomic) UIView *bottomContentView, *pptView, *definitionView;
@property (nonatomic) NSString *classId;
@property (nonatomic) BJPPlaybackVM *playbackVM;

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
    self.room = [BJPRoom createRoomWithClassId:_classId partnerId:nil];
    
    CGFloat width = ScreenWidth < ScreenHeight ? ScreenWidth : ScreenHeight;
    CGRect frame = CGRectMake(0, 64, width, width*9/16);
    [self.room enterWithPlaybackViewFrame:frame];
    
    [self pptSetup];
    [self setupPlayer];
}

- (void)exitRoom {
    [self.room exit];
    self.playbackVM = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupPlayer {
    [self.view addSubview:self.room.playbackVM.playView];
    
    [self addChildViewController:self.room.playbackVM.playerControl];
}

- (void)pptSetup {
    UIView *bottomContentView = [[UIView alloc] initWithFrame:CGRectMake(20, 330, 320, 250)];
    self.bottomContentView = bottomContentView;
    [self.view addSubview:bottomContentView];
    
    [self addChildViewController:self.room.slideshowViewController];
    [self.bottomContentView addSubview:self.room.slideshowViewController.view];
    [self.room.slideshowViewController didMoveToParentViewController:self];
    self.pptView = self.room.slideshowViewController.view;
    
    [self.room.slideshowViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.bottomContentView);
        make.width.equalTo(self.bottomContentView);
    }];
}

@end

