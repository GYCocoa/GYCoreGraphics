//
//  ViewController.m
//  GYCoreGraphics
//
//  Created by GY.Z on 2019/6/14.
//  Copyright © 2019 GYZ. All rights reserved.
//

#import "ViewController.h"
#import "BaseView.h"

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    BaseView *view = [[BaseView alloc] initWithFrame:CGRectMake(0, 100, kWidth, kWidth)];
    
    [self.view addSubview:view];
    
    // 获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"priceTrend" ofType:@"json"];
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    // 对数据进行JSON格式化并返回字典形式
    NSDictionary *object = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];

    view.priceDict = object;
}


@end
