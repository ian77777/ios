//
//  YBYTRootViewController.m
//  Test
//
//  Created by yukai44444 on 14-7-8.
//  Copyright (c) 2014年 Bingye Yu. All rights reserved.
//

#import "YBYTRootViewController.h"
#import "YBYTSecondViewController.h"

@interface YBYTRootViewController ()

@end

@implementation YBYTRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

void exampleA() {
    char a = 'A';
    ^{
        printf("%c\n", a);
    }();
}
void exampleB_addBlockToArray(NSMutableArray *array) {
    char b = 'B';
    [array addObject:^{
        printf("%c\n", b);
    }];
}

void exampleB() {
    NSMutableArray *array = [NSMutableArray array];
    exampleB_addBlockToArray(array);
    void (^block)() = [array objectAtIndex:0];
    block();
}
void exampleC_addBlockToArray(NSMutableArray *array) {
    [array addObject:^{
        printf("C\n");
    }];
}

void exampleC() {
    NSMutableArray *array = [NSMutableArray array];
    exampleC_addBlockToArray(array);
    void (^block)() = [array objectAtIndex:0];
    block();
}

typedef void (^dBlock)();

dBlock exampleD_getBlock() {
    char d = 'D';
    return ^{
        printf("%c\n", d);
    };
}

void exampleD() {
    exampleD_getBlock()();
}

typedef void (^eBlock)();

eBlock exampleE_getBlock() {
    char e = 'E';
    void (^block)() = ^{
        printf("%c\n", e);
    };
    return block;
}

void exampleE() {
    eBlock block = exampleE_getBlock();
    block();
}

- (id) getBlockArray
{
    int val = 10;
    return [[NSArray alloc] initWithObjects:
            ^{ NSLog(@"  > block 0:%d", val); },    // block on the stack
            ^{ NSLog(@"  > block 1:%d", val); },    // block on the stack
            nil];
    
    //    return [[NSArray alloc] initWithObjects:
    //            [^{ KSLog(@"  > block 0:%d", val); } copy],    // block copy to heap
    //            [^{ KSLog(@"  > block 1:%d", val); } copy],    // block copy to heap
    //            nil];
}

- (void)testManageBlockMemory
{
    id obj = [self getBlockArray];
    typedef void (^BlockType)(void);
    BlockType blockObject = (BlockType)[obj objectAtIndex:0];
    blockObject();
}
-(NSArray *)exampleB_addBlockToArray3
{
    int val = 10;
    return [[NSArray alloc] initWithObjects:^{
        NSLog(@"  > block 0:%d", val);
    },^{ NSLog(@"  > block 1:%d", val); }, nil];
}
-(void)exampleB3
{
    NSArray *array = [self exampleB_addBlockToArray3];
    void (^block)() = [array objectAtIndex:0];
    block();
}






NSString *__globalString = nil;

- (void)testGlobalObj
{
    __globalString = @"1";
    void (^TestBlock)(void) = ^{
        
        NSLog(@"string is :%@", __globalString); //string is :(null)
    };
    
    __globalString = nil;
    
    TestBlock();
}

- (void)testStaticObj
{
    static NSString *__staticString = nil;
    __staticString = @"1";
    
    printf("static address: %p\n", &__staticString);    //static address: 0x6a8c
    
    void (^TestBlock)(void) = ^{
        
        printf("static address: %p\n", &__staticString); //static address: 0x6a8c
        
        NSLog(@"string is : %@", __staticString); //string is :(null)
    };
    
    __staticString = nil;
    
    TestBlock();
}

- (void)testLocalObj
{
    NSString *__localString = nil;
    __localString = @"1";
    
    printf("local address: %p\n", &__localString); //local address: 0xbfffd9c0
    
    void (^TestBlock)(void) = ^{
        
        printf("local address: %p\n", &__localString); //local address: 0x71723e4
        
        NSLog(@"string is : %@", __localString); //string is : 1
    };
    
    __localString = nil;
    
    TestBlock();
}

- (void)testBlockObj
{
    __block NSString *_blockString = @"1";
    
    void (^TestBlock)(void) = ^{
        
        NSLog(@"string is : %@", _blockString); // string is :(null)
    };
    
    _blockString = nil;
    
    TestBlock();
}

- (void)testWeakObj
{
    NSString *__localString = @"1";
    
    __weak NSString *weakString = __localString;
    
    printf("weak address: %p\n", &weakString);  //weak address: 0xbfffd9c4
    printf("weak str address: %p\n", weakString); //weak str address: 0x684c
    
    void (^TestBlock)(void) = ^{
        
        printf("weak address: %p\n", &weakString); //weak address: 0x7144324
        printf("weak str address: %p\n", weakString); //weak str address: 0x684c
        
        NSLog(@"string is : %@", weakString); //string is :1
    };
    
    __localString = nil;
    
    TestBlock();
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    exampleA();
    exampleB();
    exampleC();
    exampleD();
    exampleE();
//    [self testManageBlockMemory];
//    [self exampleB3];
    [self testGlobalObj];
    [self testStaticObj];
    [self testLocalObj];
    [self testBlockObj];
    [self testWeakObj];
    // Do any additional setup after loading the view.
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 100.0, 100.0, 100.0)];
    [button setTitle:@"下一个VC" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0];
    
    [self.view addSubview:button];
    [button addTarget:self action:@selector(pushVC) forControlEvents:UIControlEventTouchUpInside];
}

- (void)pushVC
{
    YBYTSecondViewController *secondViewController = [[YBYTSecondViewController alloc] init];
    [self.navigationController pushViewController:secondViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self performSelector:@selector(postNo) withObject:nil afterDelay:3.0];
}

- (void)postNo
{
    NSLog(@"postNo");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"log" object:self userInfo:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
