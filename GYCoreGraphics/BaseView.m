//
//  BaseView.m
//  GYCoreGraphics
//
//  Created by GY.Z on 2019/6/14.
//  Copyright © 2019 GYZ. All rights reserved.
//

#import "BaseView.h"
#import "PriceTrend.h"

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

@interface BaseView ()

@property(nonatomic,strong)PriceTrend *priceTrend;


@end

@implementation BaseView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setupSubviews];
    }
    
    return self;
}

- (void)setupSubviews
{
    
    
    
}

-(void)setPriceDict:(NSDictionary *)priceDict
{
    _priceDict = priceDict;

    UIView *view = [self viewWithTag:2000];
    if (view != nil) {
        [view removeFromSuperview];
    }
    
    NSMutableArray *dateArray = [[NSMutableArray alloc] init];
    NSMutableArray *dateArr = [[NSMutableArray alloc] init];
    NSMutableArray *priceArray = [[NSMutableArray alloc] init];
    NSMutableArray *listPrice = [[NSMutableArray alloc] init];
    
    if (priceDict[@"data"] && [priceDict[@"data"] isKindOfClass:[NSDictionary class]] && [priceDict[@"data"][@"listPrice"] isKindOfClass:[NSArray class]]) {
        [listPrice addObjectsFromArray:priceDict[@"data"][@"listPrice"]];
        /**
         {
         dt = 1560355200000;
         pr = "39.80";
         }
         */
        if (listPrice.count > 6) {
            for (NSDictionary *dict in listPrice) {
                NSDateFormatter *matter = [[NSDateFormatter alloc]init];
                matter.dateFormat =@"MM-dd";
                NSTimeInterval time = [dict[@"dt"] integerValue] / 1000;
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
                NSString*timeStr = [matter stringFromDate:date];
                
                [dateArray addObject:timeStr];
                [dateArr addObject:dict[@"dt"]];
                [priceArray addObject:dict[@"pr"]];
            }
        }else{
            if (listPrice.count > 0) {
                NSDictionary *currentDict = listPrice.lastObject;
                NSMutableArray *prices = [[NSMutableArray alloc] init];
                for (NSDictionary *dict in listPrice) {
                    [prices addObject:dict[@"pr"]];
                }
                
                /// 取最小价格  计算y轴坐标
                NSString *pr = [prices valueForKeyPath:@"@min.floatValue"];
                /// 去最后一个对象  获取  最新时间
                NSString *dt = [NSString stringWithFormat:@"%@",currentDict[@"dt"]];
                NSInteger date = [dt integerValue];
                
                for (int i = 0; i < 6; i++) {
                    NSDictionary *dict = @{@"dt":@(date - 86400 * 1000 * (i + 1)),@"pr":pr};
                    [listPrice insertObject:dict atIndex:0];
                    if (listPrice.count > 6) {
                        break;
                    }
                }
                
                for (NSDictionary *dict in listPrice) {
                    NSDateFormatter *matter = [[NSDateFormatter alloc]init];
                    matter.dateFormat =@"MM-dd";
                    NSTimeInterval time = [dict[@"dt"] integerValue] / 1000;
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
                    NSString*timeStr = [matter stringFromDate:date];
                    
                    [dateArray addObject:timeStr];
                    [dateArr addObject:dict[@"dt"]];
                    [priceArray addObject:dict[@"pr"]];
                }
            }
        }
    }
    
    if (dateArray.count > 6) {
        NSInteger index = dateArray.count / 6;
        NSMutableArray *indexdtArray = [[NSMutableArray alloc] init];
        NSMutableArray *indexprArray = [[NSMutableArray alloc] init];
        for (int i = 1; i <= 6; i++) {
            if (i * index < dateArray.count) {
                if (i == 6) {
                    [indexdtArray addObject:dateArray.lastObject];
                }else{
                    [indexdtArray addObject:dateArray[i * index]];
                }
            }else{
                [indexdtArray addObject:dateArray.lastObject];
            }
        }
        CGFloat maxValue = [[priceArray valueForKeyPath:@"@max.floatValue"] floatValue];
        CGFloat minValue = [[priceArray valueForKeyPath:@"@min.floatValue"] floatValue];
        NSLog(@"minValue = %.2f maxValue = %.2f",minValue,maxValue);
        
        CGFloat num = maxValue - minValue;
        CGFloat sub = num / 4.0;
        if (sub <= 0) {
            sub = 10;
        }
        for (int i = 0; i < 6; i++) {
            CGFloat pr = ceil(minValue + i * sub);
            [indexprArray addObject:[NSString stringWithFormat:@"%.f",pr]];
        }
        
        NSLog(@"indexprArray = %@",indexprArray);
        NSLog(@"indexdtArray = %@",indexdtArray);
        
        self.priceTrend = [[PriceTrend alloc] initWithFrame:CGRectMake(0, 60, kWidth, 280) withDate:indexdtArray withPrice:indexprArray sources:listPrice];
        self.priceTrend.priceDict = priceDict;
        self.priceTrend.tag = 2000;
        self.priceTrend.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.priceTrend];
        
    }else{

    }
}



@end
