//
//  YKActionViewController.m
//  Lock
//
//  Created by 凯子 on 14-5-8.
//  Copyright (c) 2014年 Bingye Yu. All rights reserved.
//

#import "YKActionViewController.h"

@interface YKActionViewController ()

@end

@implementation YKActionViewController

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
    //主线程中
    YKTest *obj = [[YKTest alloc] init];
    [self.view addSubview:obj];
    
//    NSLock *lock = [[NSLock alloc] init];
//    //线程1
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [lock lock];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [obj method1];
//        });
//        sleep(3);
//        [lock unlock];
//    });
//    
//    //线程2
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
////        sleep(1);//以保证让线程2的代码后执行
//        [lock lock];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [obj method2];
//        });
//        [lock unlock];
//    });

//    //线程1
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        @synchronized(obj){
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [obj method1];
//            });
//            sleep(3);
//        }
//    });
//    
//    //线程2
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        sleep(1);
//        @synchronized(obj){
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [obj method2];
//            });
//        }
//    });
    
//    __block pthread_mutex_t mutex;
//    pthread_mutex_init(&mutex, NULL);
//    
//    //线程1
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        pthread_mutex_lock(&mutex);
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [obj method1];
//        });
//        sleep(3);
//        pthread_mutex_unlock(&mutex);
//    });
//    
//    //线程2
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        sleep(1);
//        pthread_mutex_lock(&mutex);
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [obj method2];
//        });
//        pthread_mutex_unlock(&mutex);
//    });
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    //线程1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_async(dispatch_get_main_queue(), ^{
            [obj method1];
        });
        sleep(3);
        dispatch_semaphore_signal(semaphore);
    });
    
    //线程2
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(1);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_async(dispatch_get_main_queue(), ^{
            [obj method2];
        });
        dispatch_semaphore_signal(semaphore);
    });

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
