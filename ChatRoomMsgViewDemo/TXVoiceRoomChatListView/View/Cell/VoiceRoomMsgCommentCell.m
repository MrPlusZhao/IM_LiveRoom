//
//  VoiceRoomMsgCommentCell.m
//  ChatRoomMsgViewDemo
//
//  Created by ztp on 2021/10/15.
//

#import "VoiceRoomMsgCommentCell.h"
#import "VoiceRoomChatMsgModel.h"

@interface VoiceRoomMsgCommentCell ()

@end

@implementation VoiceRoomMsgCommentCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
    NSLog(@" 输出点击的view的类名%@", NSStringFromClass([touch.view class]));
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"] || [NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCell"]) {
        return NO;
    }
    return  YES;
}
// 富文本点击
- (void)msgAttributeTapAction:(NSString*)content{
    NSLog(@"点击富文本");
    if (self.delegate && [self.delegate respondsToSelector:@selector(userClick:)]) {
        [self.delegate userClick:self.msgModel.user];
    }
}
- (void)setMsgModel:(VoiceRoomChatMsgModel *)msgModel {
    [super setMsgModel:msgModel];
    self.msgLabel.attributedText = msgModel.attributeModel.msgAttribText;
    self.bgImageView.image = nil;
    self.bgImageView.backgroundColor = [UIColor orangeColor];
    self.bgImageView.layer.borderColor = [UIColor cyanColor].CGColor;
    self.bgImageView.layer.borderWidth = 0.0;
    self.bgImageView.alpha = 0.2;
}
@end
