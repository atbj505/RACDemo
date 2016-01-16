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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    @weakify(self);
    self.nameField = [[UITextField alloc] init];
    self.nameField.borderStyle = UITextBorderStyleBezel;
    [self.view addSubview:self.nameField];
    self.passWordField = [[UITextField alloc] init];
    self.passWordField.borderStyle = UITextBorderStyleBezel;
    [self.view addSubview:self.passWordField];
    self.loginButton = [[UIButton alloc] init];
    self.loginButton.backgroundColor = [UIColor redColor];
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
}

@end
