//
//  TXVoiceRoomMsgBaseCell.m
//  ChatRoomMsgViewDemo
//
//  Created by ztp on 2021/10/14.
//

#import "TXVoiceRoomMsgBaseCell.h"
#import <Masonry/Masonry.h>
#import "VoiceRoomMsgCommentCell.h"

@interface TXVoiceRoomMsgBaseCell ()<VoiceRoomChatAttributeModelDelegate>

@end

@implementation TXVoiceRoomMsgBaseCell

+ (TXVoiceRoomMsgBaseCell *)initMsgCell:(UITableView *)tableView cellForType:(VoiceRoomMsgType)type indexPath:(NSIndexPath *)indexPath {
    NSString *identityName = [NSString stringWithFormat:@"%@_%ld", [self msgCellIdentifier], type];
    [tableView registerClass:[self class] forCellReuseIdentifier:identityName];

    TXVoiceRoomMsgBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:identityName forIndexPath:indexPath];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identityName];
    }
    return cell;
}

+ (TXVoiceRoomMsgBaseCell *)tableView:(UITableView *)tableView cellForMsg:(VoiceRoomChatMsgModel *)msg indexPath:(NSIndexPath *)indexPath delegate:(id<VoiceRoomMsgBaseCellGesDelegate>)delegate {

    TXVoiceRoomMsgBaseCell *cell = nil;
    VoiceRoomMsgType type = msg.subType;
    switch (type) {
        case VoiceRoomMsgType_Member_Comment:
        { // 普通文本
            cell = [VoiceRoomMsgCommentCell initMsgCell:tableView cellForType:type indexPath:indexPath];
        }
            break;
        default:
            cell = [TXVoiceRoomMsgBaseCell initMsgCell:tableView cellForType:type indexPath:indexPath];
            break;
    }
    cell.delegate = delegate;
    cell.msgModel = msg;

    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle  = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.bgImageView];
        [self.contentView addSubview:self.msgLabel];

        [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(Lable_TopSpace);
            make.left.mas_equalTo(Lable_LeftSpace);
            make.bottom.mas_equalTo(-Lable_BomSpace);
            make.right.mas_lessThanOrEqualTo(-Lable_RightSpace);
        }];

        [self.bgImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(BG_TopSpace);
            make.left.mas_equalTo(BG_LeftSpace);
            make.bottom.mas_equalTo(BG_BomSpace);
            make.right.equalTo(self.msgLabel.mas_right).offset(BG_RightSpace);
        }];

        NDViewRadius(self.bgImageView, 12);
    }
    return self;
}
// 富文本点击
- (void)msgAttributeTapAction:(NSString*)content{
    NSLog(@"点击富文本");
    if (self.delegate && [self.delegate respondsToSelector:@selector(userClick:)]) {
        [self.delegate userClick:self.msgModel.user];
    }
}

- (void)setMsgModel:(VoiceRoomChatMsgModel *)msgModel {
    _msgModel = msgModel;
    _msgModel.attributeModel.delegate = self;
    self.msgLabel.attributedText = msgModel.attributeModel.msgAttribText;
    self.bgImageView.backgroundColor = msgModel.attributeModel.bgColor;
}
//#pragma mark - NDMsgAttributeModelDelegate
- (void)attributeUpdated:(VoiceRoomChatAttributeModel *)model {
    if ([self.msgModel.msgID isEqualToString:model.msgModel.msgID]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(msgAttrbuiteUpdated:)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
               [self.delegate msgAttrbuiteUpdated:self.msgModel];
            });
        }
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.delegate && [self.delegate respondsToSelector:@selector(touchMsgCellView)]) {
        [self.delegate touchMsgCellView];
    }
}

/// 添加长按点击事件
- (void)addLongPressGes {
    //self.userInteractionEnabled = YES;
    self.msgLabel.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGes:)];
    longPressGes.minimumPressDuration = 0.3;
    [self.msgLabel addGestureRecognizer:longPressGes];
}
/// 长按手势
- (void)longPressGes:(UILongPressGestureRecognizer *)longGes {
    if (self.delegate && [self.delegate respondsToSelector:@selector(longPressGes:)]) {
        [self.delegate longPressGes:self.msgModel];
    }
}

- (YYLabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[YYLabel alloc] init];
        _msgLabel.numberOfLines = 0;
        _msgLabel.backgroundColor = [UIColor clearColor];
        _msgLabel.clipsToBounds = YES;
        _msgLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
        _msgLabel.userInteractionEnabled = YES;
        // 强制排版(从左到右)
        _msgLabel.semanticContentAttribute = UISemanticContentAttributeForceLeftToRight;
        _msgLabel.backgroundColor = UIColor.clearColor;
    }
    return _msgLabel;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.userInteractionEnabled = NO;
    }
    return _bgImageView;
}
- (void)dealloc {
    NSLog(@"dealloc-----%@", NSStringFromClass([self class]));
}
+ (NSString *)msgCellIdentifier {
    return NSStringFromClass([self class]);
}

@end
