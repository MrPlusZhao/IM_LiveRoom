//
//  TXVoiceRoomGiftItemCell.h
//  ChatRoomMsgViewDemo
//
//  Created by ztp on 2021/10/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXVoiceRoomGiftItemCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *giftImageView;
@property (weak, nonatomic) IBOutlet UILabel *giftNameLab;
@property (weak, nonatomic) IBOutlet UIImageView *lucyTipImageView;

@property (weak, nonatomic) IBOutlet UIView *quanBgView;
@property (weak, nonatomic) IBOutlet UIView *guoBgView;
@property (weak, nonatomic) IBOutlet UIView *nomarlBgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *quanBgToTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *guoBgToTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nomarlBgToTop;

@property (nonatomic, assign) NSInteger type;
@end

NS_ASSUME_NONNULL_END
