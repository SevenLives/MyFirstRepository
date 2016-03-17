//
//  SZJDanMuModel.h
//  SZJDanMuView
//
//  Created by TimesManager on 16/3/16.
//  Copyright © 2016年 TimesManager. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZJDanMuLabel.h"
@interface SZJDanMuModel : NSObject

//弹幕内容
@property (nonatomic, copy) NSString* danMuText;
//弹幕字体大小
@property (nonatomic, copy) NSString* danMuTextFont;
//弹幕字体颜色
@property (nonatomic, copy) NSString* danMuTextColor;
//弹幕发射速度
@property (nonatomic, copy) NSString* danMuSpeed;
//弹幕类型 0：从左到右滚动 1：顶部  2：底部
@property (nonatomic, copy) NSString* danMuType;
//弹幕发送者ID
@property (nonatomic, copy) NSString* senderId;
//弹幕发送时间 单位(毫秒)
@property (nonatomic, copy) NSString* sendTime;
//顶部/底部弹幕消失时间
@property (nonatomic, assign) CGFloat disappearTime;
//弹幕是否完全显示
@property (nonatomic, assign) BOOL isCompleteShow;


//弹幕Label
@property (nonatomic, strong)SZJDanMuLabel* danMuLabel;

/**
 *  弹幕模型初始化
 *
 *  @param attributes 初始化相关设置
 *
 *  @return 弹幕实例化
 */
- (instancetype)initWithAttributes:(NSDictionary *)attributes;
@end
