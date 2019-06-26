//
//  ArrayViewController.m
//  testQuenue
//
//  Created by Admin on 2019/6/26.
//  Copyright © 2019 YunQue. All rights reserved.
//

#import "ArrayViewController.h"

@interface ArrayViewController ()
@property(strong,nonatomic)dispatch_queue_t queue;
@property(nonatomic,strong)NSMutableArray *photoArray;
@property(nonatomic,strong)  UIImage *image;
@end

@implementation ArrayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor yellowColor];
    self.title = @"多个线程操作同一数组测试";
    for (int i=0; i<10; i++) {
        [self loadPhotos:i];
    }
}
-(void)loadPhotos:(int)index{
    //以下必崩,由于 NSMutableArray 是非线程安全的，如果出现两个线程在同一时间向数组中添加对象，会出现程序崩溃的情况
//    dispatch_async(self.queue, ^{
//        [NSThread sleepForTimeInterval:1.0];
//        NSString *fileName = [NSString stringWithFormat:@"%02d.jpg",index%10+1];
//        NSString *path = [[NSBundle mainBundle]pathForResource:fileName ofType:nil];
//        UIImage *image =[UIImage imageWithContentsOfFile:path];
//        [self.photoArray addObject:fileName];
//        NSLog(@"添加照片%@",fileName);
//    });
        dispatch_async(self.queue, ^{
            [NSThread sleepForTimeInterval:1.0];
            NSString *fileName = [NSString stringWithFormat:@"%02d.jpg",index%10+1];
            NSString *path = [[NSBundle mainBundle]pathForResource:fileName ofType:nil];
          UIImage *image =[UIImage imageWithContentsOfFile:path];
  NSLog(@"----异步 %@",[NSThread currentThread]);
            dispatch_barrier_async(self.queue, ^{
                        NSLog(@"添加照片%@",fileName);
                [self.photoArray addObject:fileName];
                NSLog(@"-----ok %@",[NSThread currentThread]);
            });

        });

    

    
}
-(dispatch_queue_t)queue{
    if (!_queue) {
        _queue=dispatch_queue_create("com.wk.com", DISPATCH_QUEUE_CONCURRENT);
    }
    return _queue;
}
-(NSMutableArray *)photoArray{
    if (!_photoArray) {
        _photoArray = [NSMutableArray array];
    }
    return _photoArray;
}


@end
