//
//  DYHomeDetailsPriceDesc.h
//  DAYYPIN
//
//  Created by GY.Z on 2019/6/11.
//  Copyright © 2019 GYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DYHomeDetailsPriceDesc : UIView

@property (weak, nonatomic) IBOutlet UILabel *trendDesc;
@property (weak, nonatomic) IBOutlet UIImageView *trendImageV;
@property (weak, nonatomic) IBOutlet UILabel *trendPrice;
@property (weak, nonatomic) IBOutlet UILabel *dateL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;



+(instancetype)promotersNib;

@end

NS_ASSUME_NONNULL_END
