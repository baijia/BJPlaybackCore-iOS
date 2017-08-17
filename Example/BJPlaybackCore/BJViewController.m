//
//  BJViewController.m
//  BJPlaybackCore
//
//  Created by 辛亚鹏 on 2017/1/6.
//  Copyright © 2017 Baijia Cloud. All rights reserved.
//
#import <Masonry/Masonry.h>
#import <ReactiveObjC/ReactiveObjC.h>

#import "BJViewController.h"
#import "BJEnterRoomViewController.h"
#import "BJLocalTableViewController.h"

static NSString *playBackToken = @"playBackToken";
static NSString *playBackClassId = @"playBackClassId";
static NSString *playBackIsWWW = @"playBackIsWWW";
//static NSString *playBackClassID = @"playBackClassID";

@interface BJViewController ()<UIActionSheetDelegate, UIAlertViewDelegate>

@property (nonatomic) UITextField *classIdTextField, *tokenTextField, *userInfoTextField;
//@property (strong, nonatomic) PMPlayerViewController *player;
@property (strong, nonatomic) BJPlayerManager *player;

@end

@implementation BJViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setuptokenTextField];
    [self setupClassIdTextField];
    [self setupUserInfoTextField];
    [self setupButton];    
}

- (void)setuptokenTextField {

    NSString *token = @"VH5U10BYUnYnHUgIx1LUhL1XaGz5F5g5LlfYUxrn32BkXznTgqe6Ig";
    self.tokenTextField = [self textFieldwithContent:token leftLabelText:@"token: "];
    
    [self.view addSubview:self.tokenTextField];
    [self.tokenTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(150.f);
        make.left.equalTo(self.view).offset(30.f);
        make.right.equalTo(self.view).offset(-30.f);
        make.height.equalTo(@42);
    }];
}

- (void)setupClassIdTextField {

    NSString *classId = @"17072681390265";
    self.classIdTextField = [self textFieldwithContent:classId leftLabelText:@"教室id: "];
    [self.view addSubview:self.classIdTextField];
    
    [self.classIdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tokenTextField.mas_bottom).offset(30.f);
        make.left.right.height.equalTo(self.tokenTextField);
    }];
}

- (void)setupUserInfoTextField {
    NSString *userName = @"张三";
    NSString *urlEncodeUserName =  [self BJ_urlEncodedStringWithString:userName];
    NSString *userInfoStr = [NSString stringWithFormat:@"user_number=123123&user_name=%@", urlEncodeUserName];
    self.userInfoTextField = [self textFieldwithContent:userInfoStr leftLabelText:@"userInfo: "];
    [self.view addSubview:self.userInfoTextField];
    
    [self.userInfoTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.classIdTextField.mas_bottom).offset(30.f);
        make.left.right.height.equalTo(self.tokenTextField);
    }];
}


- (void)setupButton {
    UIButton *enterButton = [UIButton new];
    [enterButton setTitle:@"在线视频" forState:UIControlStateNormal];
    [enterButton setBackgroundColor:[UIColor blueColor]];
    [enterButton addTarget:self action:@selector(enterRoom:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:enterButton];
    [enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userInfoTextField.mas_bottom).offset(30);
        make.height.equalTo(@42);
        make.width.equalTo(@100);
        make.centerX.equalTo(self.view);
    }];
    
    UIButton *localButton = [UIButton new];
    [localButton setTitle:@"本地视频" forState:UIControlStateNormal];
    [localButton setBackgroundColor:[UIColor blueColor]];
    [localButton addTarget:self action:@selector(localEnterRoom:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:localButton];
    [localButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(enterButton.mas_bottom).offset(20);
        make.height.equalTo(@42);
        make.width.equalTo(@100);
        make.centerX.equalTo(self.view);
    }];
}

#pragma mark - action

- (void)enterRoom:(UIButton *)button {
    BJEnterRoomViewController *enterRoom = [BJEnterRoomViewController
                                            enterRoomWithClassId:self.classIdTextField.text
                                            token:self.tokenTextField.text
                                            userInfo:self.userInfoTextField.text];
    [self.navigationController pushViewController:enterRoom animated:YES];
}

- (void)localEnterRoom:(UIButton *)button {

    BJLocalTableViewController *localVC = [BJLocalTableViewController new];
    [self.navigationController pushViewController:localVC animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - private

- (UITextField *)textFieldwithContent:(NSString *)content leftLabelText:(NSString *)text {
    UITextField *textField = [UITextField new];
    textField.layer.borderWidth = 1.f;
    textField.layer.borderColor = [UIColor grayColor].CGColor;
    textField.text = content;
    textField.leftViewMode = UITextFieldViewModeAlways;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 42)];
    label.text = text;
    textField.leftView = label;
    return textField;
}
     
#pragma mark - url_encodeString

- (NSString *)BJ_urlEncodedStringWithString:(NSString *)originalString
{
    __autoreleasing NSString *encodedString;
    encodedString = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                          NULL,
                                                                                          (__bridge CFStringRef)originalString,
                                                                                          NULL,
                                                                                          (CFStringRef)@":!*();@/&?#[]+$,='%’\"",
                                                                                          kCFStringEncodingUTF8
                                                                                          );
    return encodedString;
}


@end
