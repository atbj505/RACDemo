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
    
    [self initUI];
    
    //Subscription
    [self subscription];
    
    //Map
    [self map];
    
    //Filter
    [self filter];
    
    //Concatenating
    [self concatenating];
    
    //flattening
    [self flattening];
    
    //Combine&reduce
    [self combine];
    
    //CustomSignal
    [self customSignal];
    
    //AlertView
    [self alertView];
    
    //Notification
    [self notification];
}

- (void)initUI {
    @weakify(self);
    self.nameField = [[UITextField alloc] init];
    self.nameField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:self.nameField];
    self.passWordField = [[UITextField alloc] init];
    self.passWordField.borderStyle = UITextBorderStyleRoundedRect;
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
}

- (void)subscription {
    RACSignal *letters = [@"A B C D E F G H I" componentsSeparatedByString:@" "].rac_sequence.signal;
    [letters subscribeNext:^(NSString *x) {
        NSLog(@"%@", x);
    }];
}

- (void)map {
    RACSequence *letters = [@"A B C D E F G H I" componentsSeparatedByString:@" "].rac_sequence;
    
    RACSequence *mapped = [letters map:^(NSString *value) {
        return [value stringByAppendingString:value];
    }];
    
    [[mapped signal] subscribeNext:^(id x) {
        NSLog(@"map %@", x);
    }];
}

- (void)filter {
    RACSequence *numbers = [@"1 2 3 4 5 6 7 8 9" componentsSeparatedByString:@" "].rac_sequence;
    
    RACSequence *filter = [numbers filter:^BOOL(NSString *value) {
        return value.intValue % 2 == 0;
    }];
    
    [[filter signal] subscribeNext:^(id x) {
        NSLog(@"filter %@", x);
    }];
}

- (void)concatenating {
    RACSequence *letters = [@"A B C D E F G H I" componentsSeparatedByString:@" "].rac_sequence;
    
    RACSequence *numbers = [@"1 2 3 4 5 6 7 8 9" componentsSeparatedByString:@" "].rac_sequence;
    
    RACSequence *concatenated = [letters concat:numbers];
    
    [[concatenated signal] subscribeNext:^(id x) {
        NSLog(@"concatenated %@", x);
    }];
}

- (void)flattening {
    RACSequence *letters = [@"A B C D E F G H I" componentsSeparatedByString:@" "].rac_sequence;
    RACSequence *numbers = [@"1 2 3 4 5 6 7 8 9" componentsSeparatedByString:@" "].rac_sequence;
    RACSequence *sequenceOfSequences = @[ letters, numbers ].rac_sequence;
    
    RACSequence *flattened = [sequenceOfSequences flatten];
    
    [[flattened signal] subscribeNext:^(id x) {
        NSLog(@"flattened %@", x);
    }];
    
    RACSubject *subLetters = [RACSubject subject];
    RACSubject *subNumbers = [RACSubject subject];
    RACSignal *signalOfSignals = [RACSignal createSignal:^ RACDisposable * (id<RACSubscriber> subscriber) {
        [subscriber sendNext:subLetters];
        [subscriber sendNext:subNumbers];
        [subscriber sendCompleted];
        return nil;
    }];
    
    RACSignal *subFlattened = [signalOfSignals flatten];
    
    [subFlattened subscribeNext:^(NSString *x) {
        NSLog(@"subFlattened %@", x);
    }];
}

- (void)combine {
    RAC(self.loginButton, enabled) = [RACSignal
                                      combineLatest:@[self.nameField.rac_textSignal,
                                                      self.passWordField.rac_textSignal]
                                      reduce:^(NSString *userName, NSString *passWord){
                                          return @(userName.length > 0 && passWord.length);
                                      }];
}

- (void)customSignal {
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"signal FIRE!!");
        [subscriber sendNext:@"signal NEXT!!"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    [signal subscribeNext:^(id x) {
        NSLog(@"subscrbe next");
    }];
    
    [signal subscribeCompleted:^{
        NSLog(@"subscribe complete");
    }];
    
    [signal replay];
}

- (void)alertView {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"alert" message:@"alert" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:@"ok", nil];
    
    [[alertView rac_buttonClickedSignal] subscribeNext:^(NSNumber *buttonIndex) {
        NSLog(@"%d",buttonIndex.integerValue);
    }];
    
    [alertView show];
}

- (void)notification {
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"notification" object:nil] subscribeNext:^(NSNotification *notification) {
        NSLog(@"notification receive");
    }];
}

- (void)login {
    NSLog(@"login");
}

@end
