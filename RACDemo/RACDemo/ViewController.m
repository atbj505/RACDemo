//
//  ViewController.m
//  RACDemo
//
//  Created by Robert on 16/1/16.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import "ViewController.h"
#import "ReactiveCocoa.h"
#import "Masonry.h"

@interface ViewController ()

@property (nonatomic, strong) UITextField *nameField;

@property (nonatomic, strong) UITextField *passWordField;

@property (nonatomic, strong) UIButton    *loginButton;

@property (nonatomic, copy  ) NSString    *userName;

@property (nonatomic, copy  ) NSString    *password;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    @weakify(self);
    self.nameField = [[UITextField alloc] init];
    self.nameField.borderStyle = UITextBorderStyleLine;
    [self.view addSubview:self.nameField];
    self.passWordField = [[UITextField alloc] init];
    self.passWordField.borderStyle = UITextBorderStyleLine;
    [self.view addSubview:self.passWordField];
    self.loginButton = [[UIButton alloc] init];
    self.loginButton.backgroundColor = [UIColor redColor];
    [self.loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginButton];
    
    [self.nameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self_weak_.view).offset(30);
        make.width.mas_equalTo(@(100));
        make.centerX.mas_equalTo(self_weak_.view.mas_centerX);
    }];
    
    [self.passWordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self_weak_.nameField.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self_weak_.view.mas_centerX);
        make.width.mas_equalTo(@(100));
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self_weak_.passWordField.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self_weak_.view.mas_centerX);
        make.width.and.height.mas_equalTo(@(20));
    }];
    
    [RACObserve(self, userName) subscribeNext: ^(NSString *newName){
        NSLog(@"newName:%@", newName);
    }];
    
    RAC(self.loginButton, enabled) = [RACSignal
                                      combineLatest:@[self.nameField.rac_textSignal,
                                                      self.passWordField.rac_textSignal]
                                      reduce:^(NSString *userName, NSString *passWord){
        return @(userName.length > 0 && passWord.length);
    }];
}

- (void)login {
    self.userName = self.nameField.text;
    NSLog(@"login");
}

@end
