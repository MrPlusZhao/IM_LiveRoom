//
//  TXVoiceRoomMsgBaseCell.h
//  ChatRoomMsgViewDemo
//
//  Created by ztp on 2021/10/14.
//

#import <UIKit/UIKit.h>
#import "VoiceRoomChatMsgModel.h"
#import <YYText/YYText.h>
#import "VoiceRoomChatUserModel.h"


#define NDViewRadius(view, rads)\
\
view.layer.cornerRadius = rads;\
view.layer.masksToBounds = YES;


#define RGBA_OF(rgbValue)   [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define RGBAOF(rgbValue, alphas)   [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphas]


NS_ASSUME_NONNULL_BEGIN

@protocol VoiceRoomMsgBaseCellGesDelegate <NSObject>

- (void)longPressGes:(VoiceRoomChatMsgModel *)MsgModel;
- (void)userClick:(VoiceRoomChatUserModel *)user;
- (void)touchMsgCellView;

// 提示关注 分享 送礼物点击
- (void)remindCellFollow:(VoiceRoomChatMsgModel *)msgModel;
- (void)remindCellShare;
- (void)remindCellGifts;

/** 消息属性文字发生变化（更新对应cell） */
- (void)msgAttrbuiteUpdated:(VoiceRoomChatMsgModel *)msgModel;

@end

@interface TXVoiceRoomMsgBaseCell : UITableViewCell


@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) YYLabel     *msgLabel;
@property (nonatomic, weak) id<VoiceRoomMsgBaseCellGesDelegate> delegate;

@property (nonatomic, strong) VoiceRoomChatMsgModel *msgModel;


+ (TXVoiceRoomMsgBaseCell *)tableView:(UITableView *)tableView cellForMsg:(VoiceRoomChatMsgModel *)msg indexPath:(NSIndexPath *)indexPath delegate:(id<VoiceRoomMsgBaseCellGesDelegate>)delegate;

// 添加长按点击事件
- (void)addLongPressGes;
/** cell标示 */
+ (NSString *)msgCellIdentifier;

@end

NS_ASSUME_NONNULL_END
