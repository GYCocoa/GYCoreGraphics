//
//  PriceTrend.h
//  GYCoreGraphics
//
//  Created by GY.Z on 2019/6/14.
//  Copyright © 2019 GYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PriceTrend : UIView

-(instancetype)initWithFrame:(CGRect)frame withDate:(NSArray *)date withPrice:(NSArray *)price sources:(NSArray *)sources;

/// 价格走势图
@property(nonatomic,strong)NSDictionary *priceDict;


@end

NS_ASSUME_NONNULL_END
