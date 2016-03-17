//
//  SZJDanMuView.m
//  SZJDanMuView
//
//  Created by TimesManager on 16/3/16.
//  Copyright © 2016年 TimesManager. All rights reserved.
//

#import "SZJDanMuView.h"
#import "SZJDanMuModel.h"
#define TIMERINTERVAL 0.001

@interface SZJDanMuView()
{
   
    //弹幕计时器
    NSTimer* danMuTimer;
    //屏幕右侧剩余可插入的地方
    NSMutableArray* rightBlankPalceArray;
    //屏幕顶部剩余可插入的地方
    NSMutableArray* topBlankPlaceArray;
    //屏幕底部剩余可插入的地方
    NSMutableArray* bottomBlankPlaceArray;
    //屏幕上剩余弹幕数组
    NSMutableArray* screenExistDanmuArray;
    //已经完成一次位置更新
    BOOL isCompleteUpdate;
}

@end
@implementation SZJDanMuView



- (instancetype)initPrepareDanMu:(NSMutableArray *)prepareDanMuArray WithFrame:(CGRect)frame
{
    if (self = [super init]) {
        self.prepareDanMu = prepareDanMuArray;
        if (self.prepareDanMu) {
            [self.prepareDanMu sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                
                SZJDanMuModel* danMuModel1 = obj1;
                SZJDanMuModel* danMuModel2 = obj2;
                return [danMuModel1.sendTime integerValue] - [danMuModel2.sendTime integerValue];
            }];

        }
        else
        {
            self.prepareDanMu = [NSMutableArray array];
        }
        isCompleteUpdate = YES;
        screenExistDanmuArray = [NSMutableArray array];
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor blackColor];
        self.frame = frame;
        NSDictionary* rightValidPlace = @{@"minY":@(0),@"maxY":@(self.bounds.size.height)};
        NSDictionary* topValidPlace = @{@"minY":@(0),@"maxY":@(self.bounds.size.height/2)};
        NSDictionary* bottomValidPlace = @{@"minY":@(self.bounds.size.height/2),@"maxY":@(self.bounds.size.height)};
        rightBlankPalceArray = [NSMutableArray arrayWithObject:rightValidPlace];
        topBlankPlaceArray = [NSMutableArray arrayWithObject:topValidPlace];
        bottomBlankPlaceArray = [NSMutableArray arrayWithObject:bottomValidPlace];
        _playState = Pause;
        
    }
    return self;
}
#pragma mark -- 开始播放弹幕
- (void)startPlay
{
    _playState = PLaying;
    danMuTimer = [NSTimer scheduledTimerWithTimeInterval:TIMERINTERVAL target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    [danMuTimer fire];
}

#pragma mark -- 暂停播放弹幕
- (void)pausePlay
{
    _playState = Pause;
    [danMuTimer invalidate];
     danMuTimer = nil;
}
#pragma mark -- 停止播放弹幕

- (void)stopPlay
{
    _playState = Stop;
    [danMuTimer invalidate];
    danMuTimer = nil;
    for (id view in self.subviews) {
        if ([view isKindOfClass:[SZJDanMuLabel class]]) {
            [view removeFromSuperview];
        }
    }
    
}

#pragma mark -- 0.001秒回调一次是否有弹幕要发射 或者更新弹幕位置
- (void)onTimer
{
    //如果弹幕库中还有弹幕
    if (self.prepareDanMu.count>0) {
        //如果最前面一条弹幕发送时间到达播放时间
        if ([[self.prepareDanMu[0] sendTime] floatValue] <= self.playTime&&_playState == PLaying) {
            //发送弹幕到View上面
            [self showDanMuLabel:self.prepareDanMu[0]];
            [screenExistDanmuArray addObject:self.prepareDanMu[0]];
            [self.prepareDanMu removeObjectAtIndex:0];
        }
    }
    if (screenExistDanmuArray.count>0&&isCompleteUpdate) {
        [self updateDanMuFrame];
    }
    
    
}

#pragma mark -- 更新播放时间
- (void)updatePlayTime:(CGFloat)playtime
{
    _playTime = playtime;
}
#pragma mark -- 更新弹幕位置和或者消失剩余时间
- (void)updateDanMuFrame
{
    isCompleteUpdate = NO;
   
    
    [screenExistDanmuArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        SZJDanMuModel* model = obj;
        *stop = YES;
        if ([model.danMuType isEqualToString:@"0"]) {
            
            CGRect labelFrame = model.danMuLabel.frame;
            labelFrame.origin.x -= [model.danMuSpeed floatValue]/100;
            model.danMuLabel.frame = labelFrame;
                if (model.danMuLabel.frame.origin.x <= self.bounds.size.width-model.danMuLabel.bounds.size.width && !model.isCompleteShow) {
                model.isCompleteShow = YES;
                
                NSLog(@"有空位置了");
                
                //循环遍历空余位置   判断剩余空位信息
                for (NSDictionary* dic in rightBlankPalceArray)  {
                    if ([dic[@"minY"] floatValue] == CGRectGetMaxY(model.danMuLabel.frame)) {
                        BOOL isFoundOther = NO;
                        NSDictionary* otherDic = nil;
                        for (NSDictionary* dic2 in rightBlankPalceArray) {
                            if ([dic2[@"maxY"] floatValue] == CGRectGetMinY(model.danMuLabel.frame)) {
                                isFoundOther = YES;
                                otherDic = dic2;
                                break;
                            }
                        }
                        if (isFoundOther) {
                            NSDictionary* vaildPlace = @{@"minY":otherDic[@"minY"],@"maxY":dic[@"maxY"]};
                            [rightBlankPalceArray removeObject:dic];
                            [rightBlankPalceArray removeObject:otherDic];
                            [rightBlankPalceArray addObject:vaildPlace];
                            break;
                        }
                    }
                    if ([dic[@"minY"] floatValue] == CGRectGetMaxY(model.danMuLabel.frame)) {
                        
                        NSDictionary* vaildPlace = @{@"minY":@(CGRectGetMinY(model.danMuLabel.frame)),@"maxY":@([dic[@"maxY"] floatValue])};
                        [rightBlankPalceArray removeObject:dic];
                        [rightBlankPalceArray addObject:vaildPlace];
                        break;
                    }
                    else if ([dic[@"maxY"] floatValue] == CGRectGetMinY(model.danMuLabel.frame))
                    {
                        NSDictionary* vaildPlace = @{@"minY":@([dic[@"minY"] floatValue]),@"maxY":@(CGRectGetMaxY(model.danMuLabel.frame))};
                        [rightBlankPalceArray removeObject:dic];
                        [rightBlankPalceArray addObject:vaildPlace];
                        break;
                    }
                    else
                    {
                        NSDictionary* vaildPlace = @{@"minY":@(CGRectGetMinY(model.danMuLabel.frame)),@"maxY":@(CGRectGetMaxY(model.danMuLabel.frame))};
                        [rightBlankPalceArray addObject:vaildPlace];
                        break;
                    }
                }
                    
                    [rightBlankPalceArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                        NSDictionary* dic1 = obj1;
                        NSDictionary* dic2 = obj2;
                        return [dic1[@"minY"] floatValue] - [dic2[@"minY"] floatValue];
                        
                    }];
  
                
            }
            if (CGRectGetMaxX(model.danMuLabel.frame) <= 0) {
                NSLog(@"滚出去拉");
                [screenExistDanmuArray removeObject:model];
                [model.danMuLabel removeFromSuperview];
                
                
            }
            
        }
        else if ([model.danMuType isEqualToString:@"1"])
        {
            model.disappearTime -= 0.001;
            if (model.disappearTime<=0) {
                //循环遍历空余位置   判断剩余空位信息
                for (NSDictionary* dic in topBlankPlaceArray)  {
                    if ([dic[@"minY"] floatValue] == CGRectGetMaxY(model.danMuLabel.frame)) {
                        BOOL isFoundOther = NO;
                        NSDictionary* otherDic = nil;
                        for (NSDictionary* dic2 in topBlankPlaceArray) {
                            if ([dic2[@"maxY"] floatValue] == CGRectGetMinY(model.danMuLabel.frame)) {
                                isFoundOther = YES;
                                otherDic = dic2;
                                break;
                            }
                        }
                        if (isFoundOther) {
                            NSDictionary* vaildPlace = @{@"minY":otherDic[@"minY"],@"maxY":dic[@"maxY"]};
                            [topBlankPlaceArray removeObject:dic];
                            [topBlankPlaceArray removeObject:otherDic];
                            [topBlankPlaceArray addObject:vaildPlace];
                            break;
                        }
                    }
                    if ([dic[@"minY"] floatValue] == CGRectGetMaxY(model.danMuLabel.frame)) {
                        
                        NSDictionary* vaildPlace = @{@"minY":@(CGRectGetMinY(model.danMuLabel.frame)),@"maxY":@([dic[@"maxY"] floatValue])};
                        [topBlankPlaceArray removeObject:dic];
                        [topBlankPlaceArray addObject:vaildPlace];
                        break;
                    }
                    else if ([dic[@"maxY"] floatValue] == CGRectGetMinY(model.danMuLabel.frame))
                    {
                        NSDictionary* vaildPlace = @{@"minY":@([dic[@"minY"] floatValue]),@"maxY":@(CGRectGetMaxY(model.danMuLabel.frame))};
                        [topBlankPlaceArray removeObject:dic];
                        [topBlankPlaceArray addObject:vaildPlace];
                        break;
                    }
                    else
                    {
                        NSDictionary* vaildPlace = @{@"minY":@(CGRectGetMinY(model.danMuLabel.frame)),@"maxY":@(CGRectGetMaxY(model.danMuLabel.frame))};
                        [topBlankPlaceArray addObject:vaildPlace];
                        break;
                    }
                }
                [topBlankPlaceArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                    NSDictionary* dic1 = obj1;
                    NSDictionary* dic2 = obj2;
                    return [dic1[@"minY"] floatValue] - [dic2[@"minY"] floatValue];
                    
                }];

                [screenExistDanmuArray removeObject:model];
                [model.danMuLabel removeFromSuperview];
            }
        }
        else if ([model.danMuType isEqualToString:@"2"])
        {
            model.disappearTime -= 0.001;
            if (model.disappearTime<=0) {
                //循环遍历空余位置   判断剩余空位信息
                for (NSDictionary* dic in bottomBlankPlaceArray)  {
                    if ([dic[@"minY"] floatValue] == CGRectGetMaxY(model.danMuLabel.frame)) {
                        BOOL isFoundOther = NO;
                        NSDictionary* otherDic = nil;
                        for (NSDictionary* dic2 in topBlankPlaceArray) {
                            if ([dic2[@"maxY"] floatValue] == CGRectGetMinY(model.danMuLabel.frame)) {
                                isFoundOther = YES;
                                otherDic = dic2;
                                break;
                            }
                        }
                        if (isFoundOther) {
                            NSDictionary* vaildPlace = @{@"minY":otherDic[@"minY"],@"maxY":dic[@"maxY"]};
                            [bottomBlankPlaceArray removeObject:dic];
                            [bottomBlankPlaceArray removeObject:otherDic];
                            [bottomBlankPlaceArray addObject:vaildPlace];
                            break;
                        }
                    }
                    if ([dic[@"minY"] floatValue] == CGRectGetMaxY(model.danMuLabel.frame)) {
                        
                        NSDictionary* vaildPlace = @{@"minY":@(CGRectGetMinY(model.danMuLabel.frame)),@"maxY":@([dic[@"maxY"] floatValue])};
                        [bottomBlankPlaceArray removeObject:dic];
                        [bottomBlankPlaceArray addObject:vaildPlace];
                        break;
                    }
                    else if ([dic[@"maxY"] floatValue] == CGRectGetMinY(model.danMuLabel.frame))
                    {
                        NSDictionary* vaildPlace = @{@"minY":@([dic[@"minY"] floatValue]),@"maxY":@(CGRectGetMaxY(model.danMuLabel.frame))};
                        [bottomBlankPlaceArray removeObject:dic];
                        [bottomBlankPlaceArray addObject:vaildPlace];
                        break;
                    }
                    else
                    {
                        NSDictionary* vaildPlace = @{@"minY":@(CGRectGetMinY(model.danMuLabel.frame)),@"maxY":@(CGRectGetMaxY(model.danMuLabel.frame))};
                        [bottomBlankPlaceArray addObject:vaildPlace];
                        break;
                    }
                }
                [bottomBlankPlaceArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                    NSDictionary* dic1 = obj1;
                    NSDictionary* dic2 = obj2;
                    return [dic1[@"minY"] floatValue] - [dic2[@"minY"] floatValue];
                    
                }];
                [screenExistDanmuArray removeObject:model];
                [model.danMuLabel removeFromSuperview];
            }
            
        }
        

        *stop = NO;
        
    }];
    isCompleteUpdate = YES;
}


#pragma mark -- 展示弹幕Label
- (void)showDanMuLabel:(SZJDanMuModel *)myModel
{
    SZJDanMuModel* model = myModel;
    //判断弹幕类型
    switch ([[model danMuType] integerValue]) {
            
        case 0:
        {
            //合适的可插入的地方
            NSDictionary* suitPlace;
            //循环遍历可插入区域和Label的高度作比较
            for (NSDictionary* dic in rightBlankPalceArray) {
                //可插入区域高度
                CGFloat placeHeight = [dic[@"maxY"] floatValue] - [dic[@"minY"] floatValue];
                //如果可插入区域比Label高度大  表示可插入
                if (placeHeight >= model.danMuLabel.bounds.size.height) {
                    suitPlace = dic;
                    break;
                }
                
            }
            //如果可插入区域数量大于0并且找到适合Label插入的区域 那么调整Label位置
            if (rightBlankPalceArray.count>0&&suitPlace) {
                //设置弹幕的初始位置
                model.danMuLabel.frame = CGRectMake(self.bounds.size.width,[suitPlace[@"minY"] floatValue], model.danMuLabel.bounds.size.width, model.danMuLabel.bounds.size.height);
                [self addSubview:model.danMuLabel];
               
                //添加新的可插入区域
                NSDictionary* validPlace = @{@"minY":@(CGRectGetMaxY(model.danMuLabel.frame)),@"maxY":@([suitPlace[@"maxY"] floatValue])};
                [rightBlankPalceArray removeObject:suitPlace];
                [rightBlankPalceArray addObject:validPlace];
                [rightBlankPalceArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                    NSDictionary* dic1 = obj1;
                    NSDictionary* dic2 = obj2;
                    return [dic1[@"minY"] floatValue] - [dic2[@"minY"] floatValue];
                    
                }];
                
            }
            //如果没有找到可插入的区域，随机找一个地方插入
            else
            {
                //允许插入的最低区域
                CGFloat maxYPoint = self.bounds.size.height - model.danMuLabel.bounds.size.height;
                model.danMuLabel.frame = CGRectMake(self.bounds.size.width, arc4random()%(int)maxYPoint, model.danMuLabel.bounds.size.width, model.danMuLabel.bounds.size.height);
                [self addSubview:model.danMuLabel];
               
                
            }
        }
            break;
        case 1:
        {
            
            //合适的可插入的地方
            NSDictionary* suitPlace;
            //循环遍历可插入区域和Label的高度作比较
            for (NSDictionary* dic in topBlankPlaceArray) {
                //可插入区域高度
                CGFloat placeHeight = [dic[@"maxY"] floatValue] - [dic[@"minY"] floatValue];
                //如果可插入区域比Label高度大  表示可插入
                if (placeHeight >= model.danMuLabel.bounds.size.height) {
                    suitPlace = dic;
                    break;
                }
                
            }

            //如果可插入区域数量大于0并且找到适合Label插入的区域 那么调整Label位置
            if (topBlankPlaceArray.count>0&&suitPlace) {
                //设置弹幕的初始位置
                model.danMuLabel.frame = CGRectMake(self.bounds.size.width,[suitPlace[@"minY"] floatValue], model.danMuLabel.bounds.size.width, model.danMuLabel.bounds.size.height);
                CGPoint labelPoint = model.danMuLabel.center;
                labelPoint.x = self.bounds.size.width/2;
                model.danMuLabel.center = labelPoint;
                [self addSubview:model.danMuLabel];
                
                //添加新的可插入区域
                NSDictionary* validPlace = @{@"minY":@(CGRectGetMaxY(model.danMuLabel.frame)),@"maxY":@([suitPlace[@"maxY"] floatValue])};
                [topBlankPlaceArray removeObject:suitPlace];
                [topBlankPlaceArray addObject:validPlace];
                [topBlankPlaceArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                    NSDictionary* dic1 = obj1;
                    NSDictionary* dic2 = obj2;
                    return [dic1[@"minY"] floatValue] - [dic2[@"minY"] floatValue];
                    
                }];
                
            }
            //如果没有找到可插入的区域，随机找一个地方插入
            else
            {
                //允许插入的最低区域
                CGFloat maxYPoint = self.bounds.size.height/2 - model.danMuLabel.bounds.size.height;
                model.danMuLabel.frame = CGRectMake(self.bounds.size.width, arc4random()%(int)maxYPoint, model.danMuLabel.bounds.size.width, model.danMuLabel.bounds.size.height);
                CGPoint labelPoint = model.danMuLabel.center;
                labelPoint.x = self.bounds.size.width/2;
                model.danMuLabel.center = labelPoint;
                [self addSubview:model.danMuLabel];
               
                
            }

            
        }
            break;
        case 2:
        {
            //合适的可插入的地方
            NSDictionary* suitPlace;
            //循环遍历可插入区域和Label的高度作比较
            for (NSDictionary* dic in bottomBlankPlaceArray) {
                //可插入区域高度
                CGFloat placeHeight = [dic[@"maxY"] floatValue] - [dic[@"minY"] floatValue];
                //如果可插入区域比Label高度大  表示可插入
                if (placeHeight >= model.danMuLabel.bounds.size.height) {
                    suitPlace = dic;
                    break;
                }
                
            }
            
            //如果可插入区域数量大于0并且找到适合Label插入的区域 那么调整Label位置
            if (bottomBlankPlaceArray.count>0&&suitPlace) {
                //设置弹幕的初始位置
                model.danMuLabel.frame = CGRectMake(self.bounds.size.width,[suitPlace[@"maxY"] floatValue] - model.danMuLabel.bounds.size.height, model.danMuLabel.bounds.size.width, model.danMuLabel.bounds.size.height);
                CGPoint labelPoint = model.danMuLabel.center;
                labelPoint.x = self.bounds.size.width/2;
                model.danMuLabel.center = labelPoint;
                [self addSubview:model.danMuLabel];
                
                //添加新的可插入区域
                NSDictionary* validPlace = @{@"minY":@([suitPlace[@"minY"] floatValue]),@"maxY":@(CGRectGetMinY(model.danMuLabel.frame))};
                [bottomBlankPlaceArray removeObject:suitPlace];
                [bottomBlankPlaceArray addObject:validPlace];
                [bottomBlankPlaceArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                    NSDictionary* dic1 = obj1;
                    NSDictionary* dic2 = obj2;
                    return [dic1[@"minY"] floatValue] - [dic2[@"minY"] floatValue];
                    
                }];
                
            }
            //如果没有找到可插入的区域，随机找一个地方插入
            else
            {
                //允许插入的最高区域
                CGFloat maxYPoint = self.bounds.size.height/2 - model.danMuLabel.bounds.size.height;
                model.danMuLabel.frame = CGRectMake(self.bounds.size.width, arc4random()%(int)maxYPoint+self.bounds.size.height/2, model.danMuLabel.bounds.size.width, model.danMuLabel.bounds.size.height);
                CGPoint labelPoint = model.danMuLabel.center;
                labelPoint.x = self.bounds.size.width/2;
                model.danMuLabel.center = labelPoint;
                [self addSubview:model.danMuLabel];
                
                
            }
            

        }
            break;
        default:
            break;
    }
}


#pragma mark -- 发送弹幕
- (void)sendDanMu:(SZJDanMuModel *)model
{
    [self.prepareDanMu addObject:model];
    [self.prepareDanMu sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        SZJDanMuModel* model1 = obj1;
        SZJDanMuModel* model2 = obj2;
        return [model1.sendTime floatValue] - [model2.sendTime floatValue];
    }];
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
