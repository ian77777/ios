//
//  AAFeedbackViewController.m
//  Alipay About
//
//  Created by yukai44444 on 13-11-9.
//  Copyright (c) 2013年 yukai44444. All rights reserved.
//

#import "AAFeedbackViewController.h"

@interface AAFeedbackViewController ()

@end

@implementation AAFeedbackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.textField = [[UITextField alloc]
                      initWithFrame:
                      CGRectMake(10, 30,300, 30)];
    self.textField.delegate = self;
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 80, 300, 30)];
    [self.view addSubview:self.textField];
    [self.view addSubview:self.textView];
    
    // 初始化一个圆角样式的默认按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    // 设置按钮的位置与大小
    button.frame = CGRectMake(110.0f, 200.0f, 100.0f, 30.0f);
    
    // 设置目标，行为与控件事件。
    // 更多说明看后文
    [button addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    // 设置标题
    [button setTitle:@"提交" forState:UIControlStateNormal];
    
    // 将按钮添加到主视图
    [self.view addSubview:button];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // 告诉操作系统移除前置的软键盘
    [textField resignFirstResponder];
    //returns NO. 加入一个换行字符
    //文本框忽略
    return NO;
}

- (void)buttonPressed
{
    NSString *character = self.textField.text;
    NSString *textarea = self.textView.text;
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"点击事件"
                          message:[NSString stringWithFormat:@"第一个：%@，第二个：%@", character, textarea]
                          delegate:nil
                          cancelButtonTitle:@"真好"
                          otherButtonTitles:nil];
    [alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
