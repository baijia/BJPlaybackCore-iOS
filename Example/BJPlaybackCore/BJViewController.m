//
//  BJViewController.m
//  BJPlaybackCore
//
//  Created by 辛亚鹏 on 2017/1/6.
//  Copyright © 2017年 Baijia Cloud. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>
#import <BJPlaybackCore/BJPlaybackCore.h>
#import <Masonry/Masonry.h>

#import "BJViewController.h"
#import "BJEnterRoomViewController.h"
#import "BJLocalTableViewController.h"

static NSString *playBackToken = @"playBackToken";
static NSString *playBackClassId = @"playBackClassId";
static NSString *playBackIsWWW = @"playBackIsWWW";
//static NSString *playBackClassID = @"playBackClassID";

@interface BJViewController ()<UIActionSheetDelegate, UIAlertViewDelegate>

@property (nonatomic) UITextField *classIdTextField, *tokenTextField, *sessionTextField,
*userInfoTextField, *userNumaberTextField;


@end

@implementation BJViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}

- (void)setupViews
{
    [self setupClassIdTextField];
    [self setupSessionTextField];
    [self setuptokenTextField];
    [self setupUserInfoTextField];
    [self setupUserNumberTextField];
    [self setupButton];
}

- (void)setupClassIdTextField {
    
    NSString *classID = @"17081868624899";
    NSString *classId = [[NSUserDefaults standardUserDefaults] objectForKey:playBackClassId] ?: classID;
    self.classIdTextField = [self textFieldwithContent:classId leftLabelText:@"教室id: "];
    [self.view addSubview:self.classIdTextField];
    
    [self.classIdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(90.f);
        make.left.equalTo(self.view).offset(30.f);
        make.right.equalTo(self.view).offset(-30.f);
        make.height.equalTo(@35);
    }];
}

- (void)setupSessionTextField
{
    NSString *sessionString = @"201708180";
    self.sessionTextField = [self textFieldwithContent:sessionString leftLabelText:@"sessionId:"];
    [self.view addSubview:self.sessionTextField];
    [self.sessionTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.classIdTextField.mas_bottom).offset(20.f);
        make.left.right.height.equalTo(self.classIdTextField);
    }];
}

- (void)setuptokenTextField {
    NSString *token = @"r4cxxpCxPs6Ncup-z1nfawQswJsIPG12qN8nX3QetJOeaIKjsqIAMw";
    self.tokenTextField = [self textFieldwithContent:token leftLabelText:@"token: "];
    [self.view addSubview:self.tokenTextField];
    [self.tokenTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sessionTextField.mas_bottom).offset(20.f);
        make.left.right.height.equalTo(self.classIdTextField);
    }];
}

- (void)setupUserInfoTextField {
    NSString *userName = @"张三";
    self.userInfoTextField = [self textFieldwithContent:userName leftLabelText:@"name: "];
    [self.view addSubview:self.userInfoTextField];
    
    [self.userInfoTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tokenTextField.mas_bottom).offset(20.f);
        make.left.right.height.equalTo(self.classIdTextField);
    }];
}

- (void)setupUserNumberTextField
{
    NSString *userNo = @"123456";
    self.userNumaberTextField = [self textFieldwithContent:userNo leftLabelText:@"userId: "];
    [self.view addSubview:self.userNumaberTextField];
    [self.userNumaberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userInfoTextField.mas_bottom).offset(20.f);
        make.left.right.height.equalTo(self.classIdTextField);
    }];
}


- (void)setupButton {
    UIButton *enterButton = [UIButton new];
    [enterButton setTitle:@"在线视频" forState:UIControlStateNormal];
    [enterButton setBackgroundColor:[UIColor blueColor]];
    [enterButton addTarget:self action:@selector(enterRoom:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:enterButton];
    [enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userNumaberTextField.mas_bottom).offset(30);
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
    NSString *urlEncodeUserName =  [self BJ_urlEncodedStringWithString:self.userInfoTextField.text];
    NSString *userInfoStr = [NSString stringWithFormat:@"user_number=%@&user_name=%@", self.userNumaberTextField.text, urlEncodeUserName];
    BJEnterRoomViewController *enterRoom = [BJEnterRoomViewController
                                            enterRoomWithClassId:self.classIdTextField.text
                                            sessionId:self.sessionTextField.text
                                            token:self.tokenTextField.text
                                            userInfo:userInfoStr];
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
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, 42)];
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
