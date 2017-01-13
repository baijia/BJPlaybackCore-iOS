//
//  BJViewController.m
//  BJPlaybackCore
//
//  Created by 辛亚鹏 on 2017/1/6.
//  Copyright © 2017年 辛亚鹏. All rights reserved.
//
#import <Masonry/Masonry.h>
#import "BJViewController.h"
#import "BJEnterRoomViewController.h"

@interface BJViewController ()

@property (nonatomic) UITextField *classIdTextField, *partnerIdTextField;
@property (strong, nonatomic) PMPlayerViewController *player;

@end

@implementation BJViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupClassIdTextField];
    [self setupPartnerIdTextField];
    [self setupButton];
}

- (void)setupPartnerIdTextField {
    
    self.partnerIdTextField = [UITextField new];
    self.partnerIdTextField.layer.borderWidth = 1.f;
    self.partnerIdTextField.layer.borderColor = [UIColor grayColor].CGColor;
    self.partnerIdTextField.text = @"32958737";
    self.partnerIdTextField.leftViewMode = UITextFieldViewModeAlways;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 42)];
    label.text = @"合作Id: ";
    self.partnerIdTextField.leftView = label;
    
    [self.view addSubview:self.partnerIdTextField];
    [self.partnerIdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.classIdTextField.mas_top).offset(-50);
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).offset(30.f);
        make.right.equalTo(self.view).offset(-30.f);
        make.height.equalTo(@42);
    }];
}

- (void)setupClassIdTextField {
    self.classIdTextField = [UITextField new];
    self.classIdTextField.layer.borderWidth = 1.f;
    self.classIdTextField.layer.borderColor = [UIColor grayColor].CGColor;
    self.classIdTextField.text = @"17010691963824";
//    self.classIdTextField.text = @"16122291873953";
    self.classIdTextField.leftViewMode = UITextFieldViewModeAlways;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 42)];
    label.text = @"教室id: ";
    self.classIdTextField.leftView = label;

    [self.view addSubview:self.classIdTextField];
    [self.classIdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(self.view);
        make.left.equalTo(self.view).offset(30.f);
        make.right.equalTo(self.view).offset(-30.f);
        make.height.equalTo(@42);
    }];
}

- (void)setupButton {
    UIButton *enterButton = [UIButton new];
    [enterButton setTitle:@"进入教室" forState:UIControlStateNormal];
    [enterButton setBackgroundColor:[UIColor blueColor]];
    [enterButton addTarget:self action:@selector(enterRoom:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:enterButton];
    [enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.classIdTextField.mas_bottom).offset(30);
        make.height.equalTo(@42);
        make.width.equalTo(@100);
        make.centerX.equalTo(self.view);
    }];
}

- (void)enterRoom:(UIButton *)button {
    BJEnterRoomViewController *enterRoom = [BJEnterRoomViewController
                                            enterRoomWithClassId:self.classIdTextField.text partnerId:self.partnerIdTextField.text];
    [self.navigationController pushViewController:enterRoom animated:YES];
}

@end
