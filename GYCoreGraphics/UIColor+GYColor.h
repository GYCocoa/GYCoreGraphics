//
//  UIColor+GYColor.h
//  CZYCClient
//
//  Created by GY.Z on 2017/3/16.
//  Copyright © 2017年 GY.Z. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,UIRectEdgeDirection)
{
    UIRectEdgeLeftToRight,
    UIRectEdgeRightToLeft,
    UIRectEdgeTopToBottom,
    UIRectEdgeBottomToTop
};

@interface UIColor (GYColor)
+ (UIColor *)colorWithGYRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue;

/**
 *  16进制转uicolor
 *
 *  @param color @"#FFFFFF" ,@"OXFFFFFF" ,@"FFFFFF"
 *
 *  @return uicolor
 */
+ (UIColor *)colorWithHexString:(NSString *)color;

+ (UIColor *)colorWithHexString:(NSString *)color Alpha:(CGFloat)alpha;

//绘制渐变色颜色的方法
+ (CAGradientLayer *)setGradualChangingColor:(UIView *)view fromColor:(NSString *)fromHexColorStr toColor:(NSString *)toHexColorStr direction:(UIRectEdgeDirection)direction;

@end
