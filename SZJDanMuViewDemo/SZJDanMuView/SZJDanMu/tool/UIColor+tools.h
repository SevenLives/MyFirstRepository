//
//  UIColor+tools.h
//  TSPizza
//
//  Created by taiyh on 14/10/21.
//  Copyright (c) 2014年 ETS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (tools)

+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

@end
