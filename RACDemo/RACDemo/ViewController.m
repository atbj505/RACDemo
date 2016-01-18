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

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITextField *nameField;

@property (nonatomic, strong) UITextField *passWordField;

@property (nonatomic, strong) UIButton    *loginButton;

@property (nonatomic, copy  ) NSString    *userName;

@property (nonatomic, copy  ) NSString    *password;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray     *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = @[@"Subscription", @"Map", @"Filter", @"Concatenating", @"Flattening", @"Combine&reduce", @"CustomSignal", @"AlertView", @"Notification", @"FlattenMap", @"Sequencing", @"Merging", @"Switching", @"RACSubject", @"RACReplaySubject"];
    
    [self initUI];
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
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
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
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self_weak_.loginButton.mas_bottom).offset(15);
        make.left.mas_equalTo(self_weak_.view.mas_left);
        make.right.mas_equalTo(self_weak_.view.mas_right);
        make.bottom.mas_equalTo(self_weak_.view.mas_bottom);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


static NSString * const identifier = @"cellIdentifier";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
            //Subscription
            [self subscription];
            break;
        case 1:
            //Map 数据加工
            [self map];
            break;
        case 2:
            //Filter 数据逻辑过滤
            [self filter];
            break;
        case 3:
            //Concatenating 数据合并
            [self concatenating];
            break;
        case 4:
            //Flattening
            [self flattening];
            break;
        case 5:
            //Combine&reduce
            [self combine];
            break;
        case 6:
            //CustomSignal
            [self customSignal];
            break;
        case 7:
            //AlertView
            [self alertView];
            break;
        case 8:
            //Notification
            [self notification];
            break;
        case 9:
            [self flattenMap];
            break;
        case 10:
            [self sequencing];
            break;
        case 11:
            [self merging];
            break;
        case 12:
            [self switching];
            break;
        case 13:
            [self RACSubject];
            break;
        case 14:
            [self RACReplaySubject];
            break;
        default:
            break;
    }
}

- (void)subscription {
    RACSignal *letters = [@"A B C D E F G H I" componentsSeparatedByString:@" "].rac_sequence.signal;
    [letters subscribeNext:^(NSString *x) {
        NSLog(@"subscribe %@", x);
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
    [subLetters sendNext:@"A"];
    [subNumbers sendNext:@"1"];
    [subLetters sendNext:@"B"];
    [subLetters sendNext:@"C"];
    [subNumbers sendNext:@"2"];
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

- (void)flattenMap {
    RACSequence *numbers = [@"1 2 3 4 5 6 7 8 9" componentsSeparatedByString:@" "].rac_sequence;

    RACSequence *edited = [numbers flattenMap:^(NSString *num) {
        if (num.intValue % 2 == 0) {
            return [RACSequence empty];
        } else {
            NSString *newNum = [num stringByAppendingString:@"_"];
            return [RACSequence return:newNum];
        }
    }];
    
    [[edited signal] subscribeNext:^(id x) {
        NSLog(@"flattenMap %@", x);
    }];
}


- (void)sequencing {
    RACSignal *letters = [@"A B C D E F G H I" componentsSeparatedByString:@" "].rac_sequence.signal;

    RACSignal *sequenced = [[letters
                             doNext:^(NSString *letter) {
                                 NSLog(@"%@", letter);
                             }]
                            then:^{
                                return [@"1 2 3 4 5 6 7 8 9" componentsSeparatedByString:@" "].rac_sequence.signal;
                            }];
    
    [sequenced subscribeNext:^(id x) {
        NSLog(@"Sequencing %@", x);
    }];
}

- (void)merging {
    RACSubject *letters = [RACSubject subject];
    RACSubject *numbers = [RACSubject subject];
    RACSignal *merged = [RACSignal merge:@[ letters, numbers ]];
    
    [merged subscribeNext:^(NSString *x) {
        NSLog(@"%@", x);
    }];
    
    [letters sendNext:@"A"];
    [numbers sendNext:@"1"];
    [letters sendNext:@"B"];
    [letters sendNext:@"C"];
    [numbers sendNext:@"2"];
}

- (void)switching {
    RACSubject *letters = [RACSubject subject];
    RACSubject *numbers = [RACSubject subject];
    RACSubject *signalOfSignals = [RACSubject subject];
    
    RACSignal *switched = [signalOfSignals switchToLatest];
    
    [switched subscribeNext:^(NSString *x) {
        NSLog(@"%@", x);
    }];
    
    [signalOfSignals sendNext:letters];
    [letters sendNext:@"A"];
    [letters sendNext:@"B"];
    
    [signalOfSignals sendNext:numbers];
    [letters sendNext:@"C"];
    [numbers sendNext:@"1"];
    
    [signalOfSignals sendNext:letters];
    [numbers sendNext:@"2"];
    [letters sendNext:@"D"];
}

- (void)RACSubject {
    RACSubject *subject = [RACSubject subject];
    
    [subject subscribeNext:^(id x) {
        NSLog(@"第一个订阅者%@",x);
    }];
    [subject subscribeNext:^(id x) {
        NSLog(@"第二个订阅者%@",x);
    }];
    
    [subject sendNext:@"1"];
}

- (void)RACReplaySubject {
    RACReplaySubject *replaySubject = [RACReplaySubject subject];
    
    [replaySubject sendNext:@1];
    [replaySubject sendNext:@2];
    
    [replaySubject subscribeNext:^(id x) {
        
        NSLog(@"第一个订阅者接收到的数据%@",x);
    }];
    
    [replaySubject subscribeNext:^(id x) {
        
        NSLog(@"第二个订阅者接收到的数据%@",x);
    }];
}

- (void)login {
    NSLog(@"login");
}

@end
