//
//  TXVoiceRoomGiftUserHeadCell.m
//  ChatRoomMsgViewDemo
//
//  Created by ztp on 2021/11/2.
//

#import "TXVoiceRoomGiftUserHeadCell.h"

@implementation TXVoiceRoomGiftUserHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = UIColor.clearColor;
    self.headImgView.layer.cornerRadius = 15;
    self.headImgView.layer.borderColor = UIColor.redColor.CGColor;
    self.headImgView.layer.borderWidth = 0.5;
}

@end
