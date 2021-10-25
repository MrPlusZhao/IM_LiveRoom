//
//  VoiceRoomChatAttributeModel.h
//  ChatRoomMsgViewDemo
//
//  Created by ztp on 2021/10/15.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



@class VoiceRoomChatMsgModel;
@class VoiceRoomChatAttributeModel;

#define MsgTableViewWidth     288
#define MsgTableViewHeight    300

#define WeakSelf                      __weak typeof(self) weakSelf = self;

#define RGBA_OF(rgbValue)   [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define RGBAOF(rgbValue, alphas)   [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphas]


#define Lable_LeftSpace 20
#define Lable_RightSpace 10
#define Lable_TopSpace 8
#define Lable_BomSpace 4

#define BG_LeftSpace 10
#define BG_RightSpace 10
#define BG_TopSpace 4
#define BG_BomSpace 0



// cell之间的间距
#define CellLineSpacing      16
// 图片的Y轴
#define iconTopY             1.0

// 字体大小
#define MSG_LABEL_FONT  14
//#define MSG_LABEL_FONT  __Font(14)
// cell间距
#define cellLineSpeing  3

// 背景颜色 黑色 透明度0.24
#define NormalBgColor   RGBAOF(0x000000, 0.24)
// 关注背景颜色 - 红
#define RemindBgColor1  RGBA_OF(0xFF4989)
// 喜欢背景颜色 - 紫
#define RemindBgColor2  RGBA_OF(0xCA53FF)
// 分享背景颜色 - 蓝
#define RemindBgColor3  RGBA_OF(0x4ABEFF)
// 主颜色 - 黄色
#define MsgLbColor          RGBA_OF(0xFFF7AA)
// 内容颜色
#define MsgTitleColor       RGBA_OF(0xFFFFFF)
// 名字颜色
#define MsgNameColor        RGBAOF(0xFFFFFF, 0.85)

NS_ASSUME_NONNULL_BEGIN

@protocol VoiceRoomChatAttributeModelDelegate <NSObject>
/** 属性文字刷新后调用 */
- (void)attributeUpdated:(VoiceRoomChatAttributeModel *)model;

@optional
// 富文本点击
- (void)msgAttributeTapAction:(NSString*)content;

@end


@interface VoiceRoomChatAttributeModel : NSObject

@property (nonatomic, weak) VoiceRoomChatMsgModel *msgModel;

@property (nonatomic, weak) id<VoiceRoomChatAttributeModelDelegate> delegate;
// 消息高度
@property (nonatomic, assign) CGFloat msgHeight;
// 消息宽度
@property (nonatomic, assign) CGFloat msgWidth;

@property (nonatomic, strong) NSMutableAttributedString *msgAttribText;
@property (nonatomic, strong) UIColor *msgColor;
@property (nonatomic, strong) UIColor *bgColor;

/** 初始化是会计算属性 */
- (instancetype)initWithMsgModel:(VoiceRoomChatMsgModel *)msgModel;

/** 重新计算属性 */
- (void)msgUpdateAttribute;

@end

NS_ASSUME_NONNULL_END
