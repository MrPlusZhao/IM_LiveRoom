//
//  VoiceRoomChatMsgModel.m
//  ChatRoomMsgViewDemo
//
//  Created by ztp on 2021/10/15.
//

#import "VoiceRoomChatMsgModel.h"

@implementation VoiceRoomChatMsgModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.subType = -1;
    }
    return self;
}
- (void)initMsgAttribute {
    self.attributeModel = [[VoiceRoomChatAttributeModel alloc] initWithMsgModel:self];
}

@end
