//
//  SZJDanMuModel.m
//  SZJDanMuView
//
//  Created by TimesManager on 16/3/16.
//  Copyright © 2016年 TimesManager. All rights reserved.
//

#import "SZJDanMuModel.h"
#import "SZJDanMuLabel.h"
#import "UIColor+tools.h"
@implementation SZJDanMuModel

- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    if (self = [super init]) {
        self.danMuSpeed = attributes[@"speed"];
        self.danMuText = attributes[@"context"];
        self.danMuTextColor = attributes[@"textColor"];
        self.danMuTextFont = attributes[@"textFont"];
        self.danMuType = attributes[@"type"];
        self.senderId = attributes[@"senderId"];
        self.sendTime = attributes[@"sendTime"];
        self.disappearTime = [attributes[@"disappearTime"] floatValue];
        self.danMuLabel = [[SZJDanMuLabel alloc] init];
        if ([self.senderId isEqualToString:@"213"]) {
            self.danMuLabel.layer.borderColor = [UIColor whiteColor].CGColor;
            self.danMuLabel.layer.borderWidth = 2;
        }
        self.danMuLabel.danMuType = self.danMuType;
        self.danMuLabel.text = self.danMuText;
        self.danMuLabel.textColor = [UIColor colorWithHexString:self.danMuTextColor];
        self.danMuLabel.font = [UIFont systemFontOfSize:[self.danMuTextFont integerValue]];
        [self.danMuLabel sizeToFit];
        NSLog(@"%f,%f",self.danMuLabel.bounds.size.width,self.danMuLabel.bounds.size.height);
    }
    return self;
}
@end
