//
//  DYHomeDetailsPriceDesc.m
//  DAYYPIN
//
//  Created by GY.Z on 2019/6/11.
//  Copyright © 2019 GYZ. All rights reserved.
//

#import "DYHomeDetailsPriceDesc.h"

@implementation DYHomeDetailsPriceDesc


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

+(instancetype)promotersNib
{
    NSString *className = NSStringFromClass([self class]);
    UINib *nib = [UINib nibWithNibName:className bundle:nil];
    return [nib instantiateWithOwner:nil options:nil].firstObject;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}


@end
