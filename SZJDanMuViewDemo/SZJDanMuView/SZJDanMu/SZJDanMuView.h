//
//  SZJDanMuView.h
//  SZJDanMuView
//
//  Created by TimesManager on 16/3/16.
//  Copyright © 2016年 TimesManager. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SZJDanMuModel;
typedef NS_ENUM (NSUInteger, PlayState)
{
    PLaying = 0,
    Pause,
    Stop
};
@interface SZJDanMuView : UIView

@property (nonatomic, assign)PlayState playState;

//预备弹幕
@property (nonatomic, strong)NSMutableArray* prepareDanMu;
//播放时间
@property (nonatomic, assign,readonly)CGFloat playTime;

/**
 *  用frame和预备弹幕数组初始化
 *
 *  @param prepareDanMuArray 预备弹幕数组
 *  @param frame             frame
 *
 *  @return 弹幕视图实例化
 */
- (instancetype)initPrepareDanMu:(NSMutableArray *)prepareDanMuArray WithFrame:(CGRect)frame;

/**
 *  开始播放弹幕
 */
- (void)startPlay;
/**
 *  暂停播放弹幕
 */
- (void)pausePlay;
/**
 *  停止播放弹幕
 */
- (void)stopPlay;
/**
 *  更新播放时间
 *
 *  @param playtime 播放时间
 */
- (void)updatePlayTime:(CGFloat)playtime;

/**
 *  发送一条弹幕
 *
 *  @param model 弹幕模型
 */
- (void)sendDanMu:(SZJDanMuModel *)model;


@end
