# SZJDanMuView

导入#import "SZJDanMuModel.h"

 //用预备弹幕数组创建弹幕View  如果没有预备弹幕可以传空;
 
- // SZJDanMuView* danMuView = [[SZJDanMuView alloc] initPrepareDanMu:testArray WithFrame: CGRectMake(0, 100, self.view.bounds.size.width,200)];
 
-/**
- *  开始播放弹幕
- */
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
/**
 *  弹幕模型初始化
 *
 *  @param attributes 初始化相关设置
 *
 *  @return 弹幕实例化
 */
- (instancetype)initWithAttributes:(NSDictionary *)attributes; 
- 用字典设置弹幕属性;
--//弹幕内容;
--@property (nonatomic, copy) NSString* danMuText;
--//弹幕字体大小;
--@property (nonatomic, copy) NSString* danMuTextFont;
--//弹幕字体颜色;
--@property (nonatomic, copy) NSString* danMuTextColor;
--//弹幕发射速度;
@property (nonatomic, copy) NSString* danMuSpeed;
//弹幕类型 0：从左到右滚动 1：顶部  2：底部
@property (nonatomic, copy) NSString* danMuType;
//弹幕发送者ID;
@property (nonatomic, copy) NSString* senderId;
//弹幕发送时间 单位(毫秒);
@property (nonatomic, copy) NSString* sendTime;
//顶部/底部弹幕消失时间;
@property (nonatomic, assign) CGFloat disappearTime;





