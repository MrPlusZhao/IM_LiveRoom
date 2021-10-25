//
//  VoiceRoomChatAttributeModel.m
//  ChatRoomMsgViewDemo
//
//  Created by ztp on 2021/10/15.
//

#import "VoiceRoomChatAttributeModel.h"
#import "VoiceRoomChatMsgModel.h"
#import <YYText/YYText.h>
#import "TPImageManager.h"
#import "VoiceRoomChatGiftModel.h"
#import <SDWebImage/SDWebImageManager.h>

@interface VoiceRoomChatAttributeModel ()

@property (nonatomic, strong) UIFont *font;
/// 附件图片
@property (nonatomic, strong) NSArray<id> *tipImages;
/// 附件图片下载结束
@property (nonatomic, assign) BOOL finishDownloadTipImg;
/// 礼物缩略图
@property (nonatomic, strong) UIImage *giftImage;
/// 礼物缩略图下载结束
@property (nonatomic, assign) BOOL finishDownloadGiftImg;


///////////////////////////////// 附加属性 /////////////////////////////////
/** SDwebImage的所有请求 */
@property (nonatomic, strong) NSMutableArray *tempLoads;

@end

@implementation VoiceRoomChatAttributeModel


- (instancetype)init {
    if (self = [super init]) {
        self.msgColor = MsgLbColor;
        self.bgColor = NormalBgColor;
        self.font = [UIFont boldSystemFontOfSize:MSG_LABEL_FONT];
        self.tempLoads = [NSMutableArray array];
    }
    return self;
}

- (instancetype)initWithMsgModel:(VoiceRoomChatMsgModel *)msgModel {
    if (self = [self init]) {
        self.msgModel = msgModel;
        [self msgUpdateAttribute];
    }
    return self;
}

/** 重新计算属性 */
- (void)msgUpdateAttribute {
    [self getAttributedStringFromSelf];
}

- (void)getAttributedStringFromSelf {
    
    switch (self.msgModel.subType) {
        case VoiceRoomMsgType_Member_Comment: { // 普通消息
            // 下载标签图片
            [self downloadTagImage];
            self.bgColor = NormalBgColor;
            [self Comment];
        }
            break;
        case VoiceRoomMsgType_System_msg: { // 系统消息
            self.bgColor = NormalBgColor;
            [self systemMsg];
        }
            break;
        case VoiceRoomMsgType_MemberEnter: { // 用户进入直播间
            // 下载标签图片
            [self downloadTagImage];
            self.bgColor = NormalBgColor;
            [self MemberEnter];
        }
            break;
        case VoiceRoomMsgType_MemberSpecialEnter: { // 用户进入直播间
            // 下载标签图片
            [self downloadTagImage];
            self.bgColor = NormalBgColor;
            [self MemberEnter];
        }
            break;
        case VoiceRoomMsgType_Subscription: { // 关注
            // 下载标签图片
            [self downloadTagImage];
            self.bgColor = NormalBgColor;
            [self Subscription];
        }
            break;
        case VoiceRoomMsgType_Gift_Text: {   // 礼物弹幕(文本)消息
            // 下载标签图片
            [self downloadTagImage];
            // 下载礼物图片
            [self downloadGiftImage];
            self.bgColor = NormalBgColor;
            [self Gift_Text];
        }
            break;
        case VoiceRoomMsgType_Guard: {   // 开通守护
            // 下载标签图片
            [self downloadTagImage];
            self.bgColor = NormalBgColor;
            [self Type_Guard];
        }
            break;
        case VoiceRoomMsgType_Manager_Promotion: {   // 主播升级
            // 下载标签图片
            [self downloadTagImage];
            self.bgColor = NormalBgColor;
            [self Manager_Promotion];
        }
            break;
        case VoiceRoomMsgType_Member_Promotion: {   // 用户升级
            // 下载标签图片
            [self downloadTagImage];
            self.bgColor = NormalBgColor;
            [self Member_Promotion];
        }
            break;
        case VoiceRoomMsgType_KickOut: {   // 踢人
            // 下载标签图片
            self.bgColor = NormalBgColor;
            [self KickOut];
        }
            break;
        case VoiceRoomMsgType_Forbidden: {   // 禁言
            // 下载标签图片
            self.bgColor = NormalBgColor;
            [self Forbidden];
        }
            break;
        case VoiceRoomMsgType_Host_Sitting: {   // 支持人上麦
            // 下载标签图片
            self.bgColor = NormalBgColor;
            [self Host_Sitting];
        }
            break;
        case VoiceRoomMsgType_Win_Xunbao: {   // 寻宝中奖
            // 下载标签图片
            self.bgColor = NormalBgColor;
            [self Win_Xunbao];
        }
            break;
        case VoiceRoomMsgType_Win_Guajiang: {   // 刮奖中奖
            // 下载标签图片
            self.bgColor = NormalBgColor;
            [self Win_Guajiang];
        }
            break;
        case VoiceRoomMsgType_Win_Zhipai: {   // 纸牌中奖
            // 下载标签图片
            self.bgColor = NormalBgColor;
            [self Win_Zhipai];
        }
            break;
        case VoiceRoomMsgType_Power_Zhipai: {   // 纸牌屋能量球
            // 下载标签图片
            self.bgColor = NormalBgColor;
            [self Power_Zhipai];
        }
            break;
        case VoiceRoomMsgType_Win_Lucky: {   // 幸运礼物
            // 下载标签图片
            self.bgColor = NormalBgColor;
            [self Win_Lucky];
        }
            break;
            
        default:
            [self downloadTagImage];
            self.bgColor = NormalBgColor;
            [self Comment];
            break;
    }
}
/// 幸运奖
- (void)Win_Lucky{
    
    NSMutableAttributedString *textView = [[NSMutableAttributedString alloc] initWithString:@""];
    NSMutableAttributedString *system = [self getAttributed:[NSString stringWithFormat:@"%@：", @"系统消息"] font:self.font color:UIColor.yellowColor tap:NO shadow:YES];
    [textView appendAttributedString:system];
    
    NSMutableAttributedString *gongxi = [self getAttributed:[NSString stringWithFormat:@"%@", @"恭喜 "] font:self.font color:UIColor.whiteColor tap:NO shadow:YES];
    [textView appendAttributedString:gongxi];

    NSMutableAttributedString *nameAttribute = [self getAttributed:[NSString stringWithFormat:@"%@", self.msgModel.user.nickName] font:self.font color:UIColor.yellowColor tap:YES shadow:NO];
    [textView appendAttributedString:nameAttribute];
    
    NSMutableAttributedString *systemString = [self getAttributed:[NSString stringWithFormat:@" %@", @"触发了幸运礼物"] font:self.font color:UIColor.whiteColor tap:NO shadow:YES];
    [textView appendAttributedString:systemString];
    
    NSMutableAttributedString *geshu = [self getAttributed:[NSString stringWithFormat:@" %@", @"2"] font:self.font color:UIColor.cyanColor tap:NO shadow:YES];
    [textView appendAttributedString:geshu];
    
    NSMutableAttributedString *jiangpin = [self getAttributed:[NSString stringWithFormat:@" %@", @"倍返奖！"] font:self.font color:UIColor.orangeColor tap:NO shadow:YES];
    [textView appendAttributedString:jiangpin];
    
    NSMutableParagraphStyle *paraStyle = [self paragraphStyle];
    paraStyle.lineSpacing = 3.0f;//行间距
    textView.yy_paragraphStyle = paraStyle;
    self.msgAttribText = textView;
    [self YYTextLayoutSize:self.msgAttribText];
}
- (void)Power_Zhipai{
    NSMutableParagraphStyle *paraStyle = [self paragraphStyle];
    paraStyle.lineSpacing = 3.0f;//行间距
    NSMutableAttributedString *textView = [[NSMutableAttributedString alloc] initWithString:@""];
    NSMutableAttributedString *system = [self getAttributed:[NSString stringWithFormat:@"%@：", @"系统消息"] font:self.font color:UIColor.yellowColor tap:NO shadow:YES];
    [textView appendAttributedString:system];
    
    NSMutableAttributedString *gongxi = [self getAttributed:[NSString stringWithFormat:@"%@", @"恭喜 "] font:self.font color:UIColor.whiteColor tap:NO shadow:YES];
    [textView appendAttributedString:gongxi];

    NSMutableAttributedString *nameAttribute = [self getAttributed:[NSString stringWithFormat:@"%@", self.msgModel.user.nickName] font:self.font color:UIColor.yellowColor tap:YES shadow:NO];
    [textView appendAttributedString:nameAttribute];
    
    NSMutableAttributedString *systemString = [self getAttributed:[NSString stringWithFormat:@" %@", @"成功蓄满了纸牌屋能量球，获得了"] font:self.font color:UIColor.whiteColor tap:NO shadow:YES];
    [textView appendAttributedString:systemString];
    
    NSMutableAttributedString *jiangpin = [self getAttributed:[NSString stringWithFormat:@" %@", @"大火箭🚀"] font:self.font color:UIColor.orangeColor tap:NO shadow:YES];
    [textView appendAttributedString:jiangpin];
    
    
    textView.yy_paragraphStyle = paraStyle;
    self.msgAttribText = textView;
    [self YYTextLayoutSize:self.msgAttribText];
}
- (void)Win_Zhipai{
    NSMutableParagraphStyle *paraStyle = [self paragraphStyle];
    paraStyle.lineSpacing = 3.0f;//行间距
    NSMutableAttributedString *textView = [[NSMutableAttributedString alloc] initWithString:@""];
    NSMutableAttributedString *system = [self getAttributed:[NSString stringWithFormat:@"%@：", @"系统消息"] font:self.font color:UIColor.yellowColor tap:NO shadow:YES];
    [textView appendAttributedString:system];
    
    NSMutableAttributedString *gongxi = [self getAttributed:[NSString stringWithFormat:@"%@", @"恭喜 "] font:self.font color:UIColor.whiteColor tap:NO shadow:YES];
    [textView appendAttributedString:gongxi];

    NSMutableAttributedString *nameAttribute = [self getAttributed:[NSString stringWithFormat:@"%@", self.msgModel.user.nickName] font:self.font color:UIColor.yellowColor tap:YES shadow:NO];
    [textView appendAttributedString:nameAttribute];
    
    NSMutableAttributedString *systemString = [self getAttributed:[NSString stringWithFormat:@" %@", @"在纸牌屋内翻出了"] font:self.font color:UIColor.whiteColor tap:NO shadow:YES];
    [textView appendAttributedString:systemString];
    
    NSMutableAttributedString *geshu = [self getAttributed:[NSString stringWithFormat:@" %@个", @"666"] font:self.font color:UIColor.cyanColor tap:NO shadow:YES];
    [textView appendAttributedString:geshu];
    
    NSMutableAttributedString *jiangpin = [self getAttributed:[NSString stringWithFormat:@" %@", @"流星雨🌟"] font:self.font color:UIColor.orangeColor tap:NO shadow:YES];
    [textView appendAttributedString:jiangpin];
    
    
    textView.yy_paragraphStyle = paraStyle;
    self.msgAttribText = textView;
    [self YYTextLayoutSize:self.msgAttribText];
}
- (void)Win_Guajiang{
    NSMutableParagraphStyle *paraStyle = [self paragraphStyle];
    paraStyle.lineSpacing = 3.0f;//行间距
    NSMutableAttributedString *textView = [[NSMutableAttributedString alloc] initWithString:@""];
    NSMutableAttributedString *system = [self getAttributed:[NSString stringWithFormat:@"%@：", @"系统消息"] font:self.font color:UIColor.yellowColor tap:NO shadow:YES];
    [textView appendAttributedString:system];

    NSMutableAttributedString *nameAttribute = [self getAttributed:[NSString stringWithFormat:@" %@", self.msgModel.user.nickName] font:self.font color:UIColor.yellowColor tap:YES shadow:NO];
    [textView appendAttributedString:nameAttribute];
    
    NSMutableAttributedString *systemString = [self getAttributed:[NSString stringWithFormat:@" %@", @"在本直播间参与"] font:self.font color:UIColor.whiteColor tap:NO shadow:YES];
    [textView appendAttributedString:systemString];
    
    //宝箱名字
    NSMutableAttributedString *baoxiang = [self getAttributed:[NSString stringWithFormat:@" %@", @"银河盘刮奖"] font:self.font color:UIColor.whiteColor tap:NO shadow:YES];
    [textView appendAttributedString:baoxiang];
    
    NSMutableAttributedString *huode = [self getAttributed:[NSString stringWithFormat:@" %@", @"获得"] font:self.font color:UIColor.whiteColor tap:NO shadow:YES];
    [textView appendAttributedString:huode];
    
    NSMutableAttributedString *geshu = [self getAttributed:[NSString stringWithFormat:@" %@个", @"188"] font:self.font color:UIColor.cyanColor tap:NO shadow:YES];
    [textView appendAttributedString:geshu];
    
    NSMutableAttributedString *jiangpin = [self getAttributed:[NSString stringWithFormat:@" %@", @"跑车🚙"] font:self.font color:UIColor.orangeColor tap:NO shadow:YES];
    [textView appendAttributedString:jiangpin];
    
    
    textView.yy_paragraphStyle = paraStyle;
    self.msgAttribText = textView;
    [self YYTextLayoutSize:self.msgAttribText];
}
- (void)Win_Xunbao{
    NSMutableParagraphStyle *paraStyle = [self paragraphStyle];
    paraStyle.lineSpacing = 3.0f;//行间距
    NSMutableAttributedString *textView = [[NSMutableAttributedString alloc] initWithString:@""];
    NSMutableAttributedString *system = [self getAttributed:[NSString stringWithFormat:@"%@：", @"系统消息"] font:self.font color:UIColor.yellowColor tap:NO shadow:YES];
    [textView appendAttributedString:system];

    NSMutableAttributedString *nameAttribute = [self getAttributed:[NSString stringWithFormat:@" %@", self.msgModel.user.nickName] font:self.font color:UIColor.yellowColor tap:YES shadow:NO];
    [textView appendAttributedString:nameAttribute];
    
    NSMutableAttributedString *systemString = [self getAttributed:[NSString stringWithFormat:@" %@", @"在本直播间开启"] font:self.font color:UIColor.whiteColor tap:NO shadow:YES];
    [textView appendAttributedString:systemString];
    
    //宝箱名字
    NSMutableAttributedString *baoxiang = [self getAttributed:[NSString stringWithFormat:@" %@", @"白银宝箱"] font:self.font color:UIColor.redColor tap:NO shadow:YES];
    [textView appendAttributedString:baoxiang];
    
    NSMutableAttributedString *huode = [self getAttributed:[NSString stringWithFormat:@" %@", @"获得"] font:self.font color:UIColor.whiteColor tap:NO shadow:YES];
    [textView appendAttributedString:huode];
    
    NSMutableAttributedString *geshu = [self getAttributed:[NSString stringWithFormat:@" %@个", @"18"] font:self.font color:UIColor.cyanColor tap:NO shadow:YES];
    [textView appendAttributedString:geshu];
    
    NSMutableAttributedString *jiangpin = [self getAttributed:[NSString stringWithFormat:@" %@", @"跑车🚙"] font:self.font color:UIColor.orangeColor tap:NO shadow:YES];
    [textView appendAttributedString:jiangpin];
    
    
    textView.yy_paragraphStyle = paraStyle;
    self.msgAttribText = textView;
    [self YYTextLayoutSize:self.msgAttribText];
}
- (void)Host_Sitting{
    NSMutableParagraphStyle *paraStyle = [self paragraphStyle];
    paraStyle.lineSpacing = 3.0f;//行间距
    NSMutableAttributedString *textView = [[NSMutableAttributedString alloc] initWithString:@""];
    NSMutableAttributedString *system = [self getAttributed:[NSString stringWithFormat:@"%@", @"主持人"] font:self.font color:UIColor.whiteColor tap:NO shadow:YES];
    [textView appendAttributedString:system];

    NSMutableAttributedString *nameAttribute = [self getAttributed:[NSString stringWithFormat:@" %@", self.msgModel.user.nickName] font:self.font color:UIColor.yellowColor tap:YES shadow:NO];
    [textView appendAttributedString:nameAttribute];
    
    NSMutableAttributedString *systemString = [self getAttributed:[NSString stringWithFormat:@" %@", @"上麦了，大家掌声鼓励~"] font:self.font color:UIColor.whiteColor tap:NO shadow:YES];
    [textView appendAttributedString:systemString];
    
    textView.yy_paragraphStyle = paraStyle;
    self.msgAttribText = textView;
    [self YYTextLayoutSize:self.msgAttribText];
}
- (void)Forbidden{
    NSMutableParagraphStyle *paraStyle = [self paragraphStyle];
    paraStyle.lineSpacing = 3.0f;//行间距
    NSMutableAttributedString *textView = [[NSMutableAttributedString alloc] initWithString:@""];
    NSMutableAttributedString *nameAttribute = [self getAttributed:[NSString stringWithFormat:@"%@", self.msgModel.KickOutUser.nickName] font:self.font color:UIColor.whiteColor tap:YES shadow:YES];
    [textView appendAttributedString:nameAttribute];
    NSMutableAttributedString *systemString = [self getAttributed:[NSString stringWithFormat:@" %@", @"被管理员 禁言了10分钟"] font:self.font color:UIColor.whiteColor tap:NO shadow:YES];
    [textView appendAttributedString:systemString];
    textView.yy_paragraphStyle = paraStyle;
    self.msgAttribText = textView;
    [self YYTextLayoutSize:self.msgAttribText];
}
- (void)KickOut{
    NSMutableParagraphStyle *paraStyle = [self paragraphStyle];
    paraStyle.lineSpacing = 3.0f;//行间距
    NSMutableAttributedString *textView = [[NSMutableAttributedString alloc] initWithString:@""];
    NSMutableAttributedString *nameAttribute = [self getAttributed:[NSString stringWithFormat:@"%@", self.msgModel.KickOutUser.nickName] font:self.font color:UIColor.whiteColor tap:YES shadow:YES];
    [textView appendAttributedString:nameAttribute];
    NSMutableAttributedString *systemString = [self getAttributed:[NSString stringWithFormat:@" %@", @"被管理员 踢出了直播间"] font:self.font color:UIColor.whiteColor tap:NO shadow:YES];
    [textView appendAttributedString:systemString];
    textView.yy_paragraphStyle = paraStyle;
    self.msgAttribText = textView;
    [self YYTextLayoutSize:self.msgAttribText];
}
- (void)Member_Promotion{
    NSMutableParagraphStyle *paraStyle = [self paragraphStyle];
    paraStyle.lineSpacing = 3.0f;//行间距
    NSMutableAttributedString *textView = [[NSMutableAttributedString alloc] initWithString:@""];
    // 恭喜
    NSMutableAttributedString *gongxiString = [self getAttributed:[NSString stringWithFormat:@"%@ ", @"恭喜"] font:self.font color:UIColor.redColor tap:NO shadow:YES];
    [textView appendAttributedString:gongxiString];
    //名字
    NSMutableAttributedString *nameAttribute = [self getAttributed:[NSString stringWithFormat:@"%@：", self.msgModel.user.nickName] font:self.font color:MsgLbColor tap:YES shadow:YES];
    [textView appendAttributedString:nameAttribute];
    
    // 等级
    NSMutableAttributedString *level = [self getAttachText:[[TPImageManager sharedInstance] imageForLevel:self.msgModel.user.level] tap:NO];
    [textView appendAttributedString:level];
    [textView appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
        /**徽章*/
    [self addTipImage:textView];
    // 成功升级，再接再厉噢~
    NSMutableAttributedString *chengweiString = [self getAttributed:[NSString stringWithFormat:@"%@ ", @"成功升级，再接再厉噢~"] font:self.font color:UIColor.whiteColor tap:NO shadow:YES];
    [textView appendAttributedString:chengweiString];
    [textView appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@" "]];
    
    textView.yy_paragraphStyle = paraStyle;
    
    self.msgAttribText = textView;
    
    [self YYTextLayoutSize:self.msgAttribText];
}
- (void)Manager_Promotion{
    NSMutableParagraphStyle *paraStyle = [self paragraphStyle];
    paraStyle.lineSpacing = 3.0f;//行间距
    NSMutableAttributedString *textView = [[NSMutableAttributedString alloc] initWithString:@""];
    // 恭喜
    NSMutableAttributedString *gongxiString = [self getAttributed:[NSString stringWithFormat:@"%@ ", @"恭喜"] font:self.font color:UIColor.redColor tap:NO shadow:YES];
    [textView appendAttributedString:gongxiString];
    //名字
    NSMutableAttributedString *nameAttribute = [self getAttributed:[NSString stringWithFormat:@"%@：", self.msgModel.user.nickName] font:self.font color:MsgLbColor tap:YES shadow:YES];
    [textView appendAttributedString:nameAttribute];
    
    // 等级
    NSMutableAttributedString *level = [self getAttachText:[[TPImageManager sharedInstance] imageForLevel:self.msgModel.user.level] tap:NO];
    [textView appendAttributedString:level];
    [textView appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
        /**徽章*/
    [self addTipImage:textView];
    // 成功升级，感恩粉丝们的青睐~
    NSMutableAttributedString *chengweiString = [self getAttributed:[NSString stringWithFormat:@"%@ ", @"成功升级，感恩粉丝们的青睐~"] font:self.font color:UIColor.whiteColor tap:NO shadow:YES];
    [textView appendAttributedString:chengweiString];
    [textView appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@" "]];
    
    textView.yy_paragraphStyle = paraStyle;
    
    self.msgAttribText = textView;
    
    [self YYTextLayoutSize:self.msgAttribText];
}
/// 守护
- (void)Type_Guard{
    NSMutableParagraphStyle *paraStyle = [self paragraphStyle];
    paraStyle.lineSpacing = 3.0f;//行间距
    NSMutableAttributedString *textView = [[NSMutableAttributedString alloc] initWithString:@""];
    // 恭喜
    NSMutableAttributedString *gongxiString = [self getAttributed:[NSString stringWithFormat:@"%@ ", @"恭喜"] font:self.font color:UIColor.redColor tap:NO shadow:YES];
    [textView appendAttributedString:gongxiString];
    //名字
    NSMutableAttributedString *nameAttribute = [self getAttributed:[NSString stringWithFormat:@"%@：", self.msgModel.user.nickName] font:self.font color:MsgLbColor tap:YES shadow:YES];
    [textView appendAttributedString:nameAttribute];
    
    // 等级
    NSMutableAttributedString *level = [self getAttachText:[[TPImageManager sharedInstance] imageForLevel:self.msgModel.user.level] tap:NO];
    [textView appendAttributedString:level];
    [textView appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
//    if (self.tipImages.count > 0) {
        /**徽章*/
        [self addTipImage:textView];
//    }
    
    // 成为了
    NSMutableAttributedString *chengweiString = [self getAttributed:[NSString stringWithFormat:@"%@ ", @"成为了"] font:self.font color:UIColor.whiteColor tap:NO shadow:YES];
    [textView appendAttributedString:chengweiString];
    [textView appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@" "]];

    //礼物接收用户
    
    if (_msgModel.receivedUser) {
        NSMutableAttributedString *receive = [self getAttributed:self.msgModel.receivedUser.nickName font:self.font color:MsgLbColor tap:YES shadow:NO];
        [textView appendAttributedString:receive];

    }
    else{
        NSMutableAttributedString *receive = [self getAttributed:@"主播" font:self.font color:UIColor.cyanColor tap:YES shadow:NO];
        [textView appendAttributedString:receive];
    }
    
    // 的de
    NSMutableAttributedString *deString = [self getAttributed:[NSString stringWithFormat:@"%@ ", @"的"] font:self.font color:UIColor.whiteColor tap:NO shadow:YES];
    [textView appendAttributedString:deString];
    
    // 守护名字代号
    NSMutableAttributedString *GuardNameString = [self getAttributed:[NSString stringWithFormat:@"%@ ", self.msgModel.GuardName] font:self.font color:UIColor.grayColor tap:NO shadow:YES];
    [textView appendAttributedString:GuardNameString];
    
    textView.yy_paragraphStyle = paraStyle;
    
    self.msgAttribText = textView;
    
    [self YYTextLayoutSize:self.msgAttribText];
}
/// 系统消息- 官方通知
- (void)systemMsg{
    NSMutableAttributedString *textView = [[NSMutableAttributedString alloc] initWithString:@""];
    NSMutableParagraphStyle *paraStyle = [self paragraphStyle];
    textView.yy_paragraphStyle = paraStyle;
    paraStyle.lineSpacing = 5.0f;//行间距
    // 名字
    NSString *firstStr = [NSString stringWithFormat:@"%@：",  @"人人直播"];
    NSMutableAttributedString *name = [self getAttributed:firstStr font:self.font color:UIColor.yellowColor tap:NO shadow:NO];
    // 内容
    NSMutableAttributedString *content = [self getAttributed:self.msgModel.content font:self.font color:RGBAOF(0xC6FFF3, 1.0) tap:NO shadow:YES];
    
    [textView appendAttributedString:name];
    [textView appendAttributedString:content];
    self.msgAttribText = textView;
    [self YYTextLayoutSize:self.msgAttribText];
    
}
// 关注
- (void)Subscription {
    NSMutableParagraphStyle *paraStyle = [self paragraphStyle];
    paraStyle.lineSpacing = 3.0f;//行间距
    
    NSMutableAttributedString *textView = [[NSMutableAttributedString alloc] initWithString:@""];
    
    //名字
    NSMutableAttributedString *nameAttribute = [self getAttributed:[NSString stringWithFormat:@"%@：", self.msgModel.user.nickName] font:self.font color:MsgLbColor tap:YES shadow:YES];
    [textView appendAttributedString:nameAttribute];
    
    // 等级
    NSMutableAttributedString *level = [self getAttachText:[[TPImageManager sharedInstance] imageForLevel:self.msgModel.user.level] tap:NO];
    [textView appendAttributedString:level];
    [textView appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
//    if (self.tipImages.count > 0) {
        /**徽章*/
        [self addTipImage:textView];
//    }
    // 显示内容
    NSMutableAttributedString *contentString = [self getAttributed:[NSString stringWithFormat:@"%@", @" 关注了主播"] font:self.font color:UIColor.whiteColor tap:NO shadow:YES];
    [textView appendAttributedString:contentString];
    
    textView.yy_paragraphStyle = paraStyle;
    
    self.msgAttribText = textView;
    
    [self YYTextLayoutSize:self.msgAttribText];
}

// 聊天
- (void)Comment {
    NSMutableParagraphStyle *paraStyle = [self paragraphStyle];
    paraStyle.lineSpacing = 3.0f;//行间距
    // 等级
    NSMutableAttributedString *textView = [self getAttachText:[[TPImageManager sharedInstance] imageForLevel:self.msgModel.user.level] tap:YES];
    [textView appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    
    /**徽章*/
    [self addTipImage:textView];
    
    // 名字
    NSString *firstStr = [NSString stringWithFormat:@"%@：",  self.msgModel.user.nickName];
    NSMutableAttributedString *name = [self getAttributed:firstStr font:self.font color:MsgNameColor tap:YES shadow:NO];
    
    // @用户
    if (self.msgModel.atUser) {
        NSString *answerStr = [NSString stringWithFormat:@"@%@ ", self.msgModel.atUser.nickName];
        NSMutableAttributedString *answerName = [self getAttributed:answerStr font:self.font color:MsgLbColor tap:NO shadow:YES];
        [name appendAttributedString:answerName];
    }
    
    // 内容
    NSMutableAttributedString *content = [self getAttributed:self.msgModel.content font:self.font color:MsgTitleColor tap:NO shadow:YES];
    
    [textView appendAttributedString:name];
    [textView appendAttributedString:content];
    textView.yy_paragraphStyle = paraStyle;
    
    self.msgAttribText = textView;
    
    [self YYTextLayoutSize:self.msgAttribText];
}

// 成员加入
- (void)MemberEnter {
    NSMutableParagraphStyle *paraStyle = [self paragraphStyle];
    paraStyle.lineSpacing = 3.0f;//行间距
    //登记
    NSMutableAttributedString *textView = [self getAttachText:[[TPImageManager sharedInstance] imageForLevel:self.msgModel.user.level] tap:YES];
    [textView appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    
    if (self.tipImages.count > 0) {
        /**徽章*/
        [self addTipImage:textView];
    }
    // 名字
    NSMutableAttributedString *nameAttribute = [self getAttributed:[NSString stringWithFormat:@"%@：", self.msgModel.user.nickName] font:self.font color:MsgLbColor tap:YES shadow:YES];
    [textView appendAttributedString:nameAttribute];
    
    // 坐骑
    if ([self.msgModel.user.mount length]) {
        NSMutableAttributedString *mountAction = [self getAttributed:[NSString stringWithFormat:@"骑着 "] font:self.font color:UIColor.whiteColor tap:NO shadow:NO];
        NSMutableAttributedString *mountNameAttribute = [self getAttributed:[NSString stringWithFormat:@"%@", self.msgModel.user.mount] font:self.font color:UIColor.yellowColor tap:YES shadow:YES];
        [textView appendAttributedString:mountAction];
        [textView appendAttributedString:mountNameAttribute];
    }
    // 显示内容
    NSMutableAttributedString *contentString = [self getAttributed:[NSString stringWithFormat:@"%@", @" 进入了直播间"] font:self.font color:UIColor.whiteColor tap:NO shadow:YES];
    [textView appendAttributedString:contentString];
    
    textView.yy_paragraphStyle = paraStyle;
    
    self.msgAttribText = textView;
    
    [self YYTextLayoutSize:self.msgAttribText];
}

// 礼物消息
- (void)Gift_Text {
    
    NSMutableParagraphStyle *paraStyle = [self paragraphStyle];
    paraStyle.lineSpacing = 3.0f;//行间距
    
    NSMutableAttributedString *textView = [[NSMutableAttributedString alloc] initWithString:@""];
    
    //名字
    NSMutableAttributedString *nameAttribute = [self getAttributed:[NSString stringWithFormat:@"%@：", self.msgModel.user.nickName] font:self.font color:MsgLbColor tap:YES shadow:YES];
    [textView appendAttributedString:nameAttribute];
    
    // 等级
    NSMutableAttributedString *level = [self getAttachText:[[TPImageManager sharedInstance] imageForLevel:self.msgModel.user.level] tap:NO];
    [textView appendAttributedString:level];
    [textView appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    
    /**徽章*/
    [self addTipImage:textView];
    NSMutableAttributedString *giveAttText = [self getAttributed:@" 送给" font:self.font color:MsgLbColor tap:NO shadow:YES];
    
    [textView appendAttributedString:giveAttText];
    
    //礼物接收用户
    
    if (_msgModel.receivedUser) {
        NSMutableAttributedString *receive = [self getAttributed:self.msgModel.receivedUser.nickName font:self.font color:MsgLbColor tap:YES shadow:NO];
        [textView appendAttributedString:receive];

    }
    else{
        NSMutableAttributedString *receive = [self getAttributed:@"主持人" font:self.font color:UIColor.cyanColor tap:YES shadow:NO];
        [textView appendAttributedString:receive];
    }
    //礼物个数
    NSMutableAttributedString *countText;
    int i = [self.msgModel.quantity intValue];
    NSString *giftX = [NSString stringWithFormat:@"%d个",i>0?i:1];
    countText = [self getAttributed:giftX font:self.font color:MsgLbColor tap:NO shadow:YES];
    [textView appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    [textView appendAttributedString:countText];
    [textView appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    
    //礼物名字
    
    NSMutableAttributedString *giftName = [self getAttributed:self.msgModel.giftModel.name font:self.font color:MsgLbColor tap:YES shadow:NO];
    [textView appendAttributedString:giftName];
    [textView appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];

    /**礼物图片*/
    UIImage *gifImage;// = [UIImage imageWithColor:[UIColor clearColor] widthHeight:19];
    if (self.giftImage) {
        gifImage = self.giftImage;
    }
    
    CGSize size = CGSizeMake(19, 22);
    UIImage *newImage = [self scaleToSize:size image:gifImage];
    NSMutableAttributedString *gifImageStr = [self getAttachText:newImage tap:NO];
   
    [textView appendAttributedString:gifImageStr];
    
    self.msgAttribText = textView;
    // 获取高度 宽度
    [self YYTextLayoutSize:self.msgAttribText];
}

// 客户端提示消息 由客户端定时器触发
- (void)Announcement {
    NSString *msgText = self.msgModel.content;
    NSMutableAttributedString *attribute = [self getAttributed:msgText font:self.font color:MsgTitleColor tap:NO shadow:NO];
    self.msgAttribText = attribute;
    
    // 获取高度 宽度
    [self YYTextLayoutSize:self.msgAttribText];
}

// 文字阴影效果
- (YYTextShadow *)getTextShadow {
    YYTextShadow *shadow = [[YYTextShadow alloc] init];
    //shadow.shadowBlurRadius = 1;
    shadow.offset = CGSizeMake(0, 0.5);
    shadow.color = RGBAOF(0x000000, 0.5);
    
    return shadow;
}

/**
 字符串生成富文本
 @param isTap 是否添加点击事件
 @param isShadow 是否添加文字投影效果
 */
- (NSMutableAttributedString *)getAttributed:(NSString *)text font:(UIFont *)font color:(UIColor *)color tap:(BOOL)isTap shadow:(BOOL)isShadow {
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
    attribute.yy_font = font;
    attribute.yy_color = color;
    // 强制排版(从左到右)
    attribute.yy_baseWritingDirection = NSWritingDirectionLeftToRight;
    attribute.yy_writingDirection = @[@(NSWritingDirectionLeftToRight | NSWritingDirectionOverride)];
    attribute.yy_paragraphStyle = [self paragraphStyle];
    
    if (isShadow) {
        attribute.yy_textShadow = [self getTextShadow];
    }
    
    if (isTap) {
        WeakSelf;
        YYTextHighlight *highlight = [[YYTextHighlight alloc] init];
        highlight.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(msgAttributeTapAction:)]) {
                [weakSelf.delegate msgAttributeTapAction:[NSString stringWithFormat:@"%@",[text.string substringWithRange:range]]];
            }
        };
        [attribute yy_setTextHighlight:highlight range:attribute.yy_rangeOfAll];
    }
    
    return attribute;
}

// 图片、view生成富文本
- (NSMutableAttributedString *)getAttachText:(UIImage *)image tap:(BOOL)isTap {
    NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:self.font alignment:YYTextVerticalAlignmentCenter];
    // 强制排版(从左到右)
    attachText.yy_baseWritingDirection = NSWritingDirectionLeftToRight;
    attachText.yy_writingDirection = @[@(NSWritingDirectionLeftToRight | NSWritingDirectionOverride)];
    attachText.yy_paragraphStyle = [self paragraphStyle];
    
    if (isTap) {
        WeakSelf;
        YYTextHighlight *highlight = [YYTextHighlight new];
        highlight.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(msgAttributeTapAction:)]) {
                [weakSelf.delegate msgAttributeTapAction:@""];
            }
        };
        [attachText yy_setTextHighlight:highlight range:attachText.yy_rangeOfAll];
    }
    
    return attachText;
}

// 将个人标签生成富文本
- (void)addTipImage:(NSMutableAttributedString *)attachText {
    CGFloat lineH = 14;
    
    UIImage *img1 =  [[TPImageManager sharedInstance] imageForLevel:12];
    UIImage *img2 =  [[TPImageManager sharedInstance] imageForLevel:13];
    self.tipImages = @[img1,img2];
    
    for (UIImage *image in self.tipImages) {
        if (![image isKindOfClass:[UIImage class]]) {
            continue;
        }
        CGFloat scale = image.size.height / lineH;
        CGSize size = CGSizeMake(image.size.width / scale, lineH);
        UIImage *newImage = [self scaleToSize:size image:image];
        NSMutableAttributedString *labs = [self getAttachText:newImage tap:YES];
        [attachText appendAttributedString:labs];
        [attachText appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    }
}
#pragma mark ----- 获取cell高度
- (void)YYTextLayoutSize:(NSMutableAttributedString *)attribText {
    // 距离左边8  距离右边也为8
    CGFloat maxWidth = MsgTableViewWidth - Lable_LeftSpace - Lable_RightSpace;
    
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(maxWidth, MAXFLOAT) text:attribText];
    CGSize size = layout.textBoundingSize;
    
    if (size.height && size.height < 24) {
        size.height = 24;
    }
    else{
        size.height = size.height + Lable_TopSpace + Lable_BomSpace;
    }
    
    self.msgHeight = size.height;
    self.msgWidth = size.width;
}


#pragma mark ----- 方法
- (NSMutableParagraphStyle *)paragraphStyle {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = 0.0f;//行间距
    // 强制排版(从左到右)
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.baseWritingDirection = NSWritingDirectionLeftToRight;
    
    return paraStyle;
}
#pragma mark - 图片标签下载
/** 下载礼物缩略图 */
- (void)downloadGiftImage {
    NSString *urlStr = self.msgModel.giftModel.thumbnailUrl;
    if (!urlStr || urlStr.length < 1) {
        return;
    }
    if (self.finishDownloadGiftImg) {
        return;
    }
    self.finishDownloadGiftImg = YES;
    
    // 1. 如果本地有图片
    self.giftImage = [self cacheImage:urlStr];
    if (self.giftImage) {
        return;
    }
    
    // 2. 下载远程图片
    NSURL *url = [NSURL URLWithString:urlStr];
    WeakSelf
    id sdLoad = [[SDWebImageManager sharedManager] loadImageWithURL:url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        if (image){
            // 刷新UI
            weakSelf.giftImage = image;
            // 更新属性文字
            [weakSelf downloadTagImageFinish];
        }
    }];
    [self.tempLoads addObject:sdLoad];
}

/// 下载标签图片
- (void)downloadTagImage {
    // 这里的逻辑和下载礼物缩略图同样的逻辑
}

- (void)downloadTagImageFinish {
    // 更新属性文字
    [self msgUpdateAttribute];
    // 通知代理刷新属性文字
    if (self.delegate && [self.delegate respondsToSelector:@selector(attributeUpdated:)]) {
        [self.delegate attributeUpdated:self];
    }
}

- (void)dealloc {
    for (id<SDWebImageOperation> item in self.tempLoads) {
        [item cancel];
    }
    // NSLog(@"dealloc-----%@", NSStringFromClass([self class]));
}

#pragma mark - TOOL
- (UIImage *)cacheImage:(NSString *)urlStr {
    // 缓存的图片（内存）
    UIImage *image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:urlStr];
    
    // 缓存的图片（硬盘）
    if (!image) {
        image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:urlStr];
    }
    
    return image;
}

// 像这些方法你可以提取到UIImage分类中，
- (UIImage *)scaleToSize:(CGSize)size image:(UIImage *)image
{
    // 创建一个bitmap的context
    UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage * scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}


@end
