//
//  PriceTrend.m
//  GYCoreGraphics
//
//  Created by GY.Z on 2019/6/14.
//  Copyright © 2019 GYZ. All rights reserved.
//

#import "PriceTrend.h"
#import "DYHomeDetailsPriceDesc.h"
#import "Masonry.h"
#import "UIColor+GYColor.h"

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

@interface PriceTrend ()

@property(nonatomic,strong)DYHomeDetailsPriceDesc *priceDescView;

/// x轴数据
@property(nonatomic,strong)NSArray *dateArray;

/// y轴数据
@property(nonatomic,strong)NSArray *priceArray;

/// 价格日期数据
@property(nonatomic,strong)NSArray *sources;

@property(nonatomic,strong)UIView *trendBaseView;

@property(nonatomic,strong)UIView *line;

@property(nonatomic,strong)UIView *pointView;

@property(nonatomic,strong)UILabel *lastPriceL;


@end

@implementation PriceTrend

- (instancetype)initWithFrame:(CGRect)frame withDate:(nonnull NSArray *)date withPrice:(nonnull NSArray *)price sources:(nonnull NSArray *)sources
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.priceDescView = [DYHomeDetailsPriceDesc promotersNib];
        [self addSubview:self.priceDescView];
        [self.priceDescView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.height.equalTo(@72);
            make.top.equalTo(@0);
        }];
        
        self.trendBaseView = [[UIView alloc] initWithFrame:CGRectMake(20, 100, kWidth - 40, 150)];
        self.trendBaseView.userInteractionEnabled = YES;
        [self addSubview:self.trendBaseView];
        
        self.line = [[UIView alloc] init];
        self.line.hidden = YES;
        self.line.userInteractionEnabled = YES;
        [self.trendBaseView addSubview:self.line];
        [self.line mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.right.equalTo(@(0));
            make.height.equalTo(@150);
            make.width.equalTo(@(50));
        }];
        
        UIView *subLine = [[UIView alloc] init];
        subLine.backgroundColor = [UIColor colorWithHexString:@"#da2f25"];
        [self.line addSubview:subLine];
        [subLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.equalTo(@(24.75));
            make.height.equalTo(@150);
            make.width.equalTo(@(0.5));
        }];
        
        self.pointView = [[UIView alloc] init];
        self.pointView.backgroundColor = [UIColor colorWithHexString:@"#da2f25" Alpha:0.2];
        self.pointView.layer.cornerRadius = 6;
        [self.trendBaseView addSubview:self.pointView];
        self.pointView.hidden = YES;
        [self.pointView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(100));
            make.top.equalTo(@(100));
            make.width.height.equalTo(@(12));
        }];
        
        UIView *point = [[UIView alloc] init];
        point.backgroundColor = [UIColor colorWithHexString:@"#da2f25"];
        point.layer.cornerRadius = 3;
        [self.pointView addSubview:point];
        [point mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(3));
            make.top.equalTo(@(3));
            make.width.height.equalTo(@(6));
        }];
        
        CABasicAnimation*pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        pulse.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pulse.duration = 0.5;
        pulse.repeatCount = MAXFLOAT;
        pulse.autoreverses = YES;
        pulse.fromValue= [NSNumber numberWithFloat:0.7];
        pulse.toValue= [NSNumber numberWithFloat:1.3];
        [self.pointView.layer addAnimation:pulse forKey:nil];
        
        self.lastPriceL = [[UILabel alloc] init];
        self.lastPriceL.textColor = [UIColor colorWithHexString:@"#333333"];
        self.lastPriceL.font = [UIFont systemFontOfSize:10];
        [self addSubview:self.lastPriceL];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
        [self.line addGestureRecognizer:pan];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
        [self.trendBaseView addGestureRecognizer:tap];
        
        UIPanGestureRecognizer *panTrend = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panTrendGestureAction:)];
        [self.trendBaseView addGestureRecognizer:panTrend];
        
        /// 获取数据
        self.dateArray = date;
        self.priceArray = price;
        self.sources = sources;
    }
    return self;
}


- (void)tapGestureAction:(UITapGestureRecognizer *)tap
{
    CGPoint point = [tap locationInView:self.trendBaseView];
    NSLog(@"UITapGestureRecognizer = %@",NSStringFromCGPoint(point));
    [self exchangePointViewWithPoint:point];
}

-(void)panTrendGestureAction:(UIPanGestureRecognizer *)pan
{
    CGPoint point = [pan locationInView:self.trendBaseView];
    NSLog(@"panTrendGestureAction = %@",NSStringFromCGPoint(point));
    [self exchangePointViewWithPoint:point];
}

- (void)exchangePointViewWithPoint:(CGPoint)point
{
    if (CGRectContainsPoint(CGRectMake(25, 0, kWidth - 90, 150), point)) {
        self.line.hidden = NO;
        self.pointView.hidden = NO;
        
        point.x = point.x <= 25 ? 25 : (point.x > (kWidth - 65) ? (kWidth - 65) : point.x);
        point.y = 75;
        self.line.center = point;
        
        if (_sources.count > 0) {
            CGFloat i = point.x - 25;
            CGFloat sub = (kWidth - 90) / _sources.count;
            NSInteger mar = i / sub;
            NSDictionary *currentDict;
            if (mar < _sources.count) {
                currentDict = _sources[mar];
            }else if(mar < 0){
                currentDict = _sources[0];
            }else{
                currentDict = _sources.lastObject;
            }
            
            NSMutableArray *price = [NSMutableArray array];
            for (NSDictionary *dict in _sources) {
                [price addObject:dict[@"pr"]];
            }
            NSString *pr = [NSString stringWithFormat:@"%@",currentDict[@"pr"]];
            float nowFloat = [pr floatValue];
            CGFloat maxValue = [[price valueForKeyPath:@"@max.floatValue"] floatValue];
            CGFloat minValue = [[price valueForKeyPath:@"@min.floatValue"] floatValue];
            CGFloat poor = (maxValue - minValue);
            poor = poor > 0 ? poor : 1;
            CGFloat y = (nowFloat - minValue)/poor * 100 + 1;
            NSLog(@"x = %.2f y = %.2f mar = %ld sub = %.2f _sources.count = %ld",i,y,mar,sub,_sources.count);
            self.pointView.center = CGPointMake(i + 25, 125 - y);
            
            [self currentDictMethods:currentDict];
        }
    }
}

-(void)panGestureAction:(UIPanGestureRecognizer *)pan
{
    CGPoint point = [pan translationInView:self.trendBaseView];
    //改变中心点坐标（原来的中心点+偏移量=当前的中心点）
    CGPoint newCenter = CGPointMake(pan.view.center.x + point.x, pan.view.center.y + point.y);
    
    //    NSLog(@"x=%.2lf y=%.2lf",pan.view.center.x,pan.view.center.y);
    
    if (_sources.count > 0) {
        CGFloat i = pan.view.center.x - 25;
        CGFloat sub = (kWidth - 90) / _sources.count;
        NSInteger mar = i / sub;
        
        NSDictionary *currentDict;
        if (mar < _sources.count) {
            currentDict = _sources[mar];
        }else if(mar < 0){
            currentDict = _sources[0];
        }else{
            currentDict = _sources.lastObject;
        }
        
        NSMutableArray *price = [NSMutableArray array];
        for (NSDictionary *dict in _sources) {
            [price addObject:dict[@"pr"]];
        }
        NSString *pr = [NSString stringWithFormat:@"%@",currentDict[@"pr"]];
        float nowFloat = [pr floatValue];
        CGFloat maxValue = [[price valueForKeyPath:@"@max.floatValue"] floatValue];
        CGFloat minValue = [[price valueForKeyPath:@"@min.floatValue"] floatValue];
        CGFloat poor = (maxValue - minValue);
        poor = poor > 0 ? poor : 1;
        CGFloat y = (nowFloat - minValue)/poor * 100 + 1;
        NSLog(@"x = %.2f y = %.2f mar = %ld sub = %.2f _sources.count = %ld",i,y,mar,sub,_sources.count);
        self.pointView.center = CGPointMake(i + 25, 125 - y);
        
        [self currentDictMethods:currentDict];
    }
    
    //限制拖动范围
    newCenter.y = MAX(pan.view.frame.size.height/2, newCenter.y);
    newCenter.y = MIN(self.trendBaseView.frame.size.height - pan.view.frame.size.height/2,newCenter.y);
    newCenter.x = MAX(pan.view.frame.size.width/2, newCenter.x);
    newCenter.x = MIN(self.trendBaseView.frame.size.width - pan.view.frame.size.width/2,newCenter.x);
    pan.view.center = newCenter;
    
    //每次调用之后，需要重置手势的偏移量，否则偏移量会自动累加
    [pan setTranslation:CGPointZero inView:self];
}

/// 展示数据
- (void)currentDictMethods:(NSDictionary *)currentDict
{
    if (currentDict.allKeys.count > 0) {
        NSString *dt = [NSString stringWithFormat:@"%@",currentDict[@"dt"]];
        NSString *pr = [NSString stringWithFormat:@"价格￥%@",currentDict[@"pr"]];
        NSDateFormatter *matter = [[NSDateFormatter alloc]init];
        matter.dateFormat = @"yyyy-MM-dd";
        NSTimeInterval time = [dt integerValue] / 1000;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
        NSString*timeStr = [matter stringFromDate:date];
        NSLog(@"日期：%@ 价格：%@",timeStr,pr);
        if (pr.length > 0) {
            NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:pr];
            [attri addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#333333"] range:NSMakeRange(0, 2)];
            self.priceDescView.priceL.attributedText = attri;
        }
        if (dt.length > 0) {
            NSDateFormatter *matter = [[NSDateFormatter alloc]init];
            matter.dateFormat = @"yyyy-MM-dd";
            NSTimeInterval time = [dt integerValue] / 1000;
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
            NSString*timeStr = [matter stringFromDate:date];
            self.priceDescView.dateL.text = timeStr;
        }
    }
}

-(void)setPriceDict:(NSDictionary *)priceDict
{
    _priceDict = priceDict;
    if (_priceArray.count == 0) return;
    NSMutableArray *price = [NSMutableArray array];
    for (NSDictionary *dict in _sources) {
        [price addObject:dict[@"pr"]];
    }
        
    CGFloat maxValue = [[price valueForKeyPath:@"@max.floatValue"] floatValue];
    
    if (maxValue > [price.lastObject floatValue]) {
        self.priceDescView.trendDesc.text = @"价格下降";
        self.priceDescView.trendImageV.image = [UIImage imageNamed:@"icon_price_drop"];
    }else if (maxValue == [price.lastObject floatValue]){
        self.priceDescView.trendDesc.text = @"价格平稳";
        self.priceDescView.trendImageV.image = [UIImage imageNamed:@"icon_price_stability"];
    }else{
        self.priceDescView.trendDesc.text = @"价格上涨";
        self.priceDescView.trendImageV.image = [UIImage imageNamed:@"icon_price_rise"];
    }
    
    if (priceDict[@"data"] && [priceDict[@"data"] isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = priceDict[@"data"];
        NSString *lowerPrice = [NSString stringWithFormat:@"历史最低价￥%@",dict[@"lowerPrice"]];
        if (lowerPrice.length > 0) {
            NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:lowerPrice];
            [attri addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#333333"] range:NSMakeRange(0, 5)];
            self.priceDescView.trendPrice.attributedText = attri;
        }
    }
    
    NSDictionary *currentDict = _sources.lastObject;
    
    if (currentDict.allKeys.count > 0) {
        NSString *dt = [NSString stringWithFormat:@"%@",currentDict[@"dt"]];
        NSString *pr = [NSString stringWithFormat:@"价格￥%@",currentDict[@"pr"]];
        if (pr.length > 0) {
            NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:pr];
            [attri addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#333333"] range:NSMakeRange(0, 2)];
            self.priceDescView.priceL.attributedText = attri;
        }
        
        if (dt.length > 0) {
            NSDateFormatter *matter = [[NSDateFormatter alloc]init];
            matter.dateFormat = @"yyyy-MM-dd";
            NSTimeInterval time = [dt integerValue] / 1000;
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
            NSString*timeStr = [matter stringFromDate:date];
            NSLog(@"%@",timeStr);
            
            self.priceDescView.dateL.text = timeStr;
        }
        
        self.lastPriceL.text = price.count > 0 ? [NSString stringWithFormat:@"%@",price.lastObject] : nil;
        CGFloat maxValue = [[price valueForKeyPath:@"@max.floatValue"] floatValue];
        CGFloat minValue = [[price valueForKeyPath:@"@min.floatValue"] floatValue];
        CGFloat nowFloat = [price.lastObject floatValue];
        CGFloat poor = (maxValue - minValue);
        poor = poor > 0 ? poor : 1;
        CGFloat y = (nowFloat - minValue)/poor * 100 + 1;        
        [self.lastPriceL mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(kWidth - 40));
            make.height.equalTo(@20);
            make.top.equalTo(@(215 - y));
        }];
    }
}

- (void)drawRect:(CGRect)rect
//// Group
{
    
    /// 画表格
    [self graphicsPath];
    /// 画标题
    [self graphicsContext];
    
    /// 画走势图
    [self graphicsPriceTrend];
}

- (void)graphicsPath
{
    UIColor* color2 = [UIColor colorWithRed: 0.867 green: 0.867 blue: 0.867 alpha: 1];
    
    CGFloat width = kWidth - 90;
    CGFloat scaleW = width / 6;
    CGFloat height = 150;
    CGFloat scaleH = height / 6;
    CGFloat leftMargin = 45;
    CGFloat topMargin = 100;
    
    //// Rectangle Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(leftMargin, topMargin, width, height)];
    [color2 setStroke];
    rectanglePath.lineWidth = 0.5;
    [rectanglePath stroke];
    
    for (int i = 0; i < _dateArray.count; i++) {
        //// Bezier Drawing
        UIBezierPath* bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint: CGPointMake(leftMargin, topMargin + scaleH + scaleH * i)];
        [bezierPath addLineToPoint: CGPointMake(width + leftMargin, topMargin + scaleH + scaleH * i)];
        [color2 setStroke];
        bezierPath.lineWidth = 0.5;
        [bezierPath stroke];
        
        //// Bezier Drawing
        UIBezierPath* bezier7Path = [UIBezierPath bezierPath];
        [bezier7Path moveToPoint: CGPointMake(leftMargin + scaleW + scaleW * i, topMargin)];
        [bezier7Path addLineToPoint: CGPointMake(leftMargin + scaleW + scaleW * i, topMargin + height)];
        [color2 setStroke];
        bezier7Path.lineWidth = 0.5;
        [bezier7Path stroke];
    }
}

- (void)graphicsContext
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat width = kWidth - 90;
    CGFloat scaleW = width / 6;
    CGFloat height = 150;
    CGFloat scaleH = height / 6;
    CGFloat leftMargin = 45;
    CGFloat topMargin = 100;
    
    for (int i = 0; i < _priceArray.count; i++) {
        
        CGRect textRect = CGRectMake(leftMargin + scaleW / 2 + scaleW * i, topMargin + height, scaleW, scaleH);
        NSString* textContent = _dateArray[i];
        NSMutableParagraphStyle* textStyle = [[NSMutableParagraphStyle alloc] init];
        textStyle.alignment = NSTextAlignmentCenter;
        NSDictionary* textFontAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize: 10], NSForegroundColorAttributeName: UIColor.darkGrayColor, NSParagraphStyleAttributeName: textStyle};
        
        CGFloat textTextHeight = [textContent boundingRectWithSize: CGSizeMake(textRect.size.width, INFINITY) options: NSStringDrawingUsesLineFragmentOrigin attributes: textFontAttributes context: nil].size.height;
        CGContextSaveGState(context);
        CGContextClipToRect(context, textRect);
        [textContent drawInRect: CGRectMake(CGRectGetMinX(textRect), CGRectGetMinY(textRect) + (textRect.size.height - textTextHeight) / 2, textRect.size.width, textTextHeight) withAttributes: textFontAttributes];
        CGContextRestoreGState(context);
        
        CGRect text8Rect = CGRectMake(0, topMargin + height - scaleH * 1.5 - i * scaleH, leftMargin - 10, scaleH);
        NSString* textVContent = _priceArray[i];
        NSMutableParagraphStyle* text8Style = [[NSMutableParagraphStyle alloc] init];
        text8Style.alignment = NSTextAlignmentRight;
        NSDictionary* text8FontAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize: 10], NSForegroundColorAttributeName: UIColor.darkGrayColor, NSParagraphStyleAttributeName: text8Style};
        
        CGFloat text8TextHeight = [textVContent boundingRectWithSize: CGSizeMake(text8Rect.size.width, INFINITY) options: NSStringDrawingUsesLineFragmentOrigin attributes: text8FontAttributes context: nil].size.height;
        CGContextSaveGState(context);
        CGContextClipToRect(context, text8Rect);
        [textVContent drawInRect: CGRectMake(CGRectGetMinX(text8Rect), CGRectGetMinY(text8Rect) + (text8Rect.size.height - text8TextHeight) / 2, text8Rect.size.width, text8TextHeight) withAttributes: text8FontAttributes];
        CGContextRestoreGState(context);
    }
}

- (void)graphicsPriceTrend
{
    CGFloat width = kWidth - 90;
    //    CGFloat scaleW = width / 6;
    CGFloat height = 150;
    CGFloat scaleH = height / 6;
    CGFloat leftMargin = 45;
    CGFloat topMargin = 100;
    
    UIColor *color = [UIColor colorWithHexString:@"#da2f25"];
    
    NSMutableArray *price = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in _sources) {
        CGFloat pr = [dict[@"pr"] floatValue];
        [price addObject:[NSString stringWithFormat:@"%.2f",pr]];
    }
    /// 总和 sum.floatValue   平均值 avg.floatValue
    NSInteger count = _sources.count - 1;
    count = count > 1 ? count : 2;
    CGFloat sub = width / count;
    CGFloat maxValue = [[price valueForKeyPath:@"@max.floatValue"] floatValue];
    CGFloat minValue = [[price valueForKeyPath:@"@min.floatValue"] floatValue];
    //nowFloat是当前值
    /// 计算公式 = (价格 - min) / (max - min) = x / 100(价格实际Y轴高度)
    float nowFloat = [price[0] floatValue];
    CGFloat poor = (maxValue - minValue);
    poor = poor > 0 ? poor : 1;
    CGFloat yy = (nowFloat - minValue)/poor * 100 + 1;
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    bezierPath.lineWidth = 1;
    /// 设置起点
    [bezierPath moveToPoint: CGPointMake(leftMargin, topMargin + height - scaleH - yy)];
    NSMutableArray *pointArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < _sources.count; i++) {
        //// Bezier Drawing
        float nowFloat = [price[i] floatValue];
        CGFloat poor = (maxValue - minValue);
        poor = poor > 0 ? poor : 1;
        CGFloat yy = (nowFloat - minValue)/poor * 100 + 1;
        CGPoint point = CGPointMake(leftMargin + sub * i, topMargin + height - scaleH - yy);
        NSValue *value = [NSValue valueWithCGPoint:point];
        [pointArray addObject:value];
    }
    
    for (int i = 0; i < pointArray.count; i++) {
        if (i != 0) {
            CGPoint prePoint = [[pointArray objectAtIndex:i-1] CGPointValue];
            CGPoint nowPoint = [[pointArray objectAtIndex:i] CGPointValue];
            [bezierPath addCurveToPoint:nowPoint controlPoint1:CGPointMake((nowPoint.x+prePoint.x)/2, prePoint.y) controlPoint2:CGPointMake((nowPoint.x+prePoint.x)/2, nowPoint.y)];
        }
    }
    
    //显示线
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = bezierPath.CGPath;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = color.CGColor;
    shapeLayer.lineWidth = 1.5;
    [self.layer addSublayer:shapeLayer];
    //设置动画
    CABasicAnimation *anmi = [CABasicAnimation animation];
    anmi.keyPath = @"strokeEnd";
    anmi.fromValue = [NSNumber numberWithFloat:0];
    anmi.toValue = [NSNumber numberWithFloat:1.0f];
    anmi.duration = 2.0f;
    anmi.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anmi.autoreverses = NO;
    [shapeLayer addAnimation:anmi forKey:@"stroke"];
}

@end
