//
//  VoiceRoomChatMsgModel.h
//  ChatRoomMsgViewDemo
//
//  Created by ztp on 2021/10/15.
//

#import <Foundation/Foundation.h>
#import "VoiceRoomChatUserModel.h"
#import "VoiceRoomChatAttributeModel.h"
#import "VoiceRoomChatGiftModel.h"


NS_ASSUME_NONNULL_BEGIN
/** 消息子类型*/
typedef NS_ENUM(NSInteger, VoiceRoomMsgType) {
    /////////// 直播间事件 ///////////
    ///普通进场
    VoiceRoomMsgType_MemberEnter        = 101,
    ///特殊进场
    VoiceRoomMsgType_MemberSpecialEnter = 102,
    ///关注,订阅
    VoiceRoomMsgType_Subscription       = 103,
    ///普通文本
    VoiceRoomMsgType_Member_Comment     = 104,
    ///礼物消息
    VoiceRoomMsgType_Gift_Text          = 105,
    ///开通守护
    VoiceRoomMsgType_Guard              = 106,
    ///厅主升级
    VoiceRoomMsgType_Manager_Promotion  = 107,
    ///普通用户升级
    VoiceRoomMsgType_Member_Promotion   = 108,
    ///踢出直播间
    VoiceRoomMsgType_KickOut            = 109,
    ///禁言
    VoiceRoomMsgType_Forbidden          = 110,
    ///主持人上麦
    VoiceRoomMsgType_Host_Sitting       = 111,
    ///寻宝中奖
    VoiceRoomMsgType_Win_Xunbao         = 112,
    ///刮奖中奖
    VoiceRoomMsgType_Win_Guajiang       = 113,
    ///幸运中奖
    VoiceRoomMsgType_Win_Lucky          = 114,
    ///纸牌中奖
    VoiceRoomMsgType_Win_Zhipai         = 115,
    ///纸牌能量球
    VoiceRoomMsgType_Power_Zhipai       = 116,
    ///系统公告信息
    VoiceRoomMsgType_System_msg         = 117,
    //以下为待扩展类型
    
//    /// 当用户直播间里发起分享时
//    VoiceRoomMsgType_Share              = 118,
//    /// @他人
//    VoiceRoomMsgType_At                 = 119,
//    ///未知类型
//    VoiceRoomMsgType_Unknown            = 999,

};

@interface VoiceRoomChatMsgModel : NSObject

/// 直播间文本内容
@property (nonatomic, copy) NSString *content;
// 礼物数量
@property (nonatomic, copy) NSString *quantity;

@property (nonatomic, copy) NSString *msgID;

@property (nonatomic, copy) NSString *GuardName;//守护代号名字


@property (nonatomic, assign) VoiceRoomMsgType subType;

/// 被踢出的用户
@property (nonatomic, strong) VoiceRoomChatUserModel *KickOutUser;
/// 被@的用户
@property (nonatomic, strong) VoiceRoomChatUserModel *atUser;

@property (nonatomic, strong) VoiceRoomChatUserModel *user;
/// 接收礼物的用户
@property (nonatomic, strong) VoiceRoomChatUserModel *receivedUser;

@property (nonatomic, strong) VoiceRoomChatGiftModel *giftModel;

/// 数据逻辑处理模型
@property (nonatomic, strong) VoiceRoomChatAttributeModel *attributeModel;


- (void)initMsgAttribute;

@end

NS_ASSUME_NONNULL_END
