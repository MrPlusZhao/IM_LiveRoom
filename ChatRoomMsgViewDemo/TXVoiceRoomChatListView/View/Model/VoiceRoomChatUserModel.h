//
//  VoiceRoomChatUserModel.h
//  ChatRoomMsgViewDemo
//
//  Created by ztp on 2021/10/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VoiceRoomChatUserModel : NSObject

@property (nonatomic, copy) NSString    *nickName;
@property (nonatomic, copy) NSString    *userID;
@property (nonatomic, assign) NSInteger level;
/// 0：男    1：女
@property (nonatomic, assign) NSInteger gender;
///坐骑
@property (nonatomic, copy) NSString    *mount;
@end

NS_ASSUME_NONNULL_END
