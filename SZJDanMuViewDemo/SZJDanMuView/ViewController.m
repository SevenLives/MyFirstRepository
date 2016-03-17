//
//  ViewController.m
//  SZJDanMuView
//
//  Created by TimesManager on 16/3/16.
//  Copyright © 2016年 TimesManager. All rights reserved.
//

#import "ViewController.h"
#import "SZJDanMuModel.h"
#import "SZJDanMuView.h"
#import "MBProgressHUD+Add.h"
@interface ViewController ()
{
    NSTimer* playTimer;
    CGFloat playTime;
    SZJDanMuView* danMuView;
    NSArray* colorArray;
    NSArray* contextArray;
    UITextField* danMuTextField;
    UIButton* extFullScreen;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    
    
   
    //测试颜色数据
    colorArray = @[@"fd404b",@"35a8fe",@"fc8834",@"5b62fb",@"ffb12e",@"fc40ea",@"05b6ad",@"03b04f",@"fcd73b",@"b531fc"];

    //创建发送弹幕按钮
    UIButton* sendDanMu = [UIButton buttonWithType:UIButtonTypeCustom];
    sendDanMu.frame = CGRectMake(self.view.bounds.size.width-100, 350, 100, 50);
    [sendDanMu setTitle:@"发送弹幕" forState:UIControlStateNormal];
    [sendDanMu setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [sendDanMu addTarget:self action:@selector(sendDanMu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendDanMu];
    //创建textfield
    danMuTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 350, self.view.bounds.size.width-130, 50)];
    danMuTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:danMuTextField];
    //创建暂停播放按钮
    UIButton* pausePlay = [UIButton buttonWithType:UIButtonTypeCustom];
    pausePlay.frame = CGRectMake(self.view.bounds.size.width-100, 400, 100, 50);
    [pausePlay setTitle:@"暂停视频" forState:UIControlStateNormal];
    [pausePlay setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [pausePlay addTarget:self action:@selector(pausePlay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pausePlay];
    //创建开始播放按钮
    UIButton* startPlay = [UIButton buttonWithType:UIButtonTypeCustom];
    startPlay.frame = CGRectMake(self.view.bounds.size.width-100, 450, 100, 50);
    [startPlay setTitle:@"视频开始" forState:UIControlStateNormal];
    [startPlay setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [startPlay addTarget:self action:@selector(startPlay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startPlay];
    //创建全屏按钮
    UIButton* fullScreen = [UIButton buttonWithType:UIButtonTypeCustom];
    fullScreen.frame = CGRectMake(self.view.bounds.size.width-100, 500, 100, 50);
    [fullScreen setTitle:@"全屏" forState:UIControlStateNormal];
    [fullScreen setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [fullScreen addTarget:self action:@selector(fullScreen) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fullScreen];
    //创建退出全屏按钮
    extFullScreen = [UIButton buttonWithType:UIButtonTypeCustom];
   
    [extFullScreen setTitle:@"全屏" forState:UIControlStateNormal];
    [extFullScreen setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [extFullScreen addTarget:self action:@selector(extFullScreen) forControlEvents:UIControlEventTouchUpInside];
   

    //测试文字数据
    contextArray = @[@"23333333",@"测试弹幕~~~~",@"Seven志坚倾力打造",@"做得不好不要喷",@"将就着用吧",@"反正就是做着玩玩",@"德玛西亚!!!",@"不要喷我啊，我只是渣渣技术~~~",@"好用的话给个好评哟!!",@"这么长的名字躲在草丛里会不会被看见"];
    //创建测试预备数组
    NSMutableArray* testArray = [NSMutableArray array];
    //添加200个测试弹幕数据
    for (NSUInteger i = 0; i<200; i++) {
           SZJDanMuModel* model = [[SZJDanMuModel alloc] initWithAttributes:@{@"speed":[NSString stringWithFormat:@"%d",arc4random()%4+5],@"context":contextArray[arc4random()%10],@"textColor":colorArray[arc4random()%10],@"type":[NSString stringWithFormat:@"%d",arc4random()%3],@"senderId":@"123",@"sendTime":[NSString stringWithFormat:@"%d",arc4random()%180],@"textFont":[NSString stringWithFormat:@"%d",arc4random()%5+14],@"disappearTime":[NSString stringWithFormat:@"%d",arc4random()%3+2]}];
        [testArray addObject:model];
    }
    //用预备弹幕数组创建弹幕View
    danMuView = [[SZJDanMuView alloc] initPrepareDanMu:testArray WithFrame: CGRectMake(0, 100, self.view.bounds.size.width,200)];
    [danMuView addSubview:extFullScreen];
    extFullScreen.hidden = YES;
    [self.view addSubview:danMuView];
   
    
}

#pragma mark -- 每0.1秒更新一次视频播放时间
- (void)onTime
{
    playTime += 0.1;
    [danMuView updatePlayTime:playTime];
}

#pragma mark -- 发送弹幕
- (void)sendDanMu
{
   
    NSString* str = danMuTextField.text;
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    if (str.length>0) {
        //创建弹幕Model
        danMuTextField.text = @"";
        SZJDanMuModel* model = [[SZJDanMuModel alloc] initWithAttributes:@{@"speed":[NSString stringWithFormat:@"%d",arc4random()%4+5],@"context":str,@"textColor":colorArray[arc4random()%10],@"type":[NSString stringWithFormat:@"%d",arc4random()%3],@"senderId":@"213",@"sendTime":[NSString stringWithFormat:@"%f",playTime],@"textFont":[NSString stringWithFormat:@"%d",arc4random()%5+14],@"disappearTime":[NSString stringWithFormat:@"%d",arc4random()%3+2]}];
        //发送弹幕
        [danMuView sendDanMu:model];

    }
    else
    {
        [MBProgressHUD showError:@"不能发送空的弹幕哟~~" toView:nil];
        
    }
   
}

#pragma mark -- 暂停播放
- (void)pausePlay
{
    //暂停视频
    if (danMuView.playState == PLaying) {
        [playTimer invalidate];
        playTimer = nil;
        //暂停弹幕
        [danMuView pausePlay];
    }
  
}

#pragma mark -- 开始播放

- (void)startPlay
{
    if (danMuView.playState == Stop) {
        playTime = 0;
    }
    //开始播放视频
    playTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(onTime) userInfo:nil repeats:YES];
    [playTimer fire];
    //开始播放弹幕
    [danMuView startPlay];
}

#pragma mark -- 全屏播放

- (void)fullScreen
{
    
   [[UIDevice currentDevice] setValue:[NSNumber numberWithInt:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        danMuView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
    } completion:^(BOOL finished) {
         extFullScreen.frame = CGRectMake(danMuView.bounds.size.width-100, danMuView.bounds.size.height-50, 100, 50);
        extFullScreen.hidden = NO;
    }];
}

#pragma mark -- 退出全屏
- (void)extFullScreen
{
    extFullScreen.hidden = YES;
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInt:UIDeviceOrientationPortrait] forKey:@"orientation"];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        danMuView.frame = CGRectMake(0, 100, self.view.bounds.size.width,200);
        
    } completion:^(BOOL finished) {
       
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
