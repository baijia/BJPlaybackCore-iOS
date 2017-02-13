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

@property (nonatomic) UITextField *classIdTextField, *partnerIdTextField, *userInfoTextField;
@property (strong, nonatomic) PMPlayerViewController *player;

@end

@implementation BJViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupPartnerIdTextField];
    [self setupClassIdTextField];
    [self setupUserInfoTextField];
    [self setupButton];    
}

- (void)setupPartnerIdTextField {
    
    self.partnerIdTextField = [self textFieldwithContent:@"32958737" leftLabelText:@"合作Id: "];
    [self.view addSubview:self.partnerIdTextField];
    [self.partnerIdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(150.f);
        make.left.equalTo(self.view).offset(30.f);
        make.right.equalTo(self.view).offset(-30.f);
        make.height.equalTo(@42);
        
    }];
}

- (void)setupClassIdTextField {

//    self.classIdTextField.text = @"17010691963824";
    //    self.classIdTextField.text = @"16122291873953";
    //    self.classIdTextField.text = @"17010591900320";
    
    self.classIdTextField = [self textFieldwithContent:@"17010691963824" leftLabelText:@"教室id: "];
    [self.view addSubview:self.classIdTextField];
    
    [self.classIdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.partnerIdTextField.mas_bottom).offset(30.f);
        make.left.right.height.equalTo(self.partnerIdTextField);
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
        make.left.right.height.equalTo(self.partnerIdTextField);
    }];
}


- (void)setupButton {
    UIButton *enterButton = [UIButton new];
    [enterButton setTitle:@"进入教室" forState:UIControlStateNormal];
    [enterButton setBackgroundColor:[UIColor blueColor]];
    [enterButton addTarget:self action:@selector(enterRoom:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:enterButton];
    [enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userInfoTextField.mas_bottom).offset(30);
        make.height.equalTo(@42);
        make.width.equalTo(@100);
        make.centerX.equalTo(self.view);
    }];
}

#pragma mark - action

- (void)enterRoom:(UIButton *)button {
    BJEnterRoomViewController *enterRoom = [BJEnterRoomViewController
                                            enterRoomWithClassId:self.classIdTextField.text
                                            partnerId:self.partnerIdTextField.text
                                            userInfo:self.userInfoTextField.text];
    [self.navigationController pushViewController:enterRoom animated:YES
     ];
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
