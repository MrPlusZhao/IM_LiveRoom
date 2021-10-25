//
//  TipCollectionItemCell.m
//  ChatRoomMsgViewDemo
//
//  Created by ztp on 2021/10/22.
//

#import "TipCollectionItemCell.h"
#import "TPImageManager.h"

@implementation TipCollectionItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tipImageView.layer.cornerRadius = 2;
    self.tipImageView.image = [[TPImageManager sharedInstance] imageForLevel:55];
}

@end
