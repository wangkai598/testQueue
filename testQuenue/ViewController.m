//
//  ViewController.m
//  testQuenue
//
//  Created by Admin on 2019/6/25.
//  Copyright © 2019 YunQue. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self gcdDemo2];
    // Do any additional setup after loading the view.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self gcdDemo6];
    [NSThread sleepForTimeInterval:1];
    NSLog(@"over");
}
//串行队列同步执行
-(void)gcdDemo1{
    dispatch_queue_t queue = dispatch_queue_create("com.wk.com", DISPATCH_QUEUE_SERIAL);
    for (int i = 0; i<10; ++i) {
        NSLog(@"----%d",i);
        dispatch_sync(queue, ^{
            NSLog(@"%@----%d",[NSThread currentThread],i);
        });
        
    }
    NSLog(@"come here");
}
//并发
-(void)gcdDemo2{
    dispatch_queue_t queue = dispatch_queue_create("com.wk.com", DISPATCH_QUEUE_CONCURRENT);
    for (int i = 0; i<10; ++i) {
        NSLog(@"----%d",i);
        dispatch_async(queue, ^{
            NSLog(@"%@----%d",[NSThread currentThread],i);
        });
        
    }
      NSLog(@"come here");
}
//主队列异步执行
-(void)gcdDemo3{
    dispatch_queue_t queue = dispatch_get_main_queue();
    for (int i =0; i<10; ++i) {
        dispatch_async(queue, ^{
            NSLog(@"%@ - %D",[NSThread currentThread],i);
        });
          NSLog(@"---> %d", i);
    }
    NSLog(@"come here");
}
//主队列同步执行
// 主队列和主线程相互等待会造成死锁
-(void)gcdDemo4{
    dispatch_queue_t queue = dispatch_get_main_queue();
    NSLog(@"!!!");
        dispatch_sync(queue, ^{
            NSLog(@"%@",[NSThread currentThread]);
        });
    NSLog(@"come here");
}
//例如：在用户登录之后，再异步下载文件！

- (void)gcdDemo5 {
    dispatch_queue_t queue = dispatch_queue_create("com.itheima.queue", DISPATCH_QUEUE_CONCURRENT);
    
//    dispatch_sync(queue, ^{
//        NSLog(@"登录 %@", [NSThread currentThread]);
//    });
    dispatch_async(queue, ^{
        NSLog(@"登录 %@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"下载 A %@", [NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"下载 B %@", [NSThread currentThread]);
    });
}
//主队列调度同步队列不死锁
-(void)gcdDemo6{
    dispatch_queue_t queue = dispatch_queue_create("com.www.com", DISPATCH_QUEUE_CONCURRENT);
    void (^task)(void) = ^{
        dispatch_sync(queue, ^{
            NSLog(@"死?");
        });
    };
    dispatch_async(queue, task);
}
@end
