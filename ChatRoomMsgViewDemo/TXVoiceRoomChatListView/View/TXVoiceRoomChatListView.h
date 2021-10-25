//
//  TXVoiceRoomChatListView.h
//  ChatRoomMsgViewDemo
//
//  Created by ztp on 2021/10/14.
//

#import <UIKit/UIKit.h>
#import "VoiceRoomChatMsgModel.h"
#import "TIMKeyboardToolBarView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol VoiceRoomMsgListDelegate <NSObject>

@optional
- (void)startScroll;
- (void)endScroll;
- (void)touchSelfView;

// 提示关注 分享 送礼物点击
- (void)didRemindFollowComplete:(void(^)(BOOL))complete;
- (void)didRemindShare;
- (void)didRemindGifts;
- (void)didCopyWithText:(NSString *)text;

@end

@interface TXVoiceRoomChatListView : UIView

@property (nonatomic, strong) TIMKeyboardToolBarView *toolBar;
//- (void)show;
/** 消息列表 */
@property (nonatomic, strong) UITableView *tableView;

//清空消息重置
- (void)reset;
- (void)startTimer;

@property (nonatomic, weak) id<VoiceRoomMsgListDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
